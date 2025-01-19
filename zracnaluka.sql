DROP DATABASE IF EXISTS zracnaluka;
CREATE DATABASE zracnaluka;
USE zracnaluka;

CREATE TABLE zracna_luka (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL UNIQUE DEFAULT 'Zračna luka Pula',
    grad VARCHAR(50) NOT NULL DEFAULT 'Pula',
    drzava VARCHAR(50) NOT NULL DEFAULT 'Republika Hrvatska'
);
CREATE INDEX idx_zracna_luka_naziv ON zracna_luka(naziv);

CREATE TABLE avionske_kompanije (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    drzava VARCHAR(50) NOT NULL,
    id_zracna_luka INT NOT NULL
);
CREATE INDEX idx_avionske_kompanije_naziv ON avionske_kompanije(naziv);

CREATE TABLE avioni (
    id INT PRIMARY KEY AUTO_INCREMENT, 
    model VARCHAR(100) NOT NULL, 
    kapacitet INT NOT NULL,
    godina_proizvodnje YEAR NOT NULL,
    id_kompanije INT NOT NULL,
    FOREIGN KEY (id_kompanije) REFERENCES avionske_kompanije(id) ON DELETE CASCADE
);
CREATE INDEX idx_avioni_model ON avioni(model);

CREATE TABLE piste (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    duljina_metara INT NOT NULL,
    trenutni_status VARCHAR(50) NOT NULL,
    id_zracna_luka INT NOT NULL
);

CREATE TABLE terminali (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    id_zracna_luka INT NOT NULL
);

CREATE TABLE gateovi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(100) NOT NULL,
    trenutni_status VARCHAR(50) NOT NULL,
    id_terminal INT NOT NULL,
    FOREIGN KEY (id_terminal) REFERENCES terminali(id) ON DELETE CASCADE
);

CREATE TABLE letovi (
    id INT PRIMARY KEY AUTO_INCREMENT,
    broj_leta INT NOT NULL,
    vrijeme_polaska DATETIME NOT NULL,
    vrijeme_dolaska DATETIME NOT NULL,
    trenutni_status VARCHAR(50) NOT NULL,
    id_avion INT NOT NULL,
    id_gate INT NOT NULL,
    id_pista INT NOT NULL,
    FOREIGN KEY (id_avion) REFERENCES avioni(id) ON DELETE CASCADE,
    FOREIGN KEY (id_gate) REFERENCES gateovi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_pista) REFERENCES piste(id) ON DELETE CASCADE
);

CREATE TABLE uzlijetanja (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vrijeme_uzlijetanja TIMESTAMP NOT NULL,
    id_let INT NOT NULL,
    id_pista INT NOT NULL,
    trenutni_status VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_let) REFERENCES letovi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_pista) REFERENCES piste(id) ON DELETE CASCADE
);
CREATE INDEX idx_uzlijetanja_vrijeme_uzlijetanja ON uzlijetanja(vrijeme_uzlijetanja);
CREATE INDEX idx_uzlijetanja_id_let ON uzlijetanja(id_let);

CREATE TABLE slijetanja (
    id INT PRIMARY KEY AUTO_INCREMENT,
    vrijeme_slijetanja TIMESTAMP NOT NULL,
    id_let INT NOT NULL,
    id_pista INT NOT NULL,
    trenutni_status VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_let) REFERENCES letovi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_pista) REFERENCES piste(id) ON DELETE CASCADE
);
CREATE INDEX idx_slijetanja_vrijeme_slijetanja ON slijetanja(vrijeme_slijetanja);
CREATE INDEX idx_slijetanja_id_let ON slijetanja(id_let);

CREATE TABLE klase_sjedala (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50) NOT NULL,
    opis VARCHAR(1000),
    cijena DECIMAL(10,2) NOT NULL,
    max_kapacitet INT NOT NULL
);

CREATE TABLE sjedala (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_avion INT NOT NULL,
    id_klasa INT NOT NULL,
    broj_sjedala INT NOT NULL,
    FOREIGN KEY (id_avion) REFERENCES avioni(id) ON DELETE CASCADE,
    FOREIGN KEY (id_klasa) REFERENCES klase_sjedala(id) ON DELETE CASCADE
);

CREATE TABLE putnici (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(100) NOT NULL,
    prezime VARCHAR(100) NOT NULL,
    broj_putovnice VARCHAR(50) NOT NULL,
    drzavljanstvo VARCHAR(100) NOT NULL,
    datum_rodenja DATE NOT NULL
);

CREATE TABLE karte (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_sjedalo INT NOT NULL,
    id_let INT NOT NULL,
    id_putnik INT NOT NULL,
    FOREIGN KEY (id_sjedalo) REFERENCES sjedala(id) ON DELETE CASCADE,
    FOREIGN KEY (id_let) REFERENCES letovi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_putnik) REFERENCES putnici(id) ON DELETE CASCADE
);

CREATE TABLE prtljaga (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tezina_kg DECIMAL(10, 2) NOT NULL,
    tip_prtljage VARCHAR(50) NOT NULL,
    id_karta INT NOT NULL,
    FOREIGN KEY (id_karta) REFERENCES karte(id) ON DELETE CASCADE
);

CREATE TABLE zaposlenici (
    id INT PRIMARY KEY AUTO_INCREMENT,
    ime VARCHAR(100) NOT NULL,
    prezime VARCHAR(100) NOT NULL,
    placa DECIMAL(10, 2) NOT NULL,
    pozicija VARCHAR(100) NOT NULL,
    smjena VARCHAR(100) NOT NULL,
    id_zracna_luka INT NOT NULL
);

CREATE TABLE osoblje_leta (
    id INT PRIMARY KEY AUTO_INCREMENT,
    id_let INT NOT NULL,
    id_zaposlenik INT NOT NULL,
    uloga VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_let) REFERENCES letovi(id) ON DELETE CASCADE,
    FOREIGN KEY (id_zaposlenik) REFERENCES zaposlenici(id) ON DELETE CASCADE
);

CREATE TABLE prijem_prtljage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    trenutni_status VARCHAR(255) NOT NULL,
    id_terminal INT NOT NULL,
    FOREIGN KEY (id_terminal) REFERENCES terminali(id) ON DELETE CASCADE
);

CREATE TABLE reklamacija_prtljage (
    id INT PRIMARY KEY AUTO_INCREMENT,
    trenutni_status VARCHAR(255) NOT NULL,
    id_prtljaga INT NOT NULL,
    FOREIGN KEY (id_prtljaga) REFERENCES prtljaga(id) ON DELETE CASCADE
);

CREATE TABLE izgubljena_prtljaga (
    id INT PRIMARY KEY AUTO_INCREMENT,
    opis TEXT NOT NULL,
    trenutni_status VARCHAR(255) NOT NULL,
    id_prtljaga INT NOT NULL,
    FOREIGN KEY (id_prtljaga) REFERENCES prtljaga(id) ON DELETE CASCADE
);

CREATE TABLE ukrcajne_karte (
    id_ukrcajne_karte INT PRIMARY KEY AUTO_INCREMENT,
    vrijeme_ukrcaja TIMESTAMP NOT NULL,
    id_karta INT NOT NULL,
    id_gate INT NOT NULL,
    FOREIGN KEY (id_karta) REFERENCES karte(id) ON DELETE CASCADE,
    FOREIGN KEY (id_gate) REFERENCES gateovi(id) ON DELETE CASCADE
);

CREATE TABLE evidencija_odrzavanja_aviona (
    id INT PRIMARY KEY AUTO_INCREMENT,
    opis TEXT,
    datum_odrzavanja DATE,
    id_avion INT,
    FOREIGN KEY (id_avion) REFERENCES avioni(id) ON DELETE CASCADE
);

CREATE TABLE evidencija_goriva (
    id INT PRIMARY KEY AUTO_INCREMENT,
    kolicina_litara DECIMAL(10,2),
    datum_tocenja DATE,
    id_avion INT,
    FOREIGN KEY (id_avion) REFERENCES avioni(id) ON DELETE CASCADE
);

CREATE TABLE kasnjenja_letova (
    id INT PRIMARY KEY AUTO_INCREMENT,
    razlog TEXT,
    trajanje_minuta INT,
    id_let INT,
    FOREIGN KEY (id_let) REFERENCES letovi(id) ON DELETE CASCADE
);

CREATE TABLE posebne_ponude (
    id INT PRIMARY KEY AUTO_INCREMENT,
    opis TEXT,
    vrijedi_do DATE,
    id_karta INT,
    FOREIGN KEY (id_karta) REFERENCES karte(id) ON DELETE CASCADE
);

CREATE TABLE bussines_lounge (
    id INT PRIMARY KEY AUTO_INCREMENT,
    naziv VARCHAR(50),
    id_terminal INT,
    FOREIGN KEY (id_terminal) REFERENCES terminali(id) ON DELETE CASCADE
);

CREATE TABLE pristup_business_loungeu (
    id INT PRIMARY KEY AUTO_INCREMENT,
    datum_pristupa DATE NOT NULL,
    id_putnik INT NOT NULL,
    id_business_lounge INT NOT NULL,
    FOREIGN KEY (id_putnik) REFERENCES putnici(id) ON DELETE CASCADE,
    FOREIGN KEY (id_business_lounge) REFERENCES bussines_lounge(id) ON DELETE CASCADE
);

