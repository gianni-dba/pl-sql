/*
Locking pessimistico (FOR UPDATE) e WHERE CURRENT OF

Imparare uso di for update, onde bloccare le righe interessate per modificarle nel database 
(in stato_spedizione 'IN LAVORAZIONE' --> 'PRONTO_PARTENZA'), 
e di where current of per recuperare al volo la posizione del cursore
*/

set serveroutput on;

DECLARE
    CURSOR c_Sped Is SELECT * FROM spedizione WHERE upper(stato_spedizione) not in ('CONSEGNATA') FOR UPDATE;
    v_sped_rec spedizione%ROWTYPE;
BEGIN
    open c_Sped;
    
    loop     
        fetch c_Sped into v_sped_rec;
        exit when c_Sped%notfound;
        if (v_sped_rec.peso is NOT null or v_sped_rec.peso>0) and upper(v_sped_rec.stato_spedizione) in ('PRESA_IN_CARICO') and (sysdate-v_sped_rec.data_consegna_prevista)>5 then
            v_sped_rec.stato_spedizione:=upper('pronto_partenza');
            BEGIN
            UPDATE spedizione SET ROW = v_sped_rec WHERE CURRENT OF c_Sped;
            dbms_output.put_line('spedizione: '||v_sped_rec.codice_spedizione||' aggiornata correttamente');
            exception
                when others then
                dbms_output.put_line('risultato tentativo aggiornamento spedizione '||v_sped_rec.codice_spedizione||'  '||sqlerrm||', ');
            END;
        end if;
        dbms_output.put_line(v_sped_rec.codice_spedizione||', '||v_sped_rec.stato_spedizione );
    end loop;
    close c_Sped;
    
    --commit;
END;
/
