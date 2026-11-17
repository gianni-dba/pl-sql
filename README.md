Laboratorio pratico di programmazione **PL/SQL** su Oracle Database, sviluppato su un caso d'uso gestionale per la logistica e il tracciamento delle spedizioni.

L'obiettivo del progetto è consolidare l'apprendimento del PL/SQL applicandolo direttamente su un progetto relazionale realizzato nel database, garantendo l'integrità referenziale, la prevenzione dei lock e la gestione strutturata delle eccezioni.

---

## Architettura del Database

Lo schema relazionale è composto da 6 tabelle principali più una **Global Temporary Table (GTT)** di servizio per i log di elaborazione:

* **`CLIENTE` & `CORRIERE`**: Anagrafiche dei soggetti e stato operatività dei mezzi.
* **`MAGAZZINO`**: Hub logistici identificati da codice alfanumerico e capacità massima.
* **`SPEDIZIONE`**: Tabella centrale collegata ai clienti (mittente/destinatario) con vincoli su stati e date.
* **`TRANSITO` & `GESTIONE`**: Tabelle associative per tracciare i passaggi nei magazzini e l'assegnazione ai corrieri.
* **`LOG_SPED`**: Tabella temporanea (`ON COMMIT PRESERVE ROWS`) per il tracciamento dei batch di sessione.
---

### Accorgimenti DBA implementati nello schema
* **Indicizzazione delle Foreign Key**: Creazione esplicita degli indici su tutte le chiavi esterne (`IDX_SPED_MITTENTE`, `IDX_SPED_DESTINATARIO`, `IDX_GEST_SPED`, `IDX_TRANS_MAG`) per evitare lock a livello di tabella durante operazioni di `UPDATE` o `DELETE` sulle tabelle padre.
* **Integrità dei dati**: Utilizzo di vincoli `CHECK` rigidi sugli stati operativi e sulla coerenza temporale delle date di spedizione, transito e consegna.

---

### Come eseguire il laboratorio: 

1. Connettersi a un'istanza Oracle (es. via SQL Developer, SQL*Plus o SQLcl) con un utente dotato dei privilegi di creazione tabelle e procedure.
2. Eseguire in ordine gli script nella cartella `DDL-DML/` (`01_create_tables.sql` e `02_insert.sql`).
3. Abilitare l'output a console (`SET SERVEROUTPUT ON;`) ed eseguire i singoli script nella cartella `scripts_plsql/`.
