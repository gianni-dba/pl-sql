/*
procedura per controllo peso eccessivo, peso max passato come parametro
*/
 
CREATE OR REPLACE PROCEDURE controllo_peso (peso_max IN number) is 
    e_peso_eccessivo exception;
    PRAGMA EXCEPTION_INIT( e_peso_eccessivo, -20099); 
    cursor c is select codice_spedizione, peso from spedizione;
     v_cs spedizione.codice_spedizione%type;
     v_peso spedizione.peso%type;
 
BEGIN
    open c;
    dbms_output.put_line('identificazione anomalie peso nelle spedizioni: ');
    loop 
		fetch c into v_cs, v_peso;
		exit when c%notfound;
		BEGIN
			if (v_peso>peso_max) then
				raise_application_error(-20099, 'peso_eccessivo ' );
			end if;
			exception 
			when e_peso_eccessivo then
			dbms_output.put_line('la spedizione '||v_cs||' ha un peso eccessivo: '||v_peso||'kg , '||sqlerrm);
		END;
    end loop;
    close c; 
 END controllo_peso;
/

--richiamo procedure controllo peso
set serveroutput on;

DECLARE
BEGIN
  controllo_peso (10);
END;
