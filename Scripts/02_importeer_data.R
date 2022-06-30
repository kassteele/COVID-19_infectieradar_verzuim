#
# Importeer data
#

# Importeer Infectieradar symptomen
data_symptomen_org <- read_delim(
  file = "https://data.rivm.nl/covid-19/COVID-19_Infectieradar_symptomen_per_dag.csv",
  delim = ";",
  show_col_types = FALSE)

# Importeer verzuim data
data_verzuim_org <- read_excel(
  path = "Data/20220621_MF_NVP_GEM_per_week_en_SBI.xlsx",
  sheet = 2,
  skip = 1,
  col_types = "text")
