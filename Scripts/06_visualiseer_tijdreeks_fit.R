#
# Visualiseer tijdreeks fit
#

plot_verzuim_tijdreeks_fit <- ggplot(
  data = data_verzuim_tijdreeks_plot,
  mapping = aes(x = Week, y = `Percentage verzuim`, fill = Component)) +
  geom_area() +
  geom_point(
    data = data_verzuim_tijdreeks_fit,
    mapping = aes(x = Week, y = Perc_verzuim),
    shape = "+",
    size = 2,
    inherit.aes = FALSE) +
  scale_fill_manual(
    values = c("#8fcae7", "#007bc7", "#b3d7ee", "#d9ebf7")) +
  scale_x_date(
    breaks = seq(ymd("2020-01-01"), ymd("2023-01-01"), by = "3 months"),
    date_minor_breaks = "1 month",
    expand = expansion(add = c(7, 7)),
    date_labels = "%b '%y") +
  scale_y_continuous(
    breaks = seq(from = 0, to = 0.1, by = 0.02),
    minor_breaks = seq(from = 0.01, to = 0.09, by = 0.02),
    labels = scales::percent) +
  facet_wrap(
    facets = vars(Bedrijfstak),
    nrow = 4, ncol = 5) +
  labs(
    title = str_glue("Wekelijks gemiddelde percentage verzuim per bedrijfstak t/m {format(max_week, '%e %B %Y')}"),
    subtitle = "
    Punten: gerapporteerd, tussen haakjes het gemiddelde aantal werknemers over de periode
    Vlakken: verklaard door tijdreekscomponenten",
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
