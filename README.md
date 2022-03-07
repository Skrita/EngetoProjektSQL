# EngetoProjektSQL
Projekt pro kurz ENGETO datova akademie


Prubeh projektu - 
Zvolil jsem postupovat poporade vyzadanych oblasti, zapocal jsem tedy casovymi promennymi -  Urcenim vikendu a rocniho obdobi. Oba udaje se zdalo nejednodusi ziskat pomoci jednoducheho CASE a extrakce spravneho udaje z datumu. Na to jsem pouzil funkce WEEKDAY a MONTH. Resil jsem definici rocniho obdobi, zda nebude treba urcovat podle presneho data, ale pro dany ucel se meteoroligicka definice urcena mesici zdala dostatecna a jednodussi na implemntaci. Pri tomto zvazovani jsem si uvedomil, ze mnou puvodne urcovane rocni obdobi je smysluplne platne jen pro severni polokouli nebot na jizni budou rocni obdobi obracene. Shledal jsem, ze bude lepsi upravit podle polokoule pro jednodussi praci s koncovymi daty, kdy nebude uzivatel muset dohledavat na ktere polokouli se dana zeme nachazi a napr. jaro bude konzistentne 1 po celem svete. Toho jsem docilil vnorenym CASE ktery kontroloval polohu statu a pomoci posunu o 2 a modulo opravoval rocni obdobi statu na jizni polokouli.

Pro druhou demografickou oblast byl postup zpocatku primocare jednoduchy, do chvile nez jsem narazil na limitace JOIN s uzivanim USING jako spojovaciho kriteria. Pote jsem zacal pouzivat ciste spojovani pomoci ON. Data pro Gini koeficient byla neuplna a zadny samostany rok neobsahoval vse reportovane zeme a tak jsem se rozhodl zprumerovat poslednich dvacet let nebot se tento ukazatel zdal byt dosti stabilni a bylo takto obsazeno nejvice zemi s ne prilis zastarlymi udaji. Pro rozdil nadeje na doziti bylo treba vytvorit podtabulku slozenou ze sloupcu dvou pozadovanych roku a jejich rozdilu. Procentualni zastoupeni nabozenstvi se ukazalo jako nejobtiznejsi cast teto sekce, ac ne primo technicky. Po zjisteni spravneho formatu prikazu pro zisk pozadovaneho sloupce o jednom naboznstvi bylo treba jednotlive tyto sloupce pospojovat do jednoho vyber a ten pak postupne poprijovat na hlavni cast, abych se vyhnul sloupci zeme pres kterou byla spojovana. Zpetne me napada, zda nebylo mozne odlozit po pospojovani pomocneho vyberu sloupec country a pripojit vyber cely, coz by bylo znacne elegantnejsi. Data pro nabozenstvi jsem vybral z roku 2020 nebot to byl nejnovesi uplny dataset.

U treti casti, indikatoru pocasi, byl prvotni problem identifikovat zpusob napojeni dat, nebot jsou navazana na mesta a ne zeme jak vetsina ostatnich dat. Bylo to tedy treba naparovat na hlavni mesta. U tohoto se vyskytl problem s nekonzistenci zapisu nazvu mest. Pri zjistovani nesrovnalosti jsem zjistil, ze se jedna o 11 mest. Vzhledem k nemoznosti identifikovat pocasi o datech jakkoliv jinak a kazde mesto bylo treba resit jednotlivym sparovanim, pomoci vicenasobneho CASE jez zmenil nesedici nazvy na tvar jez odpovida tabulce countries, sloupci capital_city. Osetreni dennich dat jsem provedl vyberem dat z dennich hodin 6 az 18. Pro agregacni funkce byl problem s jednotkami. Bylo treba zbavit retezec jednotek. Nejdrive jsem to cinil pomoci funkce LEFT a odstranoval odpovidajici pocet znaku, ale po doporuceni jsem radsi vyuzil REPLACE, ktery je rychlejsi a nehrozi smazani cifer pri nestandartnim formatovani.
