#
# Verzuim per bedrijfstak
# Relatie met dagelijkse infectieradar % klachten
#

source(file = "Scripts/01_initialiseren.R")
source(file = "Scripts/02_importeer_data.R")
source(file = "Scripts/03_opschonen_data_symptomen.R")
source(file = "Scripts/04_opschonen_data_verzuim.R")
source(file = "Scripts/05_fit_modellen.R")
source(file = "Scripts/06a_voorspel_fit.R")
source(file = "Scripts/06b_voorspel_tijdreeks.R")
source(file = "Scripts/07a_visualiseer_fit.R")
source(file = "Scripts/07b_visualiseer_tijdreeks_fit.R")
source(file = "Scripts/07c_visualiseer_tijdreeks_verzuim.R")
source(file = "Scripts/08_exporteren_figuren.R")
