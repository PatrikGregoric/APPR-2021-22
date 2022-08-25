# 4. faza: Napredna analiza podatkov

#1. regresijska premica: Dostop do interneta po gospodinjstvih v naslednjih letih

podatek = group_by(Dostop_do_interneta, LETO)
dostop = summarise(podatek, odstotek=(sum(delez, na.rm = TRUE)))
dostop$odstotek = round(dostop$odstotek, digits = 2)
regresija = lm(data = dostop, odstotek ~ LETO)
naslednja_leta = data.frame(LETO=seq(2021, 2025, 1)) #v letu 2025 ze napove nad 100%
napoved = mutate(naslednja_leta, odstotek=predict(regresija, naslednja_leta))
napoved$odstotek = round(napoved$odstotek, digits = 2)


graf_regresijska_premica_dostop = ggplot(dostop, aes(x=LETO, y=odstotek)) +
  geom_smooth(method=lm, fullrange = TRUE, color = "green") + 
  geom_point(data=napoved, aes(x=LETO, y=odstotek), color = "red") +
  geom_point() +
  labs(title = "Regresija dostopa do interneta po gospodinjstvih", y="Odstotek")




#2. regresijska premica: BDP Slovenije v naslednjih letih

podatek1 = filter(BDP_regije, statisticna_regija == "SLOVENIJA")
podatek1 = group_by(podatek1, leto)
BDP1 = summarise(podatek1, dohodek=(sum(BDP, na.rm = TRUE)))
BDP1 = transform(BDP1, leto = as.numeric(leto))
regresija1 = lm(data = BDP1, dohodek ~ leto)
naslednja_leta1 = data.frame(leto=seq(2020, 2025, 1))
napoved1 = mutate(naslednja_leta1, dohodek=predict(regresija1, naslednja_leta1))

graf_regresijska_premica_BDP = ggplot(BDP1, aes(x=leto, y=dohodek)) +
  geom_smooth(method=lm, fullrange=TRUE, color="green") +
  geom_point(data=napoved1, aes(x=leto, y=dohodek), color="red") +
  geom_point() +
  labs(title = "Regresija BDP na prebivalca Slovenije", y="BDP na prebivalca")



#3. regresijska premica: Poraba gospodinjstev

podatek2 = filter(Poraba_gospodinjstev, vrsta == "Električna energija" | vrsta == "Plin" |
                    vrsta == "Zemeljski plin in mestni plin" | vrsta == "Tekoča goriva" | vrsta == "Trdna goriva" |
                    vrsta == "Toplotna energija" | vrsta == "Dizelsko gorivo" | vrsta == "Bencin" | vrsta == "KOMUNIKACIJE")
podatek2 = group_by(podatek2, leto)
potrosnja = summarise(podatek2, skupno=(sum(cena, na.rm = TRUE))) #sestevek potrosnje le zadev, ki me zanimajo
potrosnja = transform(potrosnja, leto = as.numeric(leto))
regresija2 = lm(data = potrosnja, skupno ~ leto)
naslednja_leta2 = data.frame(leto=seq(2019, 2025, 1))
napoved2 = mutate(naslednja_leta2, skupno=predict(regresija2, naslednja_leta2))

graf_regresijska_premica_potrosnja = ggplot(potrosnja, aes(x=leto, y=skupno)) +
  geom_smooth(method=lm, fullrange=TRUE, color="green") +
  geom_point(data=napoved2, aes(x=leto, y=skupno), color="red") +
  geom_point() +
  labs(title = "Regresija potrosnje energetskih virov po gospodinjstvih")



#cluster: Regije BDP
podatek3 = filter(BDP_regije, statisticna_regija != "SLOVENIJA")
podatek3 = transform(podatek3, leto=as.numeric(leto))
podatek3 = group_by(podatek3, statisticna_regija)
skupaj = summarise(podatek3, vsota=(sum(BDP, na.rm = TRUE)))

prvi = dcast(podatek3, statisticna_regija~leto, value.var = "BDP")
prvi = left_join(prvi, skupaj, by = "statisticna_regija")
prvi = prvi[order(prvi$vsota, decreasing = FALSE),]
koncno = prvi[,-1]

n = 4
fit = hclust(dist(scale(koncno)))
skupine = cutree(fit, n)

cluster = mutate(prvi, skupine)
cluster = cluster[,-2:-9]
colnames(cluster) = c("statisticna_regija", "Vsota_BDP", "skupine")

regije = unique(zemljevid$NAME_1)
regije = as.data.frame(regije, stringsAsFactors=FALSE) 
names(regije) = "statisticna_regija"
vse = left_join(regije, cluster, by="statisticna_regija")


cluster_zemljevid_BDP = ggplot() + geom_polygon(data=left_join(zemljevid, vse, by=c("NAME_1"="statisticna_regija")),
                                                aes(x=long, y=lat, group=group, fill=factor(skupine))) +
  geom_line() +
  theme(axis.text.x=element_blank(), axis.ticks.x=element_blank(), axis.text.y=element_blank(),
        axis.ticks.y=element_blank()) +
  guides(fill=guide_colorbar(title="skupine")) +
  ggtitle('Regije po skupinah glede na BDP') +
  labs(x = " ") +
  labs(y = " ") +
  scale_fill_brewer(palette="YlOrRd", na.value = "#e0e0d1")