CREATE TABLE parkiranje (
    id INT PRIMARY KEY AUTO_INCREMENT,
    broj_vozila INT NOT NULL,
    vrijeme_pocetka TIME NOT NULL,
    vrijeme_kraja TIME NOT NULL,
    id_zracna_luka INT NOT NULL
);

CREATE TABLE servisna_vozila (
    id INT PRIMARY KEY AUTO_INCREMENT,
    broj_vozila INT NOT NULL,
    tip VARCHAR(50) NOT NULL,
    trenutni_status VARCHAR(50) NOT NULL,
    id_zracna_luka INT NOT NULL
);

CREATE TABLE vremenski_uvjeti (
    id INT PRIMARY KEY AUTO_INCREMENT,
    uvjeti VARCHAR(50) NOT NULL,
    temperatura DECIMAL(5,2) NOT NULL,
    vlaga DECIMAL(5,2) NOT NULL,
    id_pista INT NOT NULL,
    FOREIGN KEY (id_pista) REFERENCES piste(id) ON DELETE CASCADE
);

-- unos podataka u tablicu zracna_luka --


-- unos podataka u tablicu avionske_kompanije --
 
 INSERT INTO avionske_kompanije (naziv, drzava, id_zracna_luka)
VALUES
('Croatia Airlines', 'Republika Hrvatska', 1),
('Lufthansa', 'Njemačka', 1),
('Air France', 'Francuska', 1),
('British Airways', 'Ujedinjeno Kraljevstvo', 1),
('KLM Royal Dutch Airlines', 'Nizozemska', 1),
('Ryanair', 'Irska', 1),
('EasyJet', 'Ujedinjeno Kraljevstvo', 1),
('Turkish Airlines', 'Turska', 1),
('Swiss International Air Lines', 'Švicarska', 1),
('Austrian Airlines', 'Austrija', 1),
('Alitalia', 'Italija', 1),
('Iberia', 'Španjolska', 1),
('Norwegian Air Shuttle', 'Norveška', 1),
('SAS Scandinavian Airlines', 'Švedska', 1),
('Aeroflot', 'Rusija', 1),
('LOT Polish Airlines', 'Poljska', 1),
('Finnair', 'Finska', 1),
('TAP Air Portugal', 'Portugal', 1),
('Wizz Air', 'Mađarska', 1),
('Emirates', 'Ujedinjeni Arapski Emirati', 1),
('Qatar Airways', 'Katar', 1),
('Etihad Airways', 'Ujedinjeni Arapski Emirati', 1),
('Singapore Airlines', 'Singapur', 1),
('Thai Airways', 'Tajland', 1),
('Cathay Pacific', 'Hong Kong', 1),
('China Southern Airlines', 'Kina', 1),
('Japan Airlines', 'Japan', 1),
('Korean Air', 'Južna Koreja', 1),
('United Airlines', 'Sjedinjene Američke Države', 1),
('Delta Air Lines', 'Sjedinjene Američke Države', 1),
('American Airlines', 'Sjedinjene Američke Države', 1),
('Air Canada', 'Kanada', 1),
('Qantas', 'Australija', 1),
('Virgin Atlantic', 'Ujedinjeno Kraljevstvo', 1),
('Southwest Airlines', 'Sjedinjene Američke Države', 1);

-- unos podataka u tablicu avioni --

INSERT INTO avioni (model, kapacitet, godina_proizvodnje, id_kompanije)
VALUES
('Airbus A320', 180, 2015, 1),
('Boeing 737', 160, 2018, 1),
('Embraer E190', 100, 2020, 1),
('Bombardier CRJ900', 90, 2017, 4),
('Airbus A321', 220, 2016, 4),
('Boeing 787', 300, 2019, 6),
('Airbus A330', 277, 2014, 6),
('ATR 72', 70, 2018, 6),
('Boeing 777', 396, 2015, 6),
('Airbus A350', 315, 2021, 10),
('McDonnell Douglas MD-80', 150, 1999, 10),
('Boeing 747', 416, 2010, 10),
('Airbus A319', 156, 2013, 10),
('Boeing 757', 239, 2012, 10),
('Embraer E175', 88, 2020, 10),
('Bombardier Dash 8-Q400', 76, 2018, 1),
('Airbus A380', 853, 2016, 17),
('Boeing 767', 269, 2014, 18),
('Airbus A220', 141, 2019, 19),
('Boeing 727', 189, 2000, 20),
('Cessna Citation X', 12, 2015, 21),
('Gulfstream G650', 18, 2021, 22),
('Airbus A310', 280, 1998, 23),
('Boeing 737 MAX', 200, 2022, 24),
('Embraer E195-E2', 146, 2023, 25),
('Bombardier Learjet 75', 9, 2020, 26),
('Boeing 787-9', 296, 2021, 27),
('Airbus A340', 375, 2011, 28),
('Boeing 777X', 426, 2023, 29),
('Concorde', 92, 1995, 30),
('Tupolev Tu-204', 210, 2005, 31),
('Sukhoi Superjet 100', 108, 2019, 32),
('Comac C919', 168, 2021, 33),
('McDonnell Douglas DC-10', 270, 2000, 34),
('Antonov An-225', 640, 1988, 35);

-- unos podataka u tablicu piste --

INSERT INTO piste (naziv, duljina_metara, trenutni_status, id_zracna_luka)
VALUES
('Pista 01', 3000, 'Aktivna', 1),
('Pista 02', 2500, 'Aktivna', 1),
('Pista 03', 3200, 'U održavanju', 1),
('Pista 04', 2800, 'Aktivna', 1),
('Pista 05', 3500, 'Aktivna', 1),
('Pista 06', 3000, 'U održavanju', 1),
('Pista 07', 2700, 'Aktivna', 1),
('Pista 08', 3300, 'Aktivna', 1),
('Pista 09', 2900, 'Zatvorena', 1),
('Pista 10', 3100, 'Aktivna', 1),
('Pista 11', 3000, 'U održavanju', 1),
('Pista 12', 2500, 'Aktivna', 1),
('Pista 13', 3200, 'Zatvorena', 1),
('Pista 14', 2800, 'Aktivna', 1),
('Pista 15', 3500, 'Aktivna', 1),
('Pista 16', 3000, 'Aktivna', 1),
('Pista 17', 2700, 'Zatvorena', 1),
('Pista 18', 3300, 'Aktivna', 1),
('Pista 19', 2900, 'U održavanju', 1),
('Pista 20', 3100, 'Aktivna', 1),
('Pista 21', 3000, 'Aktivna', 1),
('Pista 22', 2500, 'U održavanju', 1),
('Pista 23', 3200, 'Aktivna', 1),
('Pista 24', 2800, 'Aktivna', 1),
('Pista 25', 3500, 'Aktivna', 1),
('Pista 26', 3000, 'Zatvorena', 1),
('Pista 27', 2700, 'Aktivna', 1),
('Pista 28', 3300, 'Aktivna', 1),
('Pista 29', 2900, 'Aktivna', 1),
('Pista 30', 3100, 'Aktivna', 1),
('Pista 31', 3000, 'Aktivna', 1),
('Pista 32', 2500, 'U održavanju', 1),
('Pista 33', 3200, 'Aktivna', 1),
('Pista 34', 2800, 'Aktivna', 1),
('Pista 35', 3500, 'Aktivna', 1);

-- unos podataka u tablicu terminali --
INSERT INTO terminali (naziv, id_zracna_luka)
VALUES
('Terminal 1', 1),
('Terminal 2', 1),
('Terminal 3', 1),
('Terminal 4', 1),
('Terminal 5', 1),
('Terminal 6', 1),
('Terminal 7', 1),
('Terminal 8', 1),
('Terminal 9', 1),
('Terminal 10', 1),
('Terminal 11', 1),
('Terminal 12', 1),
('Terminal 13', 1),
('Terminal 14', 1),
('Terminal 15', 1),
('Terminal 16', 1),
('Terminal 17', 1),
('Terminal 18', 1),
('Terminal 19', 1),
('Terminal 20', 1),
('Terminal 21', 1),
('Terminal 22', 1),
('Terminal 23', 1),
('Terminal 24', 1),
('Terminal 25', 1),
('Terminal 26', 1),
('Terminal 27', 1),
('Terminal 28', 1),
('Terminal 29', 1),
('Terminal 30', 1),
('Terminal 31', 1),
('Terminal 32', 1),
('Terminal 33', 1),
('Terminal 34', 1),
('Terminal 35', 1);

