#
# Opschonen data symptomen
#

data_symptomen <- data_symptomen_org %>%
  mutate(
    Week = Date_of_statistics %>%
      floor_date(unit = "week")) %>%
  group_by(
    Week) %>%
  summarise(
    Perc_symptomen = mean(Perc_covid_symptoms, na.rm = TRUE))
