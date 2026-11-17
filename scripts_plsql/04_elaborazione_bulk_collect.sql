/*
Caricamento massivo con BULK COLLECT ed eccezioni custom

Usare il più veloce BULK COLLECT al posto di un ciclo per inserire dati di una colonna di una tabella in una nested tables,
e filtrare i dati per poi inserirli in tabella temporanea.
*/

set serveroutput on;

DECLARE
    TYPE n_cod_sped IS TABLE OF spedizione.codice_spedizione%TYPE;
    n_cs n_cod_sped;
    cs_dispari exception;
    pragma exception_init(cs_dispari,-20015);
    cod_intero pls_integer;
    
BEGIN
    select codice_spedizione bulk collect into n_cs from spedizione where upper(stato_spedizione) not in ('CONSEGNATA');
    
    for r in 1..n_cs.count loop
        cod_intero:=n_cs(r);
        begin
			if mod (cod_intero, 2) = 0 then
				--insert into log_sped (id_sped, stato, descrizione) values (cod_intero, 'non consegnata',null);
				dbms_output.put_line('codice spedizione: '||cod_intero);
			else 
				raise_application_error(-20015,'errore dispari');
			end if;
			exception
				when cs_dispari then
				dbms_output.put_line('spedizione: '||cod_intero||', '||sqlerrm);
        end;
    end loop;

END;
/
