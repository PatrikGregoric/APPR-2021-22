# 3. faza: Vizualizacija podatkov

library(tidyverse)
library(ggplot2)
library(dplyr)

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
