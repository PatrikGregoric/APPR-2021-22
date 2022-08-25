# Analiza podatkov s programom R - 2021/22

## Analiza potrosnje v Sloveniji

Pri projektni nalogi bom analiziral potrosnjo prebivalstva v Sloveniji. Opazoval bom potrosnjo po gospodinjstvih pri spremembi BDP skozi leta 2012-2020. Bolj podrobno se bom posvetil potrosnji energijskih virov.

### Tabele:

- Tabela 1: BDP po regijah

- Tabela 2: Cene energentov
    
- Tabela 3: Dostop do interneta po gospodinjstvih
    
- Tabela 4: Potrosnja

- Tabela 5: Prebivalstvo


### Viri:

- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/05A1002S.px/table/tableViewLayout2/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/2974001S.px/table/tableViewLayout2/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/H028S.px/table/tableViewLayout2/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/0878701S.px/table/tableViewLayout2/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/H219S.px/table/tableViewLayout2/
- https://pxweb.stat.si/SiStatData/pxweb/sl/Data/-/0867385S.px/table/tableViewLayout2/

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`.
Ko ga prevedemo, se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`.
Potrebne knjižnice so v datoteki `lib/libraries.r`
Podatkovni viri so v mapi `podatki/`.
Zemljevidi v obliki SHP, ki jih program pobere,
se shranijo v mapo `../zemljevidi/` (torej izven mape projekta).
