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

BDP_regije = pivot_longer(BDP_regije,
                            cols = colnames(BDP_regije)[-1],
                            names_to = "leto",
                            values_to = "BDP")

BDP_regije = BDP_regije %>%
  group_by(leto) %>%
  mutate(leto = str_replace_all(leto, "X{1}", "")) %>%
  rename(statisticna_regija = STATISTIČNA.REGIJA)

BDP_regije.1 = BDP_regije %>%
  filter(leto == "2019", statisticna_regija != "SLOVENIJA")

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
  mutate(leto = str_sub(leto, 2, 5)) %>%
  transform(Cene_energentov, cena = as.numeric(cena))

Cene_energentov = Cene_energentov %>%
  group_by(leto, ENERGENT) %>%
  summarise(cena = mean(cena, na.rm = TRUE)) %>%
  group_by(leto, ENERGENT) %>%
  summarise(cena = round(cena, digits = 2))

Cene_energentov$cena[Cene_energentov$ENERGENT == "Kurilno olje (EUR/1000 l)"] = Cene_energentov$cena[Cene_energentov$ENERGENT == "Kurilno olje (EUR/1000 l)"]/1000

Cene_energentov = Cene_energentov %>%
  mutate(ENERGENT = str_replace_all(ENERGENT, "[10]",""))

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
  rename(Dostop= DOSTOP.GOSPODINJSTEV.DO.INTERNETA,
         Stevilo_gospodinjstev = Število.gospodinjstev...SKUPAJ) %>%
  mutate(Dostop = str_replace_all(Dostop, "[\\s–-]", ""))

Dostop_do_interneta = pivot_wider(Dostop_do_interneta,
                                         names_from = Dostop,
                                         values_from = Stevilo_gospodinjstev)

Dostop_do_interneta = Dostop_do_interneta %>%
  rename(Vsa.gospodinjstva = GospodinjstvaSKUPAJ,
         Gospodinjstva.z.internetom = Dostopdointerneta)

Dostop_do_interneta = Dostop_do_interneta %>%
  mutate(delez = Gospodinjstva.z.internetom/Vsa.gospodinjstva)

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
  mutate(leto = str_replace_all(leto, "[^\\d{4}]", "")) %>%
  mutate(leto = str_sub(leto, 1, 4))

Prebivalstvo = Prebivalstvo %>%
  group_by(leto) %>%
  summarise(stevilo = mean(stevilo, na.rm = FALSE))


