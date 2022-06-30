#
# Fit modellen
#

data_verzuim_fit <- data_verzuim %>%
  split(
    f = .$Bedrijfstak)

fit_verzuim <- data_verzuim_fit %>%
  map(
    .f = ~ gamm(
      formula = log(Perc_symptomen) ~ s(log(Perc_verzuim), bs = "ps", k = 10),
      correlation = corAR1(value = 0.80, fixed = TRUE),
      data = .x)$gam)