-- unos podataka u ablicu gateovi --
INSERT INTO gateovi (naziv, trenutni_status, id_terminal)
VALUES
('Gate A1', 'Aktivan', 1),
('Gate A2', 'Aktivan', 2),
('Gate A3', 'Zatvoren', 3),
('Gate A4', 'U održavanju', 4),
('Gate A5', 'Aktivan', 5),
('Gate A6', 'Aktivan', 6),
('Gate A7', 'Zatvoren', 7),
('Gate A8', 'Aktivan', 8),
('Gate A9', 'U održavanju', 9),
('Gate A10', 'Aktivan', 10),
('Gate A11', 'Aktivan', 11),
('Gate A12', 'Zatvoren', 12),
('Gate A13', 'Aktivan', 13),
('Gate A14', 'U održavanju', 14),
('Gate A15', 'Aktivan', 15),
('Gate A16', 'Aktivan', 16),
('Gate A17', 'Zatvoren', 17),
('Gate A18', 'Aktivan', 18),
('Gate A19', 'U održavanju', 19),
('Gate A20', 'Aktivan', 20),
('Gate A21', 'Aktivan', 21),
('Gate A22', 'Zatvoren', 22),
('Gate A23', 'Aktivan', 23),
('Gate A24', 'U održavanju', 24),
('Gate A25', 'Aktivan', 25),
('Gate A26', 'Aktivan', 26),
('Gate A27', 'Zatvoren', 27),
('Gate A28', 'Aktivan', 28),
('Gate A29', 'U održavanju', 29),
('Gate A30', 'Aktivan', 30),
('Gate A31', 'Aktivan', 31),
('Gate A32', 'Zatvoren', 32),
('Gate A33', 'Aktivan', 33),
('Gate A34', 'U održavanju', 34),
('Gate A35', 'Aktivan', 35);

-- unos podataka u tablicu letovi -- 

INSERT INTO letovi (broj_leta, vrijeme_polaska, vrijeme_dolaska, trenutni_status, id_avion, id_gate, id_pista)
VALUES
(1001, '2024-12-30 08:00:00', '2024-12-30 10:30:00', 'Zakazan', 1, 1, 1),
(1002, '2024-12-30 09:00:00', '2024-12-30 11:00:00', 'Zakazan', 2, 2, 2),
(1003, '2024-12-30 07:30:00', '2024-12-30 09:45:00', 'Odgođen', 3, 3, 3),
(1004, '2024-12-30 10:00:00', '2024-12-30 12:30:00', 'Zakazan', 4, 4, 4),
(1005, '2024-12-30 11:00:00', '2024-12-30 13:15:00', 'U tijeku', 5, 5, 5),
(1006, '2024-12-30 12:00:00', '2024-12-30 14:30:00', 'Otazan', 6, 6, 6),
(1007, '2024-12-30 13:00:00', '2024-12-30 15:00:00', 'Zakazan', 7, 7, 7),
(1008, '2024-12-30 14:00:00', '2024-12-30 16:30:00', 'Zakazan', 8, 8, 8),
(1009, '2024-12-30 15:00:00', '2024-12-30 17:45:00', 'U tijeku', 9, 9, 9),
(1010, '2024-12-30 16:00:00', '2024-12-30 18:00:00', 'Zakazan', 10, 10, 10),
(1011, '2024-12-30 06:00:00', '2024-12-30 08:30:00', 'Zakazan', 11, 11, 11),
(1012, '2024-12-30 07:00:00', '2024-12-30 09:15:00', 'Odgođen', 12, 12, 12),
(1013, '2024-12-30 09:30:00', '2024-12-30 11:45:00', 'Zakazan', 13, 13, 13),
(1014, '2024-12-30 10:30:00', '2024-12-30 12:00:00', 'Zakazan', 14, 14, 14),
(1015, '2024-12-30 11:30:00', '2024-12-30 13:45:00', 'U tijeku', 15, 15, 15),
(1016, '2024-12-30 08:30:00', '2024-12-30 10:45:00', 'Zakazan', 16, 16, 16),
(1017, '2024-12-30 09:15:00', '2024-12-30 11:30:00', 'Otazan', 17, 17, 17),
(1018, '2024-12-30 10:45:00', '2024-12-30 12:30:00', 'Zakazan', 18, 18, 18),
(1019, '2024-12-30 12:15:00', '2024-12-30 14:00:00', 'Zakazan', 19, 19, 19),
(1020, '2024-12-30 13:45:00', '2024-12-30 15:15:00', 'Zakazan', 20, 20, 20),
(1021, '2024-12-30 14:30:00', '2024-12-30 16:30:00', 'Zakazan', 21, 21, 21),
(1022, '2024-12-30 15:15:00', '2024-12-30 17:15:00', 'Odgođen', 22, 22, 22),
(1023, '2024-12-30 16:00:00', '2024-12-30 18:00:00', 'Zakazan', 23, 23, 23),
(1024, '2024-12-30 17:00:00', '2024-12-30 19:00:00', 'Zakazan', 24, 24, 24),
(1025, '2024-12-30 18:00:00', '2024-12-30 20:15:00', 'Otazan', 25, 25, 25),
(1026, '2024-12-30 19:30:00', '2024-12-30 21:30:00', 'Zakazan', 26, 26, 26),
(1027, '2024-12-30 20:15:00', '2024-12-30 22:00:00', 'Zakazan', 27, 27, 27),
(1028, '2024-12-30 21:00:00', '2024-12-30 23:30:00', 'Zakazan', 28, 28, 28),
(1029, '2024-12-30 22:00:00', '2024-12-31 00:30:00', 'Zakazan', 29, 29, 29),
(1030, '2024-12-30 23:00:00', '2024-12-31 01:30:00', 'Zakazan', 30, 30, 30),
(1031, '2024-12-30 06:30:00', '2024-12-30 08:45:00', 'U tijeku', 31, 31, 31),
(1032, '2024-12-30 07:45:00', '2024-12-30 10:00:00', 'Zakazan', 32, 32, 32),
(1033, '2024-12-30 08:15:00', '2024-12-30 10:30:00', 'Odgođen', 33, 33, 33),
(1034, '2024-12-30 09:45:00', '2024-12-30 12:00:00', 'Zakazan', 34, 34, 34),
(1035, '2024-12-30 10:15:00', '2024-12-30 12:30:00', 'Zakazan', 35, 35, 35);

-- unos podataka u tablicu uzlijetanja --

INSERT INTO uzlijetanja (vrijeme_uzlijetanja, id_let, id_pista, trenutni_status)
VALUES
('2024-12-30 08:15:00', 1, 1, 'U tijeku'),
('2024-12-30 09:00:00', 2, 2, 'Završeno'),
('2024-12-30 07:45:00', 3, 3, 'Odgođeno'),
('2024-12-30 10:30:00', 4, 4, 'U tijeku'),
('2024-12-30 11:15:00', 5, 5, 'Završeno'),
('2024-12-30 12:45:00', 6, 6, 'Otkazano'),
('2024-12-30 13:30:00', 7, 7, 'U tijeku'),
('2024-12-30 14:15:00', 8, 8, 'Završeno'),
('2024-12-30 15:45:00', 9, 9, 'Odgođeno'),
('2024-12-30 16:30:00', 10, 10, 'U tijeku'),
('2024-12-30 06:15:00', 11, 11, 'Završeno'),
('2024-12-30 07:30:00', 12, 12, 'Odgođeno'),
('2024-12-30 09:45:00', 13, 13, 'U tijeku'),
('2024-12-30 10:15:00', 14, 14, 'Završeno'),
('2024-12-30 11:45:00', 15, 15, 'Otkazano'),
('2024-12-30 08:30:00', 16, 16, 'U tijeku'),
('2024-12-30 09:15:00', 17, 17, 'Završeno'),
('2024-12-30 10:45:00', 18, 18, 'Odgođeno'),
('2024-12-30 12:15:00', 19, 19, 'U tijeku'),
('2024-12-30 13:00:00', 20, 20, 'Završeno'),
('2024-12-30 14:30:00', 21, 21, 'Odgođeno'),
('2024-12-30 15:15:00', 22, 22, 'U tijeku'),
('2024-12-30 16:00:00', 23, 23, 'Završeno'),
('2024-12-30 17:00:00', 24, 24, 'Odgođeno'),
('2024-12-30 18:15:00', 25, 25, 'U tijeku'),
('2024-12-30 19:30:00', 26, 26, 'Završeno'),
('2024-12-30 20:15:00', 27, 27, 'Otkazano'),
('2024-12-30 21:00:00', 28, 28, 'U tijeku'),
('2024-12-30 22:15:00', 29, 29, 'Završeno'),
('2024-12-30 23:00:00', 30, 30, 'Odgođeno'),
('2024-12-30 06:45:00', 31, 31, 'U tijeku'),
('2024-12-30 07:15:00', 32, 32, 'Završeno'),
('2024-12-30 08:00:00', 33, 33, 'Odgođeno'),
('2024-12-30 09:30:00', 34, 34, 'U tijeku'),
('2024-12-30 10:00:00', 35, 35, 'Završeno');

-- unos podataka u tablicu slijetanja --

