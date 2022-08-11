#
# Data voor plot
#

data_verzuim_tijdreeks_fit <-
  # Voeg n_personeel aan levels van Bedrijfstak
  # Dit is het gemiddelde aantal werknemers over de periode van de fit
  left_join(
    x = data_verzuim_tijdreeks_fit,
    y = data_verzuim_tijdreeks_fit %>%
      group_by(
        Bedrijfstak) %>%
      summarise(
        n_personeel_gem = n_personeel %>% mean() %>% "/"(100) %>% round() %>% "*"(100)),
    by = "Bedrijfstak") %>%
  mutate(
    Bedrijfstak = str_glue("{str_wrap(Bedrijfstak, width = 50)}\n({n_personeel_gem})") %>%
      fct_inorder())

data_verzuim_tijdreeks_plot <- data_verzuim_tijdreeks_fit %>%
  # Omdat de componenten in wide format staan,
  # moeten we die eerst in long format zetten
  pivot_longer(
    cols = starts_with("comp"),
    names_to = "Component",
    values_to = "Percentage verzuim") %>%
  # Hernoem de componenten naar iets leesbaars, e.g.
  # comp_harm -> Seizoenseffect
  # comp_cov -> Infectieradar
  mutate(
    Component = Component %>%
      factor(
        levels = c(
          "comp_ar",
          "comp_cov",
          "comp_harm",
          "comp_trend"),
        labels = c(
          "Autoregressief\neffect",
          "Percentage COVID-19\ngerelateerde klachten\nInfectieradar",
          "Seizoenseffect",
          "Grootschalige\ntrend")))
