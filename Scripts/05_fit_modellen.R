#
# Fit modellen
#

# De tijdreeks per bedrijfstak wordt ontbonden in vier componenten:
# 1. Grootschalige tijdstrend
# 2. Seizoenseffect
# 3. Effect van de covariaat, hier percentage klachten uit Infectieradar
# 4. Autoregressieve component o.b.v. verzuim voorgaan de week(en)
#
# Bij elkaar opgeteld levert dit de fit op
# De residuen mogen geen autocorrelatie meer vertonen

# Stap 1
# Maak alle combinaties van mogelijke regressiemodellen
# Dit betreft de componenten 1 t/m 3
xreg_modellen <- expand_grid(
  trend_df = 0:2,   # Trend: constant, lineair of eenvoudige spline
  harm_sin1 = 0:1,  # Harmonische term: geen of periode 1 jaar (sin)
  harm_cos1 = 0:1,  # Harmonische term: geen of periode 1 jaar (cos)
  harm_sin2 = 0:1,  # Harmonische term: geen of periode 1/2 jaar (sin)
  harm_cos2 = 0:1,  # Harmonische term: geen of periode 1/2 jaar (cos)
  cov_df = 1:2) %>% # Covariaat effect: lineair of eenvoudige spline
  filter(
    # Geen 1/2 jaars harmonische term als er 1-jaars periode is
    !((harm_sin2 == 1 | harm_cos2 == 1) & harm_cos1 == 0 & harm_sin1 == 0)) %>%
  mutate(
    # Includeer bij de trend altijd een intercept
    # Deze wordt vanzelf toegevoegd bij het maken van de modelmatrix
    # Toch, als trend_df == 0, zet de formule op ~ 1,
    # anders krijgen we een foutmelding bij het maken van de modelmatrix
    formula_trend = if_else(trend_df == 0, "~ 1", str_c("~ ns(t, df = ", trend_df, ")")),
    # Excludeer bij harmonische term de intercept: ~ 0
    # Anders het model niet identificeerbaar
    formula_harm = str_c(
      "~ 0",
      if_else(harm_sin1 == 0, "", "+ sin(2*pi*t/p_seizoen)"),
      if_else(harm_cos1 == 0, "", "+ cos(2*pi*t/p_seizoen)"),
      if_else(harm_sin2 == 0, "", "+ sin(4*pi*t/p_seizoen)"),
      if_else(harm_cos2 == 0, "", "+ cos(4*pi*t/p_seizoen)")),
    # Excludeer bij covariaat effect de intercept: ~ 0
    # Anders het model niet identificeerbaar
    formula_cov = str_c("~ 0 + ns(Perc_symptomen, df = ", cov_df, ")"),
    # Hier komen straks AIC's van AR(1) t/m AR(4)
    # Wij gaan hier tot maximaal AR(4), meer is niet nodig
    aic_ar1 = NA, aic_ar2 = NA, aic_ar3 = NA, aic_ar4 = NA) %>%
  # Deze mogen nu weg
  select(
    -(trend_df:cov_df))

# Stap 2
# Fit de ARX(p) modellen
# Een ARX(p) model is een AR(p) model met covariaten (X)
# In formulevorm:
# y_t - sum(X_t*beta) = phi_1*[y_{t-1} - sum(X_{t-1}*beta)] + ... + phi_p*[y_{t-p} - sum(X_{t-p}*beta)] + epsilon_t