INSERT INTO slijetanja (vrijeme_slijetanja, id_let, id_pista, trenutni_status)
VALUES
('2024-12-30 08:30:00', 1, 1, 'U tijeku'),
('2024-12-30 09:15:00', 2, 2, 'Završeno'),
('2024-12-30 07:50:00', 3, 3, 'Odgođeno'),
('2024-12-30 10:45:00', 4, 4, 'U tijeku'),
('2024-12-30 11:20:00', 5, 5, 'Završeno'),
('2024-12-30 12:55:00', 6, 6, 'Otkazano'),
('2024-12-30 13:40:00', 7, 7, 'U tijeku'),
('2024-12-30 14:25:00', 8, 8, 'Završeno'),
('2024-12-30 15:50:00', 9, 9, 'Odgođeno'),
('2024-12-30 16:40:00', 10, 10, 'U tijeku'),
('2024-12-30 06:25:00', 11, 11, 'Završeno'),
('2024-12-30 07:40:00', 12, 12, 'Odgođeno'),
('2024-12-30 09:55:00', 13, 13, 'U tijeku'),
('2024-12-30 10:20:00', 14, 14, 'Završeno'),
('2024-12-30 11:50:00', 15, 15, 'Otkazano'),
('2024-12-30 08:40:00', 16, 16, 'U tijeku'),
('2024-12-30 09:10:00', 17, 17, 'Završeno'),
('2024-12-30 10:35:00', 18, 18, 'Odgođeno'),
('2024-12-30 12:00:00', 19, 19, 'U tijeku'),
('2024-12-30 13:05:00', 20, 20, 'Završeno'),
('2024-12-30 14:50:00', 21, 21, 'Odgođeno'),
('2024-12-30 15:25:00', 22, 22, 'U tijeku'),
('2024-12-30 16:15:00', 23, 23, 'Završeno'),
('2024-12-30 17:10:00', 24, 24, 'Odgođeno'),
('2024-12-30 18:30:00', 25, 25, 'U tijeku'),
('2024-12-30 19:40:00', 26, 26, 'Završeno'),
('2024-12-30 20:30:00', 27, 27, 'Otkazano'),
('2024-12-30 21:10:00', 28, 28, 'U tijeku'),
('2024-12-30 22:25:00', 29, 29, 'Završeno'),
('2024-12-30 23:05:00', 30, 30, 'Odgođeno'),
('2024-12-30 06:50:00', 31, 31, 'U tijeku'),
('2024-12-30 07:30:00', 32, 32, 'Završeno'),
('2024-12-30 08:10:00', 33, 33, 'Odgođeno'),
('2024-12-30 09:20:00', 34, 34, 'U tijeku'),
('2024-12-30 10:05:00', 35, 35, 'Završeno');

-- unos podataka u tablicu klase_sjedala -- 

INSERT INTO klase_sjedala (naziv, opis, cijena, max_kapacitet)
VALUES
('Ekonomska', 'Standardna klasa, najpovoljnija opcija sa osnovnim uslugama.', 350.00, 150),
('Prva', 'Ekskluzivna klasa s maksimalnim udobnostima, većim prostorom i uslugama.', 1200.00, 30),
('Poslovna', 'Klasa koja nudi bolje udobnosti od ekonomske, uključujući veću privatnost i bolju uslugu.', 750.00, 40),
('Ekonomska Premium', 'Poboljšana verzija ekonomske klase s većim prostorom i boljim uslugama.', 500.00, 100),
('Poslovna Premium', 'Najbolja klasa s posebnim pogodnostima kao što su privatne kabine i vrhunska usluga.', 2000.00, 20),
('Ekonomska', 'Standardna klasa s osnovnim uslugama i povoljnim cijenama.', 330.00, 150),
('Prva', 'VrhunskA klasa s maksimalnim luksuzom, idealna za poslovne korisnike.', 1300.00, 30),
('Poslovna', 'Klasa s boljim uvjetima od ekonomske klase, idealna za poslovna putovanja.', 800.00, 40),
('Ekonomska', 'Ekonomska klasa koja omogućava povoljne cijene uz osnovne usluge.', 320.00, 160),
('Poslovna', 'Klasa s boljoj udobnosti i usluzi, idealna za poslovne putnike.', 850.00, 40),
('Prva', 'Luksuzna klasa koja nudi najbolju udobnost i luksuzne usluge.', 1400.00, 25),
('Ekonomska', 'Povoljan smještaj sa standardnim uslugama i dostupnim cijenama.', 310.00, 180),
('Prva', 'Za one koji traže najbolje iskustvo leta s luksuznim uvjetima.', 1450.00, 28),
('Poslovna', 'Klasa koja nudi izuzetnu udobnost za poslovne putnike.', 900.00, 50),
('Ekonomska', 'Osnovna klasa s povoljnim cijenama i osnovnim uslugama.', 300.00, 200),
('Poslovna', 'Klasa koja nudi bolju uslugu i više udobnosti od ekonomske.', 950.00, 45),
('Prva', 'Luksuzna klasa sa velikim prostorom i vrhunskom uslugom.', 1500.00, 22),
('Ekonomska', 'Povoljnija opcija za putnike sa osnovnim uslugama.', 310.00, 160),
('Poslovna', 'Komforna klasa s dobrim uvjetima za posao.', 875.00, 50),
('Ekonomska', 'Osnovna klasa s povoljnim cijenama i standardnim uslugama.', 320.00, 170),
('Prva', 'Prva klasa s najboljim uvjetima i ekskluzivnim pogodnostima.', 1400.00, 30),
('Poslovna', 'Komforna klasa s dodatnim pogodnostima za poslovne putnike.', 850.00, 50),
('Ekonomska', 'Klasa s osnovnim uslugama, najpristupačnija cijena.', 315.00, 160),
('Prva', 'Vrhunskih usluga s luksuznim uvjetima za najzahtjevnije putnike.', 1350.00, 30),
('Poslovna', 'Komforna klasa s pogodnostima koje omogućuju produktivno putovanje.', 950.00, 45),
('Ekonomska', 'Povoljnija klasa sa osnovnim uslugama.', 300.00, 180),
('Poslovna', 'Udobna klasa s boljim uvjetima za rad i udobnost.', 875.00, 50),
('Prva', 'Prva klasa s najboljim uvjetima za luksuzna putovanja.', 1400.00, 25),
('Ekonomska', 'Standardna klasa, pristupačna cijena za sve putnike.', 310.00, 170),
('Poslovna', 'Klasa s visokim standardima i pogodnostima za poslovne putnike.', 900.00, 45),
('Ekonomska', 'Osnovna klasa s povoljnim cijenama i standardnim uslugama.', 320.00, 160),
('Prva', 'Luksuzna klasa s velikim prostorom i vrhunskom uslugom.', 1500.00, 22),
('Poslovna', 'Poboljšana klasa sa boljim uvjetima za poslovne putnike.', 875.00, 50),
('Ekonomska', 'Standardna klasa sa osnovnim uslugama i povoljnim cijenama.', 330.00, 180),
('Poslovna', 'Komforna klasa s boljim uvjetima za poslovne putnike.', 890.00, 50),
('Ekonomska', 'Osnovna klasa sa standardnim uslugama i prihvatljivim cijenama.', 320.00, 160);

-- unos podataka u tablicu sjedala --

INSERT INTO sjedala (id_avion, id_klasa, broj_sjedala)
VALUES
(1, 1, 10),
(1, 2, 4),
(1, 3, 6),
(2, 1, 12),
(2, 2, 3),
(2, 3, 7),
(3, 1, 8),
(3, 2, 5),
(3, 3, 9),
(4, 1, 15),
(4, 2, 2),
(4, 3, 6),
(5, 1, 10),
(5, 2, 4),
(5, 3, 7),
(6, 1, 13),
(6, 2, 3),
(6, 3, 6),
(7, 1, 8),
(7, 2, 5),
(7, 3, 7),
(8, 1, 12),
(8, 2, 3),
(8, 3, 9),
(9, 1, 11),
(9, 2, 4),
(9, 3, 7),
(10, 1, 14),
(10, 2, 2),
(10, 3, 6),
(11, 1, 10),
(11, 2, 5),
(11, 3, 9),
(12, 1, 9),
(12, 2, 4);

-- unos podataka u tablicu putnici --

