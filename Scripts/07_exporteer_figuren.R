#
# Exporteren figuren
#

ggsave(
  plot = plot_verzuim_tijdreeks_fit,
  filename = str_glue("Resultaten/Ziekteverzuim_bedrijfstak_tijdreeks_fit_tm{max(data_verzuim$Week)}.png"),
  width = 1920, height = 1080, units = "px", dpi = 100, bg = "white")
