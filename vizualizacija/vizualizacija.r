# 3. faza: Vizualizacija podatkov

library(tidyverse)
library(ggplot2)
library(dplyr)
library(sp)
library(rgdal)
library(ggmap)
library(tmap)
library(maptools)

#1.graf: Cene energentov

graf_cene_energentov = ggplot(data = Cene_energentov, mapping = aes(x=leto, y=cena, group=ENERGENT, color=ENERGENT)) + 
  geom_line(stat = "identity", position = "identity") +
  theme(axis.text.x = element_text(angle = 90,size = 8)) +
  labs(y = "Cena", color = "Energenti") +
  theme(legend.text = element_text(size=8)) + 
  ggtitle("Cene energentov")

plot(graf_cene_energentov)
#2.graf: BDP regije

graf_BDP = ggplot(data = filter(BDP_regije, statisticna_regija == 'Pomurska' | statisticna_regija == 'Podravska' |
                                  statisticna_regija == 'Koroška' | statisticna_regija == 'Savinjska' | statisticna_regija == 'Zasavska' |
                                  statisticna_regija == 'Posavska' | statisticna_regija == 'Jugovzhodna' | statisticna_regija == 'Osrednjeslovenska' |
                                  statisticna_regija == 'Gorenjska' | statisticna_regija == 'Primorsko-notranjska' |
                                  statisticna_regija == 'Goriška' | statisticna_regija == 'Obalno-kraška'),
                  mapping = aes(x=leto, y=BDP, color=statisticna_regija)) +
                  ggtitle("BDP po regijah") + 
                  geom_point() +
                  facet_wrap(statisticna_regija~., ncol=3) +
                  theme(axis.text.x = element_text(angle = 90, size=6))
plot(graf_BDP)
#3.graf: Dostop gospodinjstev do interneta
graf_dostop_do_interneta = ggplot(data = Dostop_do_interneta, mapping = aes(x=LETO, y=delez)) + 
  geom_line(stat = "identity", position = "identity") +
  theme(axis.text.x = element_text(angle = 90,size = 8)) +
  labs(y = "Odstotki") +
  ggtitle("Dostop gospodinjstev do interneta")

plot(graf_dostop_do_interneta)  

#4.graf: Poraba gospodinjstev

graf_poraba_gospodinjstev = ggplot(data = filter(Poraba_gospodinjstev, vrsta == "Električna energija" | vrsta == "Plin" |
                                                   vrsta == "Zemeljski plin in mestni plin" | vrsta == "Tekoča goriva" | vrsta == "Trdna goriva" |
                                                   vrsta == "Toplotna energija" | vrsta == "Dizelsko gorivo" | vrsta == "Bencin" | vrsta == "KOMUNIKACIJE"),
                                  mapping = aes(x=leto, y=cena, color=vrsta)) + 
                                  ggtitle("Poraba gospodinjstev") +
                                  geom_point() +
                                  facet_wrap(vrsta~., ncol=3) +
                                  theme(axis.text.x = element_text(angle = 90, size=6))
plot(graf_poraba_gospodinjstev)

#Preberemo zemljevid Slovenije

zemljevid = uvozi.zemljevid("http://biogeo.ucdavis.edu/data/gadm2.8/shp/SVN_adm_shp.zip",
                            "SVN_adm1", mapa = 'zemljevid', encoding = "UTF-8")

zemljevid$NAME_1 <- c("Gorenjska", "Goriška","Jugovzhodna Slovenija", "Koroška", "Primorsko-notranjska", "Obalno-kraška", "Osrednjeslovenska", "Podravska", "Pomurska", "Savinjska", "Posavska", "Zasavska")

zemljevid <- fortify(zemljevid)
