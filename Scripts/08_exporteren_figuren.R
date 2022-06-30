#
# Exporteren figuren
#

ggsave(
  plot = plot_verzuim_fit,
  filename = str_glue("Resultaten/Ziekteverzuim_bedrijfstak_fit_tm{max(data_verzuim$Week)}.png"),
  width = 1280, height = 720, units = "px", dpi = 100)

ggsave(
  plot = plot_verzuim_tijdreeks_fit,
  filename = str_glue("Resultaten/Ziekteverzuim_bedrijfstak_tijdreeks_fit_tm{max(data_verzuim$Week)}.png"),
  width = 1280, height = 720, units = "px", dpi = 100)

ggsave(
  plot = plot_verzuim_tijdreeks,
  filename = str_glue("Resultaten/Ziekteverzuim_bedrijfstak_tijdreeks_tm{max(data_verzuim$Week)}.png"),
  width = 1280, height = 720, units = "px", dpi = 100)
