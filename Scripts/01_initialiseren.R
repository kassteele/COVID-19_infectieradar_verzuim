#
# Init
#

# Laad packages
library(tidyverse)
library(lubridate)
library(ISOweek)
library(readxl)
library(parallel)
library(splines)
library(colorspace)

# Opties:
# - Aantal cores voor parallel rekenen
# - Weken starten op maandag
options(
  mc.cores = detectCores(),
  lubridate.week.start = 1)

# Datums in NL naamgeving
Sys.setlocale(category = "LC_TIME", locale = "nl_NL.UTF-8")

# Seizoensperiode in weken
p_seizoen <- 365.25/7

# Functie om coefs uit een modelfit te halen o.b.v. naam patroon
extract_coef <- function(object, pattern) {
  coefs <- object %>% coef()
  names_coefs <- coefs %>% names()
  coefs[names_coefs %>% str_detect(pattern)]
}

# Functie om model matrix uit een modelfit te halen o.b.v. naam patroon
extract_model_matrix <- function(object, pattern) {
  model_matrix <- object %>% model.matrix()
  names_coefs <- model_matrix %>% colnames()
  model_matrix[, names_coefs %>% str_detect(pattern)] %>% matrix(nrow = nrow(model_matrix))
}
