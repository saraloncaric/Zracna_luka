# Zračna Luka - Web Aplikacija

Ovo je web aplikacija za upravljanje podacima u zračnoj luci, izrađena koristeći Flask framework i MySQL bazu podataka. Aplikacija omogućuje rad s podacima o avionskim kompanijama, avionima, letovima, 
zaposlenicima i parkiralištu, kao i pregled statistike i rezervaciju letova.

## Značajke
- *Avionske kompanije*: Pregled, dodavanje, ažuriranje i brisanje podataka o kompanijama.
- *Avioni*: Upravljanje podacima o avionima i povezivanje s kompanijama.
- *Letovi*: Praćenje letova, dodavanje novih i ažuriranje postojećih.
- *Zaposlenici*: Evidencija zaposlenika, uključujući plaće, smjene i pozicije.
- *Rezervacije*: Omogućava korisnicima rezervaciju letova.
- *Statistika*: Analiza broja putnika u određenom vremenskom razdoblju.
- *Parkiralište*: Pregled stanja na parkiralištu.

## Tehnologije
- *Backend*: Flask (Python)
- *Baza podataka*: MySQL
- *Frontend*: HTML, CSS (uz podršku Jinja2 templatinga)

## Instalacija
1. Klonirajte repozitorij:
   bash
   git clone https://github.com/saraloncaric/Zracna_luka
   
2. Instalirajte potrebne pakete:
   bash
   pip install -r requirements.txt
   
3. Pokrenite MySQL bazu podataka koristeći priloženu zracnaluka.sql skriptu za inicijalizaciju tablica.
4. Konfigurirajte app.py:
   - Ažurirajte postavke baze podataka (MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DB) prema vašoj lokalnoj konfiguraciji.
5. Pokrenite aplikaciju
