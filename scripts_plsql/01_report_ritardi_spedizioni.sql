/*
Cursori, record custom e sotto-blocchi BEGIN-END

Report Spedizioni in Memoria (Nested Table + Sotto-blocchi)

Report delle spedizioni che calcola la tempistica delle consegne delle spedizioni, 
proteggendo con sottoblocchi lo scorrimento dei dati da eventuali errori.
*/

SET SERVEROUTPUT ON;

DECLARE
    r_tot_sped spedizione%ROWTYPE;
    
    TYPE record_sped IS RECORD ( 
        ID_Spedizione   spedizione.codice_spedizione%TYPE,
        stato_originale spedizione.stato_spedizione%TYPE,
        nota_consegna   VARCHAR2(200) 
    );
    
    TYPE tab_sped IS TABLE OF record_sped;
    
    t_sped tab_sped := tab_sped();
    
    CURSOR c IS SELECT * FROM spedizione;
    i pls_integer := 1;
    differenza pls_integer;
    tempistica VARCHAR2(50);
BEGIN
    OPEN c;
    LOOP 
        FETCH c INTO r_tot_sped;
        EXIT WHEN c%NOTFOUND;
        
        t_sped.EXTEND;
        t_sped(i).ID_spedizione   := r_tot_sped.codice_spedizione;
        t_sped(i).stato_originale := r_tot_sped.stato_spedizione;
        
        BEGIN
            IF r_tot_sped.stato_spedizione IS NOT NULL 
               AND r_tot_sped.stato_spedizione = 'CONSEGNATA' 
               AND r_tot_sped.data_consegna_effettiva IS NOT NULL 
            THEN
                differenza := r_tot_sped.data_consegna_effettiva - r_tot_sped.data_consegna_prevista;
                
                CASE 
                    WHEN differenza <= -2 THEN
                        tempistica := 'in anticipo di ' || TO_CHAR(ABS(differenza)) || ' giorni';
                    WHEN differenza = -1 THEN
                        tempistica := 'in anticipo di un giorno';
                    WHEN differenza >= 2 THEN
                        tempistica := 'in ritardo di ' || TO_CHAR(differenza) || ' giorni';
                    WHEN differenza = 1 THEN
                        tempistica := 'in ritardo di un giorno';
                    ELSE
                        tempistica := 'puntuale';
                END CASE;
                
                t_sped(i).nota_consegna := 'consegnata ' || tempistica;
            ELSE
                t_sped(i).nota_consegna := 'In attesa di consegna o stato non verificabile';
            END IF;
            
        EXCEPTION
            WHEN OTHERS THEN
				        --se c'è errore riporta in nota e passa al successivo
                t_sped(i).nota_consegna := 'ERRORE ELABORAZIONE VALORI: ' || SQLERRM;
        END;
        
        i := i + 1;
    END LOOP;
    CLOSE c;
    
    FOR j IN 1..t_sped.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Spedizione ' || t_sped(j).ID_Spedizione || 
                             ' - Stato: ' || t_sped(j).stato_originale || 
                             ' | Note: ' || t_sped(j).nota_consegna);
    END LOOP;
END;
/
