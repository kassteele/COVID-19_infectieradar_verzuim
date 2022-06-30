#
# Visualiseer tijdreeks van verzuim
#

plot_verzuim_tijdreeks <- ggplot(
  data = data_verzuim %>%
    filter(Week >= ymd("2020-10-26")),
  mapping = aes(x = Week, y = Perc_verzuim)) +
  geom_line(
    size = 0.5,
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
    title = "Wekelijks gerapporteerd gemiddelde percentage verzuim per bedrijfstak",
    x = "Datum",
    y = "Wekelijks gemiddelde percentage per") +
  theme(
    axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

print(plot_verzuim_tijdreeks)
