#
# Masterscript verzuim per bedrijfstak
# Auteur: Jan van de Kassteele
# i.s.m. Hester Korthals Altes en Jacco Wallinga
# RIVM
#

source(file = "Scripts/01_initialiseren.R")
source(file = "Scripts/02_importeer_data.R")
source(file = "Scripts/03_opschonen_data_symptomen.R")
source(file = "Scripts/04_opschonen_data_verzuim.R")
source(file = "Scripts/05_fit_modellen.R")
source(file = "Scripts/06_visualiseer_tijdreeks_fit.R")
source(file = "Scripts/07_exporteer_figuren.R")
