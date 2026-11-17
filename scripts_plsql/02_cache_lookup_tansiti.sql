/*
Ottimizzazione letture con Associative Array (Index-By)

Utilizzare un array associativo per vedere velocemente il luogo rappresentato da un codice (in questo caso il codice_magazzino),
dove passano le spedizioni in transito
*/
SET SERVEROUTPUT ON;

DECLARE 
    TYPE a_mag IS TABLE OF VARCHAR2(50) INDEX BY VARCHAR2(10);
    arr1 a_mag;
BEGIN
 
    FOR r IN (SELECT codice_magazzino, citta FROM magazzino) LOOP 
        arr1(r.codice_magazzino) := r.citta;
    END LOOP;
 
    FOR r IN (SELECT * FROM transito) LOOP
        -- Verifichiamo se la chiave esiste nell'array per evitare eccezioni NO_DATA_FOUND impreviste
        IF arr1.EXISTS(r.codice_magazzino) THEN
            DBMS_OUTPUT.PUT_LINE('La spedizione ' || r.codice_spedizione || 
                                 ' si trova nel deposito di ' || arr1(r.codice_magazzino));
        ELSE
            DBMS_OUTPUT.PUT_LINE('La spedizione ' || r.codice_spedizione || 
                                 ' si trova in un magazzino sconosciuto: ' || r.codice_magazzino);
        END IF;
    END LOOP;
END;
/
