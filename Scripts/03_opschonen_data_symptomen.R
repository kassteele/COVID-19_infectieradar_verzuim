#
# Opschonen data symptomen
#

data_symptomen <- data_symptomen_org %>%
  mutate(
    # Week waarvoor Infectieradar data geldig is
    Week = Date_of_statistics %>%
      floor_date(unit = "week"),
    # Een aantal datum hebben NA, bijvoorbeeld door een technische storing
    # We imputeren Perc_covid_symptoms voor deze datums
    # We noemen de nieuwe variabele Perc_symptomen voor verder gebruik in de analyse
    Perc_symptomen = approx(
      x = Date_of_statistics,
      y = Perc_covid_symptoms,
      xout = Date_of_statistics)$y) %>%
  # Bereken gemiddelde percentage symptomen per week
  group_by(
    Week) %>%
  summarise(
    n_dagen = n(),
    Perc_symptomen = Perc_symptomen %>% mean()) %>%
  # Maar alleen voor volledige weken
  filter(
    n_dagen == 7) %>%
  select(
    -n_dagen)
