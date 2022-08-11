#
# Opschonen data verzuim en personeel
#

#
# Maak nieuwe kolomnamen
#

# Format moet bv. zijn 2018-W05-1, waar de 1 = maandag
new_col_names <- data_verzuim_org %>%
  names() %>%
  # Vervang alle kolomnamen met ... erin door NA
  if_else(
    condition = str_detect(., pattern = "\\.\\.\\."),
    true = NA_character_,
    false = .) %>%
  # Vul NA op met laatst gegeven niet-NA
  # Gebruik enframe() en deframe() om fill() te kunnen toepassen
  enframe() %>%
  fill(
    value) %>%
  deframe() %>%
  unname() %>%
  # Voeg weeknummer toe aan de hand van 1e regel in data_verzuim
  # De kolommen met de totalen hebben NA als weeknummer
  # Het voordeel is nu dat str_c hierdoor automatisch de kolomnaam op NA zet
  str_c(
    data_verzuim_org %>% slice(1) %>% t() %>% drop() %>% unname() %>% str_pad(width = 2, pad = "0"),
    sep = "-W") %>%
  str_c(
    "-1")
# De 1e kolomnaam moet zijn "Bedrijfstak"
new_col_names[1] <- "Bedrijfstak"

#
# Schoon data_verzuim op
#

data_verzuim <- data_verzuim_org %>%
  set_names(
    new_col_names) %>%
  # Verwijder de kolommen met de jaartotalen
  # Te herkennen aan de "lege" naam NA
  select(
    na.omit(new_col_names)) %>%
  # Verwijder de 1e rij met de weeknummer
  slice(-1) %>%
  # Verwijder de rijen met de subtakken
  # De hoofdtakken beginnen met een hoofdletter -> behouden
  # Row Labels bevat de weeknummers -> behouden
  filter(
    Bedrijfstak %>% str_starts(pattern = "[:upper:]|Row Labels")) %>%
  # Ontdubbel Bedrijfstakken A en B. Deze komen voor in de hoofdtak en subtak
  # We moeten alleen de 1e behouden (hoofdtak)
  distinct(
    Bedrijfstak,
    .keep_all = TRUE) %>%
  # Tidy
  pivot_longer(
    cols = -Bedrijfstak,
    names_to = "Week",
    values_to = "Perc_verzuim",
    values_transform = as.numeric)

#
# Schoon data_personeel op
#

# Dit is exact gelijkt aan opschonen data_verzuim
# met het enige verschil dat Perc_verzuim (num) hier n_personeel (int) is
data_personeel <- data_personeel_org %>%
  set_names(
    new_col_names) %>%
  # Verwijder de kolommen met de jaartotalen
  # Te herkennen aan de "lege" naam NA
  select(
    na.omit(new_col_names)) %>%
  # Verwijder de 1e rij met de weeknummer
  slice(-1) %>%
  # Verwijder de rijen met de subtakken
  # De hoofdtakken beginnen met een hoofdletter -> behouden
  # Row Labels bevat de weeknummers -> behouden
  filter(
    Bedrijfstak %>% str_starts(pattern = "[:upper:]|Row Labels")) %>%
  # Ontdubbel Bedrijfstakken A en B. Deze komen voor in de hoofdtak en subtak
  # We moeten alleen de 1e behouden (hoofdtak)
  distinct(
    Bedrijfstak,
    .keep_all = TRUE) %>%
  # Tidy
  pivot_longer(
    cols = -Bedrijfstak,
    names_to = "Week",
    values_to = "n_personeel",
    values_transform = as.integer)

#
# Verdere opschoning data_verzuim
#

# Voeg data_verzuim en data_personeel samen
data_verzuim <- full_join(
  x = data_verzuim,
  y = data_personeel,
  by = c("Bedrijfstak", "Week")) %>%
  mutate(
    # Bedrijfstak als factor, met de volgorde van levels zoals in de originele data
    # Week van ISOweek naar Date klasse
    Bedrijfstak = Bedrijfstak %>% factor() %>% fct_inorder(),
    Week = Week %>% ISOweek2date()) %>%
  # Sommige jaren hebben onterecht een week 53
  # Deze manifesteren zich automatisch als een dubbele Week (als Date) -> eruit
  distinct(
    Bedrijfstak, Week,
    .keep_all = TRUE) %>%
  # Deze bedrijfstakken gaan eruit
  # Deze bevatten te weinig personeel en hebben daarom vaak een NA voor Perc_verzuim
  # T - Huishoudens als werkgever; niet-gedifferentieerde productie van goederen en diensten door huishoudens voor eigen gebruik
  # U - Extraterritoriale organisaties en lichamen
  filter(
    Bedrijfstak %>%
      str_detect(
        pattern = "T -|U -",
        negate = TRUE)) %>%
  droplevels()

# Koppel data_symptomen aan data_verzuim
data_verzuim <- left_join(
  x = data_verzuim,
  y = data_symptomen,
  by = "Week")
