#
# Importeer data
#

# Importeer Infectieradar symptomen
# Bron: R:\Projecten\COVID-19\Surveillance\Output\Infectieradar\Onderliggende_data\Percentage_klachten
data_symptomen_org <- read_csv(
  file = "Data/Percentage_klachten_over_tijd_20220719_0906.csv",
  show_col_types = FALSE)

# Importeer verzuim data
data_verzuim_org <- read_excel(
  path = "Data/20220721_MF_NVP_GEM_per_week_en_SBI.xlsx",
  sheet = 2,
  skip = 1,
  col_types = "text")