# Parallele loop over Bedrijfstak
# Dit duurt eventjes... ondanks dat het parallel gebeurt
# Opm: mclappy() werkt alleen op Linux machines
data_verzuim_tijdreeks_fit <- mclapply(
  # Split data_verzuim op Bedrijfstak
  X = data_verzuim %>%
    split(
      f = .$Bedrijfstak),
  # Pas deze functie toe op iedere split
  # data_verzuim_fit is een split van data_verzuim waar de fit op gemaakt wordt
  FUN = function(data_verzuim_fit) {

    # Loop over regressiemodellen
    for (i in 1:nrow(xreg_modellen)) {

      # Kleine voorbereiding voor fit
      data_verzuim_fit <- data_verzuim_fit %>%
        # Verwijder eerst alle records zonder Perc_symptomen
        # Dit zijn de weken waar Infectieradar nog niet actief was
        drop_na(
          Perc_symptomen) %>%
        # t is het aantal weken sinds de 1e week
        # Nodig voor de trend en het seizoenseffect
        mutate(
          t = row_number() - 1)

      # Model matrix trend
      # Hier dus met intercept
      X_trend <- model.matrix(
        object = formula(xreg_modellen[i, ]$formula_trend),
        data = data_verzuim_fit)

      # Model matrix harmonische termen
      # Zonder intercept
      X_harm <- model.matrix(
        object = formula(xreg_modellen[i, ]$formula_harm),
        data = data_verzuim_fit)

      # Model matrix covariaat
      # Zonder intercept
      X_cov <- model.matrix(
        object = formula(xreg_modellen[i, ]$formula_cov),
        data = data_verzuim_fit)

      # Combineer model matrices
      # Deze voeden we aan xreg in de arima() functie
      X <- cbind(X_trend, X_harm, X_cov)

      # Gegeven het regressiedeel, loop over de AR(p) modellen
      for (p in 1:4) {

        # Fit AR(p) model
        # Gebruik xreg voor het regressiedeel
        # Let op dat je geen "gemiddelde" schat, deze zit namelijk al in X
        fit <- arima(
          x = data_verzuim_fit %>% pull(Perc_verzuim),
          order = c(p, 0, 0),
          xreg = X,
          include.mean = FALSE)

        # Bepaal AIC van het betreffende model ARX(p) model
        xreg_modellen[i, str_glue("aic_ar{p}")] <- AIC(fit)

        # Einde AR(p) modellen loop
      }

      # Einde regressiemodellen loop
    }

    # Het beste model heeft de laagste AIC
    # Wel eerst xreg_modellen ombouwen naar long format
    best_model <- xreg_modellen %>%
      pivot_longer(
        cols = starts_with("aic_ar"),
        names_to = "ar",
        values_to = "aic") %>%
      # Kolom ar moet een enkele integer bevatten
      # Die gaan we gebruiken in de uiteindelijke fit
      mutate(
        ar = ar %>% str_sub(start = -1, end = -1) %>% as.integer()) %>%
      slice_min(
        aic)

    # Stap 3
    # Fit uiteindelijke beste model

    # Model matrix trend
    X_trend <- model.matrix(
      object = formula(best_model[1, ]$formula_trend),
      data = data_verzuim_fit)

    # Model matrix harmonische termen
    X_harm <- model.matrix(
      object = formula(best_model[1, ]$formula_harm),
      data = data_verzuim_fit)

    # Model matrix covariaat
    X_cov <- model.matrix(
      object = formula(best_model[1, ]$formula_cov),
      data = data_verzuim_fit)

    # Combineer model matrices
    X <- cbind(X_trend, X_harm, X_cov)

    # Fit beste model
    fit <- arima(
      x = data_verzuim_fit %>% pull(Perc_verzuim),
      order = c(best_model[1, ]$ar, 0, 0),
      xreg = X,
      include.mean = FALSE)

    # Stap 4
    # Bouw componenten

    # Coefficienten
    beta_trend <- fit %>% extract_coef("\\(Intercept\\)|ns\\(t")
    beta_harm  <- fit %>% extract_coef("sin|cos")
    beta_cov   <- fit %>% extract_coef("Perc_symptomen")
    beta_ar    <- fit %>% extract_coef("ar")

    # Waarnemingen
    y <- data_verzuim_fit %>% pull(Perc_verzuim)

    # Regressie componeneten
    # Gebruik drop om er een vector van te maken ipv kolom matrix
    trend <- drop(X_trend %*% beta_trend)
    harm  <- drop(X_harm  %*% beta_harm)
    cov   <- drop(X_cov   %*% beta_cov)

    # AR component
    # De residuen worden gelagd voor de modelmatrix van de AR component
    res  <- y - trend - harm - cov
    X_ar <- beta_ar %>% seq_along() %>% sapply(FUN = lag, x = res)
    ar   <- drop(X_ar %*% beta_ar)

    # Bepaal de laagste waarde van iedere component
    # Dit wordt gebruikt bij de optelling
    min_trend <- min(trend)
    min_harm  <- min(harm)
    min_cov   <- min(cov)
    min_ar    <- min(ar, na.rm = TRUE) # Deze bevat altijd NA's, minimaal 1, maximaal 4

    # Bouw componenten
    # Deze vier termen bij elkaar opgeteld is de uiteindelijke fit
    data_verzuim_fit <- data_verzuim_fit %>%
      mutate(
        comp_trend = trend + min_harm + min_cov + min_ar,
        comp_harm  = harm - min_harm,
        comp_cov   = cov - min_cov,
        comp_ar    = ar - min_ar) %>%
      # Deze hulpvariabele mag nu weg
      select(
        -t)

    # Uitvoer
    return(data_verzuim_fit)

  }) %>%
  # Bind de list aan elkaar tot een tibble
  do.call(what = "rbind")
