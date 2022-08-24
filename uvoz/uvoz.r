# 2. faza: Uvoz podatkov
library(tidyverse)
library(readr)
library(tidyr)
library(dplyr)
library(data.table)

sl <- locale("sl", decimal_mark=",", grouping_mark=".")


BDP_regije = read.csv2(
  "podatki/Bdp po regijah.csv",
  skip = 2,
  fileEncoding = "UTF-8",
  sep = ";")

BDP_regije.1 = pivot_longer(BDP_regije,
                            cols = colnames(BDP_regije)[-1],
                            names_to = "leto",
                            values_to = "BDP")

BDP_regije.1 = BDP_regije.1 %>%
  group_by(leto) %>%
  mutate(leto = str_replace_all(leto, "X{1}", "")) %>%
  rename(statisticna_regija = STATISTIČNA.REGIJA)

Cene_energentov = read.csv2(
  "podatki/Cene energentov.csv",
  skip = 2,
  fileEncoding = "UTF-8",
  sep = ";")

Cene_energentov = pivot_longer(Cene_energentov,
                               cols = colnames(Cene_energentov)[-1],
                               names_to = "leto",
                               values_to = "cena")

Cene_energentov = Cene_energentov %>%
  mutate(leto = str_sub(leto, 2, 5))

Cene_energentov = Cene_energentov %>%
  group_by(leto) %>%
  summarise(list(mean = mean(cena, na.rm = TRUE)))

Poraba_gospodinjstev = read.csv(
  "podatki/Poraba gospodinjstev.csv",
  skip = 2,
  fileEncoding = "Windows-1250",
  sep = ";")

Poraba_gospodinjstev = pivot_longer(Poraba_gospodinjstev,
                                    cols = colnames(Poraba_gospodinjstev)[-1],
                                    names_to = "leto",
                                    values_to = "cena")

Poraba_gospodinjstev = Poraba_gospodinjstev %>%
  rename(vrsta = ECOICOP) %>%
  mutate(leto = str_replace_all(leto, "[^0-9]*", ""),
         vrsta = str_replace_all(vrsta, "^[\\d{1,5} ]*", ""))

Dostop_do_interneta = read.csv(
  "podatki/Dostop do interneta v gospodinjstvih.csv",
  skip = 2,
  fileEncoding = "Windows-1250",
  sep = ";")

Dostop_do_interneta = Dostop_do_interneta %>%
  rename(Dostop_do_interneta = DOSTOP.GOSPODINJSTEV.DO.INTERNETA,
         Stevilo_gospodinjstev = Število.gospodinjstev...SKUPAJ)

Dostop_do_interneta_poskus = pivot_wider(Dostop_do_interneta,
                                         names_from = Dostop_do_interneta,
                                         values_from = Stevilo_gospodinjstev)

Prebivalstvo = read.csv(
  "podatki/Prebivalstvo Slovenije.csv",
  skip = 2,
  fileEncoding = "Windows-1250",
  sep = ";")

Prebivalstvo = Prebivalstvo[,-2] #ker ne potrebujem spola

Prebivalstvo = pivot_longer(Prebivalstvo,
                            cols = colnames(Prebivalstvo)[-1],
                            names_to = "leto",
                            values_to = "stevilo")

Prebivalstvo = Prebivalstvo[,-1] %>% # prvi stolpec nam ne poda nobene informacije
  mutate(leto = str_replace_all(leto, "X{1}", ""))