INSERT INTO putnici (ime, prezime, broj_putovnice, drzavljanstvo, datum_rodenja)
VALUES
('Ivan', 'Horvat', 'P1234567', 'Hrvatska', '1985-03-15'),
('Ana', 'Kovač', 'P2345678', 'Hrvatska', '1990-05-21'),
('Marko', 'Marić', 'P3456789', 'Hrvatska', '1982-07-30'),
('Luka', 'Petrović', 'P4567890', 'Hrvatska', '1988-02-10'),
('Sara', 'Novak', 'P5678901', 'Hrvatska', '1995-12-01'),
('Jelena', 'Ivić', 'P6789012', 'Hrvatska', '1992-04-25'),
('Petar', 'Savić', 'P7890123', 'Hrvatska', '1980-11-18'),
('Tanja', 'Babić', 'P8901234', 'Hrvatska', '1998-06-14'),
('Tomislav', 'Jurić', 'P9012345', 'Hrvatska', '1987-08-23'),
('Maja', 'Stanić', 'P0123456', 'Hrvatska', '1993-01-09'),
('Zoran', 'Knežević', 'P1234568', 'Hrvatska', '1980-10-12'),
('Martina', 'Vuković', 'P2345679', 'Hrvatska', '1991-09-05'),
('Karlo', 'Zorić', 'P3456790', 'Hrvatska', '1986-03-22'),
('Ivana', 'Čapek', 'P4567891', 'Hrvatska', '1994-04-11'),
('Nikola', 'Kovačević', 'P5678902', 'Hrvatska', '1983-12-19'),
('Dora', 'Lukić', 'P6789013', 'Hrvatska', '1992-01-13'),
('Vedran', 'Jovanović', 'P7890124', 'Hrvatska', '1990-10-30'),
('Kristina', 'Horvat', 'P8901235', 'Hrvatska', '1989-07-17'),
('Marko', 'Budić', 'P9012346', 'Hrvatska', '1984-11-22'),
('Lucija', 'Vrančić', 'P0123457', 'Hrvatska', '1996-05-14'),
('Andrej', 'Rajić', 'P1234569', 'Hrvatska', '1982-06-02'),
('Ivana', 'Kovačić', 'P2345680', 'Hrvatska', '1995-10-27'),
('Branimir', 'Berković', 'P3456791', 'Hrvatska', '1990-01-18'),
('Nina', 'Radić', 'P4567892', 'Hrvatska', '1993-11-09'),
('Damir', 'Kolar', 'P5678903', 'Hrvatska', '1987-04-21'),
('Petra', 'Jukić', 'P6789014', 'Hrvatska', '1988-12-03'),
('Stjepan', 'Kranjčar', 'P7890125', 'Hrvatska', '1981-07-10'),
('Matea', 'Kovačić', 'P8901236', 'Hrvatska', '1996-09-14'),
('Jakov', 'Tomić', 'P9012347', 'Hrvatska', '1990-08-27'),
('Lidija', 'Ivić', 'P0123458', 'Hrvatska', '1984-01-11'),
('Siniša', 'Grgić', 'P1234570', 'Hrvatska', '1993-06-29'),
('Simona', 'Čavić', 'P2345681', 'Hrvatska', '1995-02-18'),
('Luka', 'Matić', 'P3456792', 'Hrvatska', '1989-09-15'),
('Nikolina', 'Vukić', 'P4567893', 'Hrvatska', '1992-11-23'),
('Fran', 'Antunović', 'P5678904', 'Hrvatska', '1988-03-19'),
('Laura', 'Brezina', 'P6789015', 'Hrvatska', '1994-12-10'),
('Tomislav', 'Vuk', 'P7890126', 'Hrvatska', '1987-05-03'),
('Dorotea', 'Kolar', 'P8901237', 'Hrvatska', '1996-04-25'),
('Saša', 'Đukić', 'P9012348', 'Hrvatska', '1991-10-15');

-- unos podataka u tablicu karte --

INSERT INTO karte (id_sjedalo, id_let, id_putnik)
VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(6, 3, 6),
(7, 4, 7),
(8, 4, 8),
(9, 5, 9),
(10, 5, 10),
(11, 6, 11),
(12, 6, 12),
(13, 7, 13),
(14, 7, 14),
(15, 8, 15),
(16, 8, 16),
(17, 9, 17),
(18, 9, 18),
(19, 10, 19),
(20, 10, 20),
(21, 11, 21),
(22, 11, 22),
(23, 12, 23),
(24, 12, 24),
(25, 13, 25),
(26, 13, 26),
(27, 14, 27),
(28, 14, 28),
(29, 15, 29),
(30, 15, 30),
(31, 16, 31),
(32, 16, 32),
(33, 17, 33),
(34, 17, 34),
(35, 18, 35);

-- unos podataka u tablicu prtljaga -- 

INSERT INTO prtljaga (tezina_kg, tip_prtljage, id_karta)
VALUES
(23.50, 'Kofer', 1),
(15.20, 'Ruksak', 2),
(10.75, 'Torba', 3),
(25.00, 'Kofer', 4),
(30.10, 'Kofer', 5),
(18.60, 'Ruksak', 6),
(12.30, 'Torba', 7),
(20.00, 'Kofer', 8),
(22.40, 'Torba', 9),
(14.90, 'Kofer', 10),
(16.80, 'Ruksak', 11),
(28.00, 'Kofer', 12),
(17.50, 'Torba', 13),
(13.00, 'Kofer', 14),
(24.00, 'Ruksak', 15),
(26.30, 'Kofer', 16),
(21.70, 'Torba', 17),
(19.40, 'Kofer', 18),
(27.80, 'Ruksak', 19),
(23.10, 'Torba', 20),
(15.50, 'Kofer', 21),
(25.30, 'Ruksak', 22),
(12.60, 'Torba', 23),
(18.90, 'Kofer', 24),
(22.10, 'Torba', 25),
(19.50, 'Ruksak', 26),
(24.60, 'Kofer', 27),
(20.20, 'Ruksak', 28),
(30.50, 'Kofer', 29),
(17.00, 'Torba', 30),
(14.40, 'Ruksak', 31),
(23.30, 'Kofer', 32),
(19.90, 'Ruksak', 33),
(16.60, 'Torba', 34),
(20.10, 'Kofer', 35);

-- unos podataka u tablicu zaposlenici --

INSERT INTO zaposlenici (ime, prezime, placa, pozicija, smjena, id_zracna_luka)
VALUES
('Ivan', 'Horvat', 8000.00, 'Menadžer', 'Jutarnja', 1),
('Ana', 'Kovač', 5000.00, 'Radnik na pisti', 'Popodnevna', 1),
('Marko', 'Marić', 4500.00, 'Kontrolor leta', 'Noćna', 1),
('Luka', 'Petrović', 6000.00, 'Tehničar', 'Jutarnja', 1),
('Sara', 'Novak', 4800.00, 'Radnik na pisti', 'Popodnevna', 1),
('Jelena', 'Ivić', 7000.00, 'Supervizor', 'Noćna', 1),
('Petar', 'Savić', 5500.00, 'Tehničar', 'Jutarnja', 1),
('Tanja', 'Babić', 5300.00, 'Kontrolor leta', 'Popodnevna', 1),
('Tomislav', 'Jurić', 6800.00, 'Menadžer', 'Noćna', 1),
('Maja', 'Stanić', 4900.00, 'Radnik na pisti', 'Jutarnja', 1),
('Zoran', 'Knežević', 5600.00, 'Tehničar', 'Popodnevna', 1),
('Martina', 'Vuković', 6200.00, 'Supervizor', 'Noćna', 1),
('Karlo', 'Zorić', 5700.00, 'Radnik na pisti', 'Jutarnja', 1),
('Ivana', 'Čapek', 4800.00, 'Kontrolor leta', 'Popodnevna', 1),
('Nikola', 'Kovačević', 6400.00, 'Menadžer', 'Noćna', 1),
('Dora', 'Lukić', 5200.00, 'Tehničar', 'Jutarnja', 1),
('Vedran', 'Jovanović', 5500.00, 'Radnik na pisti', 'Popodnevna', 1),
('Kristina', 'Horvat', 6700.00, 'Kontrolor leta', 'Noćna', 1),
('Marko', 'Budić', 6000.00, 'Menadžer', 'Jutarnja', 1),
('Lucija', 'Vrančić', 5600.00, 'Tehničar', 'Popodnevna', 1),
('Andrej', 'Rajić', 6500.00, 'Radnik na pisti', 'Noćna', 1),
('Ivana', 'Kovačić', 5300.00, 'Kontrolor leta', 'Jutarnja', 1),
('Branimir', 'Berković', 7000.00, 'Supervizor', 'Popodnevna', 1),
('Nina', 'Radić', 4900.00, 'Tehničar', 'Noćna', 1),
('Damir', 'Kolar', 5400.00, 'Radnik na pisti', 'Jutarnja', 1),
('Petra', 'Jukić', 6500.00, 'Kontrolor leta', 'Popodnevna', 1),
('Stjepan', 'Kranjčar', 7200.00, 'Menadžer', 'Noćna', 1),
('Matea', 'Kovačić', 5300.00, 'Tehničar', 'Jutarnja', 1),
('Jakov', 'Tomić', 6000.00, 'Supervizor', 'Popodnevna', 1),
('Lidija', 'Ivić', 5800.00, 'Radnik na pisti', 'Noćna', 1),
('Siniša', 'Grgić', 6700.00, 'Kontrolor leta', 'Jutarnja', 1),
('Simona', 'Čavić', 5600.00, 'Tehničar', 'Popodnevna', 1),
('Luka', 'Matić', 6000.00, 'Radnik na pisti', 'Noćna', 1),
('Nikolina', 'Vukić', 6200.00, 'Kontrolor leta', 'Jutarnja', 1),
('Fran', 'Antunović', 6500.00, 'Supervizor', 'Popodnevna', 1),
('Laura', 'Brezina', 5400.00, 'Radnik na pisti', 'Noćna', 1),
('Tomislav', 'Vuk', 6900.00, 'Tehničar', 'Jutarnja', 1),
('Dorotea', 'Kolar', 6300.00, 'Kontrolor leta', 'Popodnevna', 1),
('Saša', 'Đukić', 5800.00, 'Menadžer', 'Noćna', 1);

-- unos podataka u tablicu osoblje_leta --

