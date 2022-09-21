#
# Importeer data
#

# Importeer Infectieradar COVID-19 gerelateeerde symptomen
# Dit bestand wordt een keer in de week geüpdatet op dinsdag. Er komen dan 7 nieuwe dagen bij (dinsdag tot en met maandag)
# Perc_covid_symptoms:
#   Percentage deelnemers in Infectieradar dat in de week voorafgaande aan Date_of_statistics COVID-19-achtige klachten heeft gerapporteerd
#   COVID-19-achtige klachten zijn koorts, hoesten, kortademigheid, verlies van reuk of verlies van smaak
# Date_of_statistics:
#   Datum waarop de vragenlijst is ingestuurd
# Bron: https://data.rivm.nl/covid-19/
data_symptomen_org <- read_delim(
  file = "https://data.rivm.nl/covid-19/COVID-19_Infectieradar_symptomen_per_dag.csv",
  delim = ";",
  show_col_types = FALSE)

# Bepaal meest recente verzuim data file
file_verzuim <- list.files(
  path = "Data",
  full.names = TRUE) %>%
  max()

# Importeer verzuim data
# Dit is het wekelijkse netto verzuimpercentage (gecorrigeerd voor deelherstel, niet voor FTE)
# Bron: https://www.humantotalcare.nl/ (via Hester KA)
data_verzuim_org <- read_excel(
  path = file_verzuim,
  sheet = 2,
  skip = 1,
  col_types = "text")

# Importeer personeel data
# Dit is het wekelijkse gemiddelde aantal werknemers over de gerapporteerde periode
# Bron: https://www.humantotalcare.nl/ (via Hester KA)
data_personeel_org <- read_excel(
  path = file_verzuim,
  sheet = 4,
  skip = 1,
  col_types = "text")
