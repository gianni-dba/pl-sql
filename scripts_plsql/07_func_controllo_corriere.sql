/*
funzione per controllare stato corriere (id passato come parametro),
e test seguente
*/

CREATE or REPLACE FUNCTION controllo_corriere (cod_corriere in number) RETURN VARCHAR2 IS
v_disponibile char(1);
v_numero number;

BEGIN
	select count(codice_corriere) into v_numero from corriere where codice_corriere=cod_corriere;
	if  v_numero>=1 then
		select attivo into v_disponibile from corriere where codice_corriere = cod_corriere;
		if v_disponibile = 'S' then
			return 'disponibile';
			elsif v_disponibile='N' then
			return 'non attivo';
		end if;
	else
		raise no_data_found;
	end if;

	exception
	  when no_data_found then
		return 'non esistente, errore '||sqlerrm;
END controllo_corriere;
/
set serveroutput on;

DECLARE
begin 
  dbms_output.put_line('corriere '||controllo_corriere(1) );
  dbms_output.put_line('corriere '||controllo_corriere(3) );
  dbms_output.put_line('corriere '||controllo_corriere(6) );
end;