INSERT INTO osoblje_leta (id_let, id_zaposlenik, uloga)
VALUES
(1, 1, 'Pilot'),
(1, 2, 'Stjuardesa'),
(2, 3, 'Pilot'),
(2, 4, 'Stjuardesa'),
(3, 5, 'Pilot'),
(3, 6, 'Stjuardesa'),
(4, 7, 'Pilot'),
(4, 8, 'Stjuardesa'),
(5, 9, 'Pilot'),
(5, 10, 'Stjuardesa'),
(6, 11, 'Pilot'),
(6, 12, 'Stjuardesa'),
(7, 13, 'Pilot'),
(7, 14, 'Stjuardesa'),
(8, 15, 'Pilot'),
(8, 16, 'Stjuardesa'),
(9, 17, 'Pilot'),
(9, 18, 'Stjuardesa'),
(10, 19, 'Pilot'),
(10, 20, 'Stjuardesa'),
(11, 21, 'Pilot'),
(11, 22, 'Stjuardesa'),
(12, 23, 'Pilot'),
(12, 24, 'Stjuardesa'),
(13, 25, 'Pilot'),
(13, 26, 'Stjuardesa'),
(14, 27, 'Pilot'),
(14, 28, 'Stjuardesa'),
(15, 29, 'Pilot'),
(15, 30, 'Stjuardesa'),
(16, 31, 'Pilot'),
(16, 32, 'Stjuardesa'),
(17, 33, 'Pilot'),
(17, 34, 'Stjuardesa'),
(18, 35, 'Pilot');

-- unos podataka u tablicu prijem_prtljage --

INSERT INTO prijem_prtljage (trenutni_status, id_terminal)
VALUES
('Primitak u toku', 1),
('Primitak u toku', 2),
('Primitak u toku', 3),
('Primitak u toku', 4),
('Primitak u toku', 5),
('Primitak u toku', 6),
('Primitak u toku', 7),
('Primitak u toku', 8),
('Primitak u toku', 9),
('Primitak u toku', 10),
('Primitak završen', 1),
('Primitak završen', 2),
('Primitak završen', 3),
('Primitak završen', 4),
('Primitak završen', 5),
('Primitak završen', 6),
('Primitak završen', 7),
('Primitak završen', 8),
('Primitak završen', 9),
('Primitak završen', 10),
('Zamjena prtljage', 1),
('Zamjena prtljage', 2),
('Zamjena prtljage', 3),
('Zamjena prtljage', 4),
('Zamjena prtljage', 5),
('Zamjena prtljage', 6),
('Zamjena prtljage', 7),
('Zamjena prtljage', 8),
('Zamjena prtljage', 9),
('Zamjena prtljage', 10),
('Odbijen prijem', 1),
('Odbijen prijem', 2),
('Odbijen prijem', 3),
('Odbijen prijem', 4);

-- unos podataka u tablicu reklamacija_prtljage --

INSERT INTO reklamacija_prtljage (trenutni_status, id_prtljaga)
VALUES
('U postupku', 1),
('U postupku', 2),
('U postupku', 3),
('U postupku', 4),
('U postupku', 5),
('U postupku', 6),
('U postupku', 7),
('U postupku', 8),
('U postupku', 9),
('U postupku', 10),
('Zatvorena', 1),
('Zatvorena', 2),
('Zatvorena', 3),
('Zatvorena', 4),
('Zatvorena', 5),
('Zatvorena', 6),
('Zatvorena', 7),
('Zatvorena', 8),
('Zatvorena', 9),
('Zatvorena', 10),
('Prihvaćena', 1),
('Prihvaćena', 2),
('Prihvaćena', 3),
('Prihvaćena', 4),
('Prihvaćena', 5),
('Prihvaćena', 6),
('Prihvaćena', 7),
('Prihvaćena', 8),
('Prihvaćena', 9),
('Prihvaćena', 10),
('Odbijena', 1),
('Odbijena', 2),
('Odbijena', 3),
('Odbijena', 4);

-- unos podataka u tablicu izgubljena_prtljaga --

INSERT INTO izgubljena_prtljaga (opis, trenutni_status, id_prtljaga)
VALUES
('Izgubljena prtljaga, potencijalno oštećena', 'U postupku', 1),
('Izgubljena prtljaga, pregledana', 'U postupku', 2),
('Izgubljena prtljaga, čeka prepoznavanje', 'U postupku', 3),
('Izgubljena prtljaga, u istragama', 'U postupku', 4),
('Izgubljena prtljaga, neprepoznata', 'U postupku', 5),
('Izgubljena prtljaga, izgubljena nakon prijema', 'Zatvorena', 6),
('Izgubljena prtljaga, zahtijeva povratak', 'Zatvorena', 7),
('Izgubljena prtljaga, nalazi se na terminalu', 'Zatvorena', 8),
('Izgubljena prtljaga, u rezervaciji', 'Prihvaćena', 9),
('Izgubljena prtljaga, čekanje na povratak', 'Prihvaćena', 10),
('Izgubljena prtljaga, u procesu isporuke', 'Prihvaćena', 11),
('Izgubljena prtljaga, utvrđena greška', 'Prihvaćena', 12),
('Izgubljena prtljaga, povratak iz rane faze', 'Odbijena', 13),
('Izgubljena prtljaga, nepotpuna dokumentacija', 'Odbijena', 14),
('Izgubljena prtljaga, vratiti u zrakoplovnu kompaniju', 'Odbijena', 15),
('Izgubljena prtljaga, registrirana greška', 'Odbijena', 16),
('Izgubljena prtljaga, čekanje na povratak', 'Zatvorena', 17),
('Izgubljena prtljaga, čeka se povratak', 'U postupku', 18),
('Izgubljena prtljaga, istražuje se šteta', 'U postupku', 19),
('Izgubljena prtljaga, u procesu identifikacije', 'Zatvorena', 20),
('Izgubljena prtljaga, nesigurni podaci', 'Zatvorena', 21),
('Izgubljena prtljaga, čekanje na dodatnu provjeru', 'U postupku', 22),
('Izgubljena prtljaga, čekanje na povratak u zrakoplov', 'U postupku', 23),
('Izgubljena prtljaga, zahtijeva detaljnu inspekciju', 'Zatvorena', 24),
('Izgubljena prtljaga, u konačnom prepoznavanju', 'Zatvorena', 25),
('Izgubljena prtljaga, zaključena istraga', 'Prihvaćena', 26),
('Izgubljena prtljaga, neregistrirani slučaj', 'Prihvaćena', 27),
('Izgubljena prtljaga, zahtijeva usmjerenje', 'Prihvaćena', 28),
('Izgubljena prtljaga, ubrzana obnova', 'Prihvaćena', 29),
('Izgubljena prtljaga, nepoznati status', 'Odbijena', 30),
('Izgubljena prtljaga, u ranoj fazi inspekcije', 'Odbijena', 31),
('Izgubljena prtljaga, potrebno daljnje razjašnjenje', 'Odbijena', 32),
('Izgubljena prtljaga, čekanje na rješenje', 'U postupku', 33),
('Izgubljena prtljaga, odgođeno rješenje', 'U postupku', 34),
('Izgubljena prtljaga, provjera za predaju', 'U postupku', 35);

-- unos podataka u tablicu ukrcajne_karte --

INSERT INTO ukrcajne_karte (vrijeme_ukrcaja, id_karta, id_gate)
VALUES
('2024-12-30 08:00:00', 1, 1),
('2024-12-30 08:15:00', 2, 2),
('2024-12-30 08:30:00', 3, 3),
('2024-12-30 08:45:00', 4, 4),
('2024-12-30 09:00:00', 5, 5),
('2024-12-30 09:15:00', 6, 6),
('2024-12-30 09:30:00', 7, 7),
('2024-12-30 09:45:00', 8, 8),
('2024-12-30 10:00:00', 9, 9),
('2024-12-30 10:15:00', 10, 10),
('2024-12-30 10:30:00', 11, 1),
('2024-12-30 10:45:00', 12, 2),
('2024-12-30 11:00:00', 13, 3),
('2024-12-30 11:15:00', 14, 4),
('2024-12-30 11:30:00', 15, 5),
('2024-12-30 11:45:00', 16, 6),
('2024-12-30 12:00:00', 17, 7),
('2024-12-30 12:15:00', 18, 8),
('2024-12-30 12:30:00', 19, 9),
('2024-12-30 12:45:00', 20, 10),
('2024-12-30 13:00:00', 21, 1),
('2024-12-30 13:15:00', 22, 2),
('2024-12-30 13:30:00', 23, 3),
('2024-12-30 13:45:00', 24, 4),
('2024-12-30 14:00:00', 25, 5),
('2024-12-30 14:15:00', 26, 6),
('2024-12-30 14:30:00', 27, 7),
('2024-12-30 14:45:00', 28, 8),
('2024-12-30 15:00:00', 29, 9),
('2024-12-30 15:15:00', 30, 10),
('2024-12-30 15:30:00', 31, 1),
('2024-12-30 15:45:00', 32, 2),
('2024-12-30 16:00:00', 33, 3),
('2024-12-30 16:15:00', 34, 4),
('2024-12-30 16:30:00', 35, 5);

-- unos podataka u tablicu evidencija_odrzavanja_aviona --

