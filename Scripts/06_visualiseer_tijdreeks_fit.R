#
# Visualiseer tijdreeks fit
#

plot_verzuim_tijdreeks_fit <- ggplot(
  data = data_verzuim_tijdreeks_fit %>%
    # Omdat de componenten in wide format staan,
    # moeten we die eerst in long format zetten
    pivot_longer(
      cols = starts_with("comp"),
      names_to = "Component",
      values_to = "Percentage verzuim") %>%
    # Hernoem de componenten naar iets leesbaars, e.g.
    # comp_harm -> Seizoenseffect
    # comp_cov -> Infectieradar
    mutate(
      Component = Component %>%
        factor(
          levels = c("comp_ar", "comp_cov", "comp_harm", "comp_trend"),
          labels = c("Autoregressief\neffect", "Percentage klachten\nInfectieradar", "Seizoenseffect", "Grootschalige\ntrend"))),
  mapping = aes(x = Week, y = `Percentage verzuim`, fill = Component)) +
  geom_area() +
  geom_point(
    data = data_verzuim_tijdreeks_fit,
    mapping = aes(x = Week, y = Perc_verzuim),
    shape = "+",
    size = 2,
    inherit.aes = FALSE) +
  scale_fill_discrete_sequential(
    palette = "ag_GrnYl",
    rev = FALSE) +
  scale_x_date(
    breaks = seq(ymd("2020-01-01"), ymd("2023-01-01"), by = "3 months"),
    date_minor_breaks = "1 month",
    date_labels = "%b '%y") +
  scale_y_continuous(
    breaks = seq(from = 0, to = 0.1, by = 0.02),
    minor_breaks = seq(from = 0.01, to = 0.09, by = 0.02),
    labels = scales::percent) +
  facet_wrap(
    facets = vars(Bedrijfstak),
    nrow = 4, ncol = 5,
    labeller = label_wrap_gen(width = 50)) +
  labs(
    title = "Wekelijks gemiddelde percentage verzuim per bedrijfstak",
    subtitle = "Punten: gerapporteerd\nVlakken: tijdreekscomponenten",
    x = "Datum",
    y = "Percentage verzuim",
    fill = NULL) +
  guides(
    fill = guide_legend(
      keyheight = 2)) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

# Plot
print(plot_verzuim_tijdreeks_fit)
