-- ============================================================================
-- 02_insert.sql
-- Popolamento iniziale con casistiche utili ai test PL/SQL
-- ============================================================================

-- 1. Clienti (ID generati automaticamente da 1 a 5)
INSERT INTO Cliente (Nome, Cognome, Ragione_Sociale, Indirizzo, Citta, CAP, Telefono, Email)
VALUES ('Marco', 'Rossi', NULL, 'Via Roma 12', 'Milano', '20121', '021234567', 'marco.rossi@email.it');

INSERT INTO Cliente (Nome, Cognome, Ragione_Sociale, Indirizzo, Citta, CAP, Telefono, Email)
VALUES ('Laura', 'Bianchi', 'Bianchi Tech Srl', 'Viale Europa 45', 'Firenze', '50126', '055987654', 'info@bianchitech.it');

INSERT INTO Cliente (Nome, Cognome, Ragione_Sociale, Indirizzo, Citta, CAP, Telefono, Email)
VALUES ('Giuseppe', 'Verdi', NULL, 'Corso Vittorio 88', 'Torino', '10121', '011456789', 'g.verdi@email.it');

INSERT INTO Cliente (Nome, Cognome, Ragione_Sociale, Indirizzo, Citta, CAP, Telefono, Email)
VALUES ('Elena', 'Neri', 'Logistica Sud SpA', 'Via Toledo 10', 'Napoli', '80134', '081321654', 'elena@logisticasud.it');

INSERT INTO Cliente (Nome, Cognome, Ragione_Sociale, Indirizzo, Citta, CAP, Telefono, Email)
VALUES ('Andrea', 'Gialli', NULL, 'Via Indipendenza 5', 'Bologna', '40121', '051789123', 'a.gialli@email.it');

-- 2. Corrieri (ID da 1 a 4, attivi e non attivi)
INSERT INTO Corriere (Nome, Cognome, Mezzo_Trasporto, Attivo) VALUES ('Luca', 'Ferri', 'FURGONE', 'S');
INSERT INTO Corriere (Nome, Cognome, Mezzo_Trasporto, Attivo) VALUES ('Paolo', 'Conti', 'CAMION', 'S');
INSERT INTO Corriere (Nome, Cognome, Mezzo_Trasporto, Attivo) VALUES ('Sara', 'Mancini', 'MOTO', 'N');
INSERT INTO Corriere (Nome, Cognome, Mezzo_Trasporto, Attivo) VALUES ('Davide', 'Riva', 'AUTO', 'S');

-- 3. Magazzini
INSERT INTO Magazzino (Codice_Magazzino, Citta, Indirizzo, Capacita_Max_Kg)
VALUES ('MAG_MI01', 'Milano', 'Via Mecenate 76', 50000);

INSERT INTO Magazzino (Codice_Magazzino, Citta, Indirizzo, Capacita_Max_Kg)
VALUES ('MAG_FI01', 'Firenze', 'Via Osmannoro 112', 35000);

INSERT INTO Magazzino (Codice_Magazzino, Citta, Indirizzo, Capacita_Max_Kg)
VALUES ('MAG_BO01', 'Bologna', 'Interporto Blocco 4', 80000);

-- 4. Spedizioni (Casistiche miste per test)
INSERT INTO Spedizione (Data_Spedizione, Data_Consegna_Prevista, Data_Consegna_Effettiva, Peso, Volume, Valore_Dichiarato, Codice_Mittente, Codice_Destinatario, Stato_Spedizione)
VALUES (SYSDATE - 10, SYSDATE - 5, SYSDATE - 3, 15.50, 0.40, 250.00, 1, 2, 'CONSEGNATA');

INSERT INTO Spedizione (Data_Spedizione, Data_Consegna_Prevista, Data_Consegna_Effettiva, Peso, Volume, Valore_Dichiarato, Codice_Mittente, Codice_Destinatario, Stato_Spedizione)
VALUES (SYSDATE - 8, SYSDATE - 2, SYSDATE - 3, 4.20, 0.15, 80.00, 2, 3, 'CONSEGNATA');

INSERT INTO Spedizione (Data_Spedizione, Data_Consegna_Prevista, Data_Consegna_Effettiva, Peso, Volume, Valore_Dichiarato, Codice_Mittente, Codice_Destinatario, Stato_Spedizione)
VALUES (SYSDATE - 6, SYSDATE - 1, SYSDATE - 1, 28.00, 1.20, 1200.00, 3, 4, 'CONSEGNATA');

-- sped 4: Non consegnata, Volume < 0.05 (innesca ZERO_DIVIDE nello script 03)
INSERT INTO Spedizione (Data_Spedizione, Data_Consegna_Prevista, Data_Consegna_Effettiva, Peso, Volume, Valore_Dichiarato, Codice_Mittente, Codice_Destinatario, Stato_Spedizione)
VALUES (SYSDATE - 2, SYSDATE + 2, NULL, 2.50, 0.02, 45.00, 4, 5, 'IN_TRANSITO');

-- sped5: PRESA_IN_CARICO con data prevista scaduta da >5 giorni (target per script 05 FOR UPDATE)
INSERT INTO Spedizione (Data_Spedizione, Data_Consegna_Prevista, Data_Consegna_Effettiva, Peso, Volume, Valore_Dichiarato, Codice_Mittente, Codice_Destinatario, Stato_Spedizione)
VALUES (SYSDATE - 12, SYSDATE - 7, NULL, 18.00, 0.60, 400.00, 5, 1, 'PRESA_IN_CARICO');

-- sped 6: Peso NULL per testare controlli sui valori mancanti
INSERT INTO Spedizione (Data_Spedizione, Data_Consegna_Prevista, Data_Consegna_Effettiva, Peso, Volume, Valore_Dichiarato, Codice_Mittente, Codice_Destinatario, Stato_Spedizione)
VALUES (SYSDATE - 1, SYSDATE + 3, NULL, NULL, 0.30, 150.00, 1, 3, 'CREATA');

-- 5. Gestione e Transito
INSERT INTO Gestione (Codice_Corriere, Codice_Spedizione, Data_Assegnazione, Ruolo)
VALUES (1, 1, SYSDATE - 10, 'RITIRO_E_CONSEGNA');

INSERT INTO Gestione (Codice_Corriere, Codice_Spedizione, Data_Assegnazione, Ruolo)
VALUES (2, 4, SYSDATE - 2, 'TRATTA_NAZIONALE');

INSERT INTO Transito (Codice_Spedizione, Codice_Magazzino, Data_Arrivo, Data_Partenza, Stato)
VALUES (4, 'MAG_MI01', SYSDATE - 1, NULL, 'IN_DEPOSITO');

INSERT INTO Transito (Codice_Spedizione, Codice_Magazzino, Data_Arrivo, Data_Partenza, Stato)
VALUES (5, 'MAG_FI01', SYSDATE - 8, SYSDATE - 7, 'COMPLETATO');

COMMIT;