INSERT INTO evidencija_odrzavanja_aviona (opis, datum_odrzavanja, id_avion)
VALUES
('Redovito održavanje motora', '2024-12-01', 1),
('Inspekcija hidrauličkog sustava', '2024-12-02', 2),
('Zamjena kotača i guma', '2024-12-03', 3),
('Provjera navigacijskog sustava', '2024-12-04', 4),
('Zamjena filtera za zrak', '2024-12-05', 5),
('Provjera sustava za grijanje', '2024-12-06', 6),
('Održavanje električnog sustava', '2024-12-07', 7),
('Kontrola vanjske opreme', '2024-12-08', 8),
('Testiranje pilota i kontrola instrumenata', '2024-12-09', 9),
('Održavanje sustava za gorivo', '2024-12-10', 10),
('Redovita inspekcija motora', '2024-12-11', 11),
('Provjera sustava za protupožarnu zaštitu', '2024-12-12', 12),
('Testiranje rada klimatizacijskog sustava', '2024-12-13', 13),
('Zamjena akumulatora', '2024-12-14', 14),
('Održavanje sustava za upravljanje letom', '2024-12-15', 15),
('Provjera sustava za komunikaciju', '2024-12-16', 16),
('Inspekcija interijera kabine', '2024-12-17', 17),
('Kontrola rada elektroničkih uređaja', '2024-12-18', 18),
('Provjera radnog statusa sistema za izbacivanje goriva', '2024-12-19', 19),
('Održavanje sustava za stabilnost', '2024-12-20', 20),
('Zamjena unutarnjih filtara', '2024-12-21', 21),
('Redovita kontrola stabilizatora', '2024-12-22', 22),
('Provjera sustava za dekompresiju', '2024-12-23', 23),
('Zamjena dijelova kompresora', '2024-12-24', 24),
('Inspekcija kabinskih vrata i izlaza', '2024-12-25', 25),
('Testiranje radio komunikacijskog sustava', '2024-12-26', 26),
('Održavanje sustava za temperature motora', '2024-12-27', 27),
('Zamjena senzora za tlak u gorivu', '2024-12-28', 28),
('Provjera stanja repnog stabilizatora', '2024-12-29', 29),
('Testiranje hidrauličkih sustava i pumpi', '2024-12-30', 30),
('Održavanje strukturalnih elemenata aviona', '2024-12-31', 31),
('Provjera elektroničkih sustava navigacije', '2024-12-01', 32),
('Zamjena sustava za zrakoplovnu ventilaciju', '2024-12-02', 33),
('Kontrola svih sigurnosnih uređaja', '2024-12-03', 34),
('Redovita inspekcija svih vitalnih sustava', '2024-12-04', 35);

-- unos podataka u tablicu evidencija_goriva --

INSERT INTO evidencija_goriva (kolicina_litara, datum_tocenja, id_avion)
VALUES
(1500.00, '2024-12-01', 1),
(2000.00, '2024-12-02', 2),
(1800.00, '2024-12-03', 3),
(2200.00, '2024-12-04', 4),
(1700.00, '2024-12-05', 5),
(2100.00, '2024-12-06', 6),
(1900.00, '2024-12-07', 7),
(2300.00, '2024-12-08', 8),
(2000.00, '2024-12-09', 9),
(2400.00, '2024-12-10', 10),
(1600.00, '2024-12-11', 11),
(2100.00, '2024-12-12', 12),
(1800.00, '2024-12-13', 13),
(2200.00, '2024-12-14', 14),
(1750.00, '2024-12-15', 15),
(2050.00, '2024-12-16', 16),
(1900.00, '2024-12-17', 17),
(2150.00, '2024-12-18', 18),
(2000.00, '2024-12-19', 19),
(2250.00, '2024-12-20', 20),
(1700.00, '2024-12-21', 21),
(2100.00, '2024-12-22', 22),
(1850.00, '2024-12-23', 23),
(2300.00, '2024-12-24', 24),
(2000.00, '2024-12-25', 25),
(2400.00, '2024-12-26', 26),
(1900.00, '2024-12-27', 27),
(2200.00, '2024-12-28', 28),
(2100.00, '2024-12-29', 29),
(2000.00, '2024-12-30', 30),
(2300.00, '2024-12-31', 31),
(1800.00, '2024-12-01', 32),
(2200.00, '2024-12-02', 33),
(1950.00, '2024-12-03', 34),
(2100.00, '2024-12-04', 35);

-- unos podatata u tablicu kasnjenje_letova --

INSERT INTO kasnjenja_letova (razlog, trajanje_minuta, id_let)
VALUES
('Tehnička nesreća', 45, 1),
('Loše vremenske prilike', 30, 2),
('Odgoda zbog kontrole sigurnosti', 20, 3),
('Poteškoće sa opremom', 60, 4),
('Zakašnjelo ukrcavanje', 15, 5),
('Zbog zračne kontrole', 40, 6),
('Problemi sa sustavom za gorivo', 50, 7),
('Poteškoće sa sustavom za grijanje', 25, 8),
('Zakašnjelo dolazak posade', 10, 9),
('Zakašnjelo slijetanje zbog gužve na pisti', 35, 10),
('Tehnička inspekcija aviona', 55, 11),
('Zakašnjelo ukrcavanje putnika', 15, 12),
('Zakašnjelo dolazak iz drugih zračnih luka', 30, 13),
('Problemi sa zračnim koridorom', 60, 14),
('Učestalija zračne oluje', 40, 15),
('Neodgovarajući uvjeti na pisti', 20, 16),
('Kasnjenje zbog loših uvjeta za slijetanje', 30, 17),
('Zakašnjenje zbog odgađanja leta', 50, 18),
('Tehnička provjera aviona', 25, 19),
('Problemi s opremom za ukrcaj', 20, 20),
('Odgađanje zbog promjene vremenskih uvjeta', 45, 21),
('Problemi sa sustavom za navigaciju', 35, 22),
('Gužve na zračnoj luci', 10, 23),
('Poteškoće sa samim avionom', 50, 24),
('Odgoda zbog kvara na terminalu', 20, 25),
('Problemi s pilotskom opremom', 40, 26),
('Zakašnjenje zbog pogreške u rasporedu leta', 15, 27),
('Problemi sa sustavom za komuniciranje', 30, 28),
('Tehnički problemi sa hidrauličkim sustavom', 45, 29),
('Odgoda zbog gužve na pristupnoj cesti', 20, 30),
('Problemi sa sustavom za predviđanje vremena', 55, 31),
('Odgoda zbog zračne nesreće u okolini', 65, 32),
('Problemi sa kontrolom leta', 25, 33),
('Zakašnjenje zbog potrebne zamjene dijelova', 50, 34),
('Tehnička inspekcija zbog sigurnosnih razloga', 60, 35);

-- unos podataka u tablicu posebne_ponude --

INSERT INTO posebne_ponude (opis, vrijedi_do, id_karta)
VALUES
('Popust za obiteljske karte', '2025-01-15', 1),
('Besplatan prtljag uz kupnju karte', '2025-02-10', 2),
('Popust za rano rezerviranje', '2025-03-01', 3),
('Akcija na povratne karte', '2025-04-20', 4),
('Popust za studente', '2025-05-30', 5),
('Besplatan obrok na letu', '2025-06-10', 6),
('Popust za seniora', '2025-07-15', 7),
('Promo ponuda za prvi let', '2025-08-01', 8),
('Popust na avionske karte za grupne rezervacije', '2025-09-10', 9),
('Sniženje cijene za izabrane destinacije', '2025-10-20', 10),
('Popust za kupovinu karte u 2. klasi', '2025-11-05', 11),
('Povećanje broja kilometara za vjerne putnike', '2025-12-01', 12),
('Besplatan Wi-Fi na letu', '2025-01-10', 13),
('Promocija povratnih karata', '2025-02-15', 14),
('Popust za putovanja u izvansezoni', '2025-03-01', 15),
('Popust za mlade putnike do 30 godina', '2025-04-05', 16),
('Posebne ponude za poslovne putnike', '2025-05-25', 17),
('Paketi karata za obitelj', '2025-06-15', 18),
('Gratis usluga prijevoza do zračne luke', '2025-07-30', 19),
('Popust za vojnu osobu', '2025-08-20', 20),
('Ponuda za putovanje na međunarodne destinacije', '2025-09-10', 21),
('Popust na karte za letove u jutarnjim satima', '2025-10-01', 22),
('Poklon bon za sljedeće putovanje', '2025-11-10', 23),
('Dodatni kilogram prtljage besplatno', '2025-12-20', 24),
('Paketi karata za bračne parove', '2025-01-25', 25),
('Popust za putovanje na popularne ljetne destinacije', '2025-02-18', 26),
('Besplatan parking za putnike', '2025-03-10', 27),
('Popust na luksuzne sjedalice', '2025-04-15', 28),
('Gratis putničke usluge na letovima', '2025-05-20', 29),
('Ponuda za posebne zahtjeve', '2025-06-01', 30),
('Sniženje za letove u ranim jutarnjim satima', '2025-07-25', 31),
('Popust za putovanja u prve klase', '2025-08-05', 32),
('Besplatan ručak i piće na letu', '2025-09-15', 33),
('Promocija za povratne karte za zimske destinacije', '2025-10-10', 34),
('Specijalna ponuda za sezonske karte', '2025-11-20', 35);

