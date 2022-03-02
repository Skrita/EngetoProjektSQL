# EngetoProjektSQL
Projekt pro kurz ENGETO datova akademie


Prubeh projektu - 
Zvolil jsem postupovat poporade vyzadanych oblasti, zapocal jsem tedy casovymi promennymi -  Urcenim vikendu a rocniho obdobi. Oba udaje se zdalo nejednodusi ziskat pomoci jednoducheho CASE a extrakce spravneho udaje z datumu. Na to jsem pouzil funkce WEEKDAY a MONTH. Resil jsem definici rocniho obdobi, zda nebude treba urcovat podle presneho data, ale pro dany ucel se meteoroligicka definice urcena mesici zdala dostatecna a jednodussi na implemntaci. Pri tomto zvazovani jsem si uvedomil, ze mnou puvodne urcovane rocni obdobi je smysluplne platne jen pro severni polokouli nebot na jizni budou rocni obdobi obracene. Shledal jsem, ze bude lepsi upravit podle polokoule pro jednodussi praci s koncovymi daty, kdy nebude uzivatel muset dohledavat na ktere polokouli se dana zeme nachazi a napr. jaro bude konzistentne 1 po celem svete. Toho jsem docilil vnorenym CASE ktery kontroloval polohu statu a pomoci posunu o 2 a modulo opravoval rocni obdobi statu na jizni polokouli.


Chybejici data a problemy -
spousta pocasi - 10 mest by slo jeste rucne doplnit kdy se neshoduji jmena mest (jde myslim o preklady) ve countries a weather
Gini - mnoho statu tyto udaje nemaji nebo v nekterych letech chybi proto jsem vytvoril prumer z dat od roku 2000 
