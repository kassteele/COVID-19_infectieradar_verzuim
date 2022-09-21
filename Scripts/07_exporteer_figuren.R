#
# Exporteer figuren
#

ggsave(
  plot = plot_verzuim_tijdreeks_fit,
  filename = str_glue("Output/Infectieradar_verzuim_{format(max_week, '%Y%m%d')}.png"),
  width = 1920, height = 1080, units = "px", dpi = 120, bg = "white")
