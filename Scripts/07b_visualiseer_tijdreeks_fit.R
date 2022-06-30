#
# Visualiseer tijdreeks van fit
#

plot_verzuim_tijdreeks_fit <- ggplot(
  data = data_verzuim_pred_tijdreeks %>%
    filter(Week >= ymd("2020-10-26")),
  mapping = aes(x = Week, ymin = lwr, ymax = upr)) +
  geom_ribbon(
    fill = 4,
    alpha = 0.5) +
  geom_line(
    mapping = aes(y = fit),
    colour = "black",
    size = 0.25) +
  geom_point(
    mapping = aes(y = Perc_symptomen),
    size = 0.25,
    colour = "navy") +
  scale_x_date(
    breaks = seq(ymd("2020-01-01"), ymd("2023-01-01"), by = "3 months"),
    date_minor_breaks = "1 month",
    date_labels = "%b '%y") +
  scale_y_continuous(
    breaks = seq(from = 0, to = 10, by = 2),
    minor_breaks = 0:10,
    limits = c(0, NA)) +
  facet_wrap(
    facets = vars(Bedrijfstak),
    labeller = label_wrap_gen(width = 40)) +
  labs(
    title = "Wekelijks gemiddelde percentage deelnemers met COVID-19-achtige klachten in Infectieradar",
    subtitle = "Punten: gerapporteerd. Getrokken lijn: voorspeld op basis van verzuim met 95% predictie-interval",
    x = "Datum",
    y = "Wekelijks gemiddelde percentage deelnemers met COVID-19-achtige klachten in Infectieradar") +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

print(plot_verzuim_tijdreeks_fit)
