#
# Voorspelling tbv fit
#

# Maak lijst van tibbles om voor te voorspellen
data_verzuim_pred_fit <- data_verzuim %>%
  na.omit() %>%
  split(
    f = .$Bedrijfstak) %>%
  map(
    ~ tibble(
      Bedrijfstak = .x$Bedrijfstak[1],
      Perc_verzuim = exp(seq(from = log(min(.x$Perc_verzuim)), to = log(max(.x$Perc_verzuim)), length = 20))))

# Maak de voorspellingen
data_verzuim_pred_fit <- map2_dfr(
  .x = fit_verzuim,
  .y = data_verzuim_pred_fit,
  .f = ~
    bind_cols(
      .y,
      # Deze zijn op de log-schaal!
      predict(
        object = .x,
        newdata = .y,
        se.fit = TRUE) %>%
        as_tibble()) %>%
    mutate(
      # Bereken de 95% predictie intervallen
      # Transformeer terug naar de originele schaal
      lwr = exp(fit + qt(p = 0.025, df = .x$df.residual)*sqrt(se.fit^2 + .x$sig2)),
      upr = exp(fit + qt(p = 0.975, df = .x$df.residual)*sqrt(se.fit^2 + .x$sig2)),
      fit = exp(fit))) #%>%
  # mutate(
  #   # Sorteer Bedrijfstak
  #   # Hoogste geextrapoleerde fit komt als eerste
  #   Bedrijfstak = Bedrijfstak %>%
  #     fct_reorder(
  #       .x = fit,
  #       .fun = max,
  #       .desc = TRUE,
  #       na.rm = TRUE))
