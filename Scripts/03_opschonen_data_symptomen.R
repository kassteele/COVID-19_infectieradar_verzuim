#
# Opschonen data symptomen
#

data_symptomen <- data_symptomen_org %>%
  mutate(
    Week = timestamp.weekly %>%
      floor_date(unit = "week")) %>%
  group_by(
    Week) %>%
  summarise(
    n_symptomen = total_cases %>% sum(na.rm = TRUE),
    n_personen = total_rep %>% sum(na.rm = TRUE)) %>%
  mutate(
    Perc_symptomen = n_symptomen/n_personen)
