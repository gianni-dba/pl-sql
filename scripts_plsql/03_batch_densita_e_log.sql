/*
Gestione eccezioni nel ciclo (ZERO_DIVIDE) e logging su GTT

Scorrere, elaborare, e mettere i record filtrati in tab_temporanea senza interruzioni 
*/

set serveroutput on;

DECLARE
dens number(10,2);
s_volume pls_integer:=0;
v_esiste pls_integer;
BEGIN

FOR i in (select * from spedizione where data_consegna_effettiva is null) loop
    if i.volume < 0.05 then
        s_volume:=0;
    else 
        s_volume:=ceil(i.volume);
    end if;
    begin
        dens:=i.peso/s_volume;
        exception
            when zero_divide then
            dbms_output.put_line('errore nella spedizione '||i.codice_spedizione||', '||sqlerrm||', la densità viene riportata uguale al peso');
            dens:=i.peso;
    end;
    select count(*) into v_esiste from log_sped where i.codice_spedizione=log_sped.id_sped and log_sped.descrizione like ('%densità sped.: '||dens);
    if v_esiste<1 then
        insert into log_sped (id_sped, stato, descrizione) values (i.codice_spedizione, i.stato_spedizione, 'densità sped.: '||dens);
        dbms_output.put_line('inserito: '||i.codice_spedizione||', '||i.stato_spedizione||', '||dens);
    else
        dbms_output.put_line('log non inserito in quanto già presente');
    end if;
end loop;

END;
/
