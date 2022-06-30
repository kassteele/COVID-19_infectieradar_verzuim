#
# Visualiseer fit
#

plot_verzuim_fit <- ggplot() +
  geom_ribbon(
    data = data_verzuim_pred_fit,
    mapping = aes(x = Perc_verzuim, ymin = lwr, ymax = upr),
    fill = 4,
    alpha = 0.5) +
  geom_point(
    data = data_verzuim %>% drop_na(),
    mapping = aes(x = Perc_verzuim, y = Perc_symptomen),
    size = 0.2,
    colour = "navy") +
  geom_line(
    data = data_verzuim_pred_fit,
    mapping = aes(x = Perc_verzuim, y = fit),
    size = 0.25) +
  scale_y_continuous(
    breaks = seq(from = 0, to = 10, by = 2),
    minor_breaks = 0:10,
    limits = c(0, NA)) +
  facet_wrap(
    facets = vars(Bedrijfstak),
    scales = "free_x",
    labeller = label_wrap_gen(width = 40)) +
  labs(
    title = "Wekelijks gemiddelde percentage deelnemers met COVID-19-achtige klachten in Infectieradar vs. percentage ziekteverzuim",
    x = "Wekelijks percentage ziekteverzuim",
    y = "Wekelijks gemiddelde percentage deelnemers met COVID-19-achtige klachten in Infectieradar")

print(plot_verzuim_fit)