-- unos podataka u tablicu business_lounge --

INSERT INTO bussines_lounge (naziv, id_terminal)
VALUES
('Lounge A', 1),
('Lounge B', 2),
('Lounge C', 3),
('Lounge D', 4),
('Lounge E', 5),
('Lounge F', 6),
('Lounge G', 7),
('Lounge H', 8),
('Lounge I', 9),
('Lounge J', 10),
('Lounge K', 11),
('Lounge L', 12),
('Lounge M', 13),
('Lounge N', 14),
('Lounge O', 15),
('Lounge P', 16),
('Lounge Q', 17),
('Lounge R', 18),
('Lounge S', 19),
('Lounge T', 20),
('Lounge U', 21),
('Lounge V', 22),
('Lounge W', 23),
('Lounge X', 24),
('Lounge Y', 25),
('Lounge Z', 26),
('Lounge AA', 27),
('Lounge AB', 28),
('Lounge AC', 29),
('Lounge AD', 30),
('Lounge AE', 31),
('Lounge AF', 32),
('Lounge AG', 33),
('Lounge AH', 34),
('Lounge AI', 35);

-- unos podataka u tablicu pristup_business_loungeu --

INSERT INTO pristup_business_loungeu (datum_pristupa, id_putnik, id_business_lounge)
VALUES
('2024-01-15', 1, 1),
('2024-02-10', 2, 2),
('2024-03-01', 3, 3),
('2024-04-20', 4, 4),
('2024-05-30', 5, 5),
('2024-06-10', 6, 6),
('2024-07-15', 7, 7),
('2024-08-01', 8, 8),
('2024-09-10', 9, 9),
('2024-10-20', 10, 10),
('2024-11-05', 11, 11),
('2024-12-01', 12, 12),
('2024-01-10', 13, 13),
('2024-02-15', 14, 14),
('2024-03-01', 15, 15),
('2024-04-05', 16, 16),
('2024-05-25', 17, 17),
('2024-06-15', 18, 18),
('2024-07-30', 19, 19),
('2024-08-20', 20, 20),
('2024-09-10', 21, 21),
('2024-10-01', 22, 22),
('2024-11-10', 23, 23),
('2024-12-20', 24, 24),
('2024-01-25', 25, 25),
('2024-02-18', 26, 26),
('2024-03-10', 27, 27),
('2024-04-15', 28, 28),
('2024-05-20', 29, 29),
('2024-06-01', 30, 30),
('2024-07-25', 31, 31),
('2024-08-05', 32, 32),
('2024-09-15', 33, 33),
('2024-10-10', 34, 34),
('2024-11-20', 35, 35);

-- unos podataka u tablicu parkiranje --

INSERT INTO parkiranje (broj_vozila, vrijeme_pocetka, vrijeme_kraja, id_zracna_luka)
VALUES
(101, '08:00:00', '12:00:00', 1),
(102, '09:30:00', '14:30:00', 1),
(103, '10:00:00', '15:00:00', 1),
(104, '11:00:00', '16:00:00', 1),
(105, '12:00:00', '17:00:00', 1),
(106, '13:00:00', '18:00:00', 1),
(107, '14:00:00', '19:00:00', 1),
(108, '15:00:00', '20:00:00', 1),
(109, '16:00:00', '21:00:00', 1),
(110, '17:00:00', '22:00:00', 1),
(111, '18:00:00', '23:00:00', 1),
(112, '19:00:00', '00:00:00', 1),
(113, '20:00:00', '01:00:00', 1),
(114, '21:00:00', '02:00:00', 1),
(115, '22:00:00', '03:00:00', 1),
(116, '23:00:00', '04:00:00', 1),
(117, '08:30:00', '12:30:00', 1),
(118, '09:45:00', '13:45:00', 1),
(119, '10:30:00', '14:30:00', 1),
(120, '11:30:00', '15:30:00', 1),
(121, '12:30:00', '16:30:00', 1),
(122, '13:30:00', '17:30:00', 1),
(123, '14:30:00', '18:30:00', 1),
(124, '15:30:00', '19:30:00', 1),
(125, '16:30:00', '20:30:00', 1),
(126, '17:30:00', '21:30:00', 1),
(127, '18:30:00', '22:30:00', 1),
(128, '19:30:00', '23:30:00', 1),
(129, '20:30:00', '00:30:00', 1),
(130, '21:30:00', '01:30:00', 1),
(131, '22:30:00', '02:30:00', 1),
(132, '23:30:00', '03:30:00', 1),
(133, '08:00:00', '12:30:00', 1),
(134, '09:00:00', '13:00:00', 1),
(135, '10:00:00', '14:30:00', 1);

-- unos podataka u tablicu servisna_vozila --

INSERT INTO servisna_vozila (broj_vozila, tip, trenutni_status, id_zracna_luka)
VALUES
(201, 'Vozilo za čišćenje', 'Aktivno', 1),
(202, 'Vozilo za gorivo', 'Neaktivno', 1),
(203, 'Vozilo za transport', 'Aktivno', 1),
(204, 'Vozilo za popravak', 'Na servisu', 1),
(205, 'Vozilo za čišćenje', 'Aktivno', 1),
(206, 'Vozilo za gorivo', 'Neaktivno', 1),
(207, 'Vozilo za transport', 'Aktivno', 1),
(208, 'Vozilo za popravak', 'Na servisu', 1),
(209, 'Vozilo za čišćenje', 'Aktivno', 1),
(210, 'Vozilo za gorivo', 'Neaktivno', 1),
(211, 'Vozilo za transport', 'Aktivno', 1),
(212, 'Vozilo za popravak', 'Na servisu', 1),
(213, 'Vozilo za čišćenje', 'Aktivno', 1),
(214, 'Vozilo za gorivo', 'Neaktivno', 1),
(215, 'Vozilo za transport', 'Aktivno', 1),
(216, 'Vozilo za popravak', 'Na servisu', 1),
(217, 'Vozilo za čišćenje', 'Aktivno', 1),
(218, 'Vozilo za gorivo', 'Neaktivno', 1),
(219, 'Vozilo za transport', 'Aktivno', 1),
(220, 'Vozilo za popravak', 'Na servisu', 1),
(221, 'Vozilo za čišćenje', 'Aktivno', 1),
(222, 'Vozilo za gorivo', 'Neaktivno', 1),
(223, 'Vozilo za transport', 'Aktivno', 1),
(224, 'Vozilo za popravak', 'Na servisu', 1),
(225, 'Vozilo za čišćenje', 'Aktivno', 1),
(226, 'Vozilo za gorivo', 'Neaktivno', 1),
(227, 'Vozilo za transport', 'Aktivno', 1),
(228, 'Vozilo za popravak', 'Na servisu', 1),
(229, 'Vozilo za čišćenje', 'Aktivno', 1),
(230, 'Vozilo za gorivo', 'Neaktivno', 1),
(231, 'Vozilo za transport', 'Aktivno', 1),
(232, 'Vozilo za popravak', 'Na servisu', 1),
(233, 'Vozilo za čišćenje', 'Aktivno', 1),
(234, 'Vozilo za gorivo', 'Neaktivno', 1),
(235, 'Vozilo za transport', 'Aktivno', 1);

-- unos podataka u tablicu vremenski_uvjeti --

INSERT INTO vremenski_uvjeti (uvjeti, temperatura, vlaga, id_pista)
VALUES
('Sunčano', 25.50, 40.00, 1),
('Oblačno', 22.30, 60.00, 2),
('Kišovito', 18.20, 80.00, 3),
('Maglovito', 15.00, 85.00, 4),
('Sunčano', 27.00, 35.00, 5),
('Oblačno', 20.00, 65.00, 6),
('Kišovito', 19.50, 75.00, 7),
('Maglovito', 14.80, 90.00, 8),
('Sunčano', 26.10, 45.00, 9),
('Oblačno', 23.00, 55.00, 10),
('Kišovito', 17.50, 78.00, 11),
('Maglovito', 16.00, 88.00, 12),
('Sunčano', 28.00, 30.00, 13),
('Oblačno', 21.50, 70.00, 14),
('Kišovito', 20.00, 82.00, 15),
('Maglovito', 13.50, 85.00, 16),
('Sunčano', 25.00, 40.00, 17),
('Oblačno', 22.50, 60.00, 18),
('Kišovito', 18.80, 77.00, 19),
('Maglovito', 15.20, 85.00, 20),
('Sunčano', 27.50, 38.00, 21),
('Oblačno', 20.80, 63.00, 22),
('Kišovito', 19.00, 79.00, 23),
('Maglovito', 14.40, 87.00, 24),
('Sunčano', 26.80, 42.00, 25),
('Oblačno', 23.20, 57.00, 26),
('Kišovito', 17.30, 74.00, 27),
('Maglovito', 16.50, 89.00, 28),
('Sunčano', 29.10, 33.00, 29),
('Oblačno', 22.70, 68.00, 30),
('Kišovito', 18.60, 76.00, 31),
('Maglovito', 14.90, 84.00, 32),
('Sunčano', 24.80, 50.00, 33),
('Oblačno', 21.30, 62.00, 34),
('Kišovito', 19.80, 80.00, 35);
