/******************************
** File: PARTIE_DEUX.SQL
** Desc: Fichier contenant la deuxieme partie du projet (PLSQL et contraintes).
** Auth: KALUMVUATI Duramana et DE LAS HERAS MORENO Martin
** Date: 10/2019
*******************************/
/*-----------------------------------------------
                PARTIE 2 DU PROJET
------------------------------------------------*/

/*
  Procédures et fonctions PL/SQL
*/

-- 1)
/*
  Définir une fonction qui convertit au format csv (colonnes csv dans le même ordre que celles de la table) une activité d’un calendrier. Le résultat sera renvoyé sous la forme d’une chaîne de caractère
*/

SET SERVEROUTPUT ON

CREATE OR REPLACE FUNCTION format_convert(id_activite_p activites.idactivite%type) RETURN VARCHAR2 IS 
  activite_agenda_v varchar2(255);
   begin
  --spool export.csv;
  select (
    idactivite||','||
    titre||','||
    description||','||
    estPause||','||
    localisation||','||
    idType||','||
    dateDebut||','||
    dateFin||','||
    periodicite||','||
    idUtilisateur)
  into activite_agenda_v from activites where idactivite = id_activite_p;
  -- spool off;
    return activite_agenda_v;
end;
/


-- Test
spool export.csv;
SELECT format_convert(2) FROM DUAL;
spool off;

-- 2)
/*
  Définir une procédure qui permet de fusionner plusieurs agendas, 
  c’est à dire à partir de N agendas, créer un nouvel agenda. Ici
  on l'a implementé avec N = 5.
*/

-- Fusion de plusieurs agendas dans un tableau des agendas
create type TabAgenda as varray(5) of number;

-- Fusion avec un tableau de agendas en paramètre
create or REPLACE procedure agendasFusion(agendasIds TabAgenda) is
        id_agenda_v agendas.idagenda%type;
        compteur number;
        borne number;
        isPresent number:= 0;
    begin
        -- Chercher l'id Max pour créer un nouveau + 1
        select max(idAgenda) into id_agenda_v from agendas;

        -- incrementation de new agenda id
        id_agenda_v := id_agenda_v + 1;
        -- création d'un nouvel agenda
        insert into agendas values (id_agenda_v,'AgendaFusionnido '||id_agenda_v,sysdate,sysdate + 5,1,1);
        
        DBMS_OUTPUT.PUT_LINE('Voici id du nouvel Agenda : ' || id_agenda_v);
        -- liaison de l'agenda
        compteur := 1;
        borne := agendasIds.count;
          loop
             for idd in (select idactivite from activite_agenda where idagenda = agendasIds(compteur))
                  loop
                    select count(*) into ispresent from activite_agenda where idactivite = idd.idactivite and idagenda = id_agenda_v;
                    if ispresent = 0 then 
                        -- Debugger
                        -- DBMS_OUTPUT.PUT_LINE('Activite de : ' || idd.idactivite ||'Agenda : ' || id_agenda_v);
                        insert into activite_agenda values (idd.idactivite,id_agenda_v,1);
                    end if;
                  end loop;
                compteur := compteur + 1;
            exit when compteur > borne;
          end loop;
end;
/
-- Test
exec agendasFusion(TabAgenda(1,2));

--3) 
/*
  Définir une procédure qui crée une activité inférée à partir d’agendas existants. Comme par exemple reporter au week-end l’achat d’objets sortis aux cours de la semaine ou reporter au soir le visionnage d’une émission sortie au cours de la journée.
*/

create or replace procedure repoteActivite(agendaId_p agendas.idagenda%type, 
titre_p activites.titre%type, newDate_p Date) is
  idActivite_v activites.idactivite%type;
  begin 
  select a.idactivite into idActivite_v from activite_agenda g 
  inner join activites a on g.idactivite = a.idactivite
  where g.idagenda = agendaId_p and lower(a.titre) = lower(titre_p);

  if (SQL%NOTFOUND) THEN
    DBMS_OUTPUT.PUT_LINE('Aucune ligne trouvée');
  else
     update activites
        set datefin=newDate_p;
        DBMS_OUTPUT.PUT_LINE('Votre activité vient être reportée pour '|| newDate_p);
  end if;
end;
/

-- Test
exec repoteActivite(1,'Nager avec des potes',sysdate + 6);

select titre, datefin 
from activites  
where lower(titre)= lower('Nager avec des potes');

-- 4)
/*
  Définir une procédure qui archive les agendas dont toutes les dates sont passées.
*/
create or replace procedure archiveAgendas is
    -- ce cursor cherche les agendas dont la date de modification est passée
    compteur number;
    cursor agenda_cr is
        select * from agendas
        where (sysdate - datemodification) > 0;
    begin
        compteur :=0;
        -- Transfère des agendas de la table agendas à l'agendasArchives
        for activ in agenda_cr
        loop
            insert into agendasArchives 
            values (activ.idagenda, activ.nomagenda,activ.datecreation,activ.datemodification,activ.idutilisateur,activ.allowsimult);
            -- suppression des mêmes agendas après de les avoir déplacés
            --delete from agendas where idagenda = activ.idagenda;
            compteur := compteur + 1;
        end loop;
        DBMS_OUTPUT.PUT_LINE(compteur || ' Archivés.');
end;
/
-- Test
exec archiveAgendas;
select * from agendasArchives;

/*
  Contraintes d'intégrité du projet
*/

-- 1). 
/*
  Un agenda comportera au maximum 50 activités par semaine.
*/

CREATE OR REPLACE TRIGGER checkLimiteAgenda
  BEFORE INSERT ON activite_agenda
  FOR EACH ROW
  
    declare  
    nb_idAgenda_v INTEGER;
  BEGIN
    SELECT count(idoccurence) into nb_idAgenda_v FROM occurences 
    WHERE idActivite = :new.idactivite
    group by idactivite, TO_CHAR(dateoccurence, 'ww');
        
  IF nb_idAgenda_v >= 50 THEN
        RAISE_APPLICATION_ERROR(-20004, 'IMPOSSIBLE D AJOUTER UNE ACTIVITES DANS CET AGENDA, IL Y A DEJA PLUS DE 50 ACTIVITES!!!');
  END IF;
   
END;
/
SHOW ERRORS

-- 2) 
/*
  Les agendas et les activités supprimées seront archivés pour pouvoir être récupérés si nécessaire.
*/
-- Archiver une activité supprimée
CREATE OR REPLACE TRIGGER archiver_Act
    BEFORE DELETE
       ON activites
       FOR EACH ROW
    BEGIN

        insert into activitesArchivees (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
        values (:old.idActivite, :old.titre,:old.idType,:old.idUtilisateur,:old.dateDebut,:old.dateFin,:old.periodicite);
        DBMS_OUTPUT.PUT_LINE('Activité n° '|| :old.idActivite || ' Archivée');
END;
/
-- Test
delete from activites where idactivite = 2;
select * from activitesArchivees where idActivite = 2;

-- Archiver un agenda supprimé
CREATE OR REPLACE TRIGGER archiver_ag
  BEFORE DELETE
    ON agendas
    FOR EACH ROW

  BEGIN
    
    INSERT INTO agendasArchives
    ( idagenda, nomagenda,datecreation,datemodification,idutilisateur )
    VALUES
    (  :old.idagenda, :old.nomagenda,:old.datecreation,:old.datemodification,:old.idutilisateur );
        DBMS_OUTPUT.PUT_LINE('Agenda n° '|| :old.idagenda || ' Archivé');
  END;
/

delete from agendas WHERE idagenda = 1;
select * from agendasArchives where idagenda = 1;
SHOW ERRORS

-- 3) 
/*
  Le nombre d’activités présentes dans l’agenda et la périodicité indiquée pour l’activité correspondent strictement.
*/
CREATE OR REPLACE TRIGGER ck_nb_occur
    BEFORE INSERT ON activite_agenda
    FOR EACH ROW
    DECLARE
    nb_per_v INTEGER;
    nb_occur_v INTEGER;
    BEGIN
    SELECT COUNT(idOccurence) INTO nb_occur_v FROM activite_agenda NATURAL JOIN occurences WHERE idAgenda = :new.idAgenda;
    SELECT SUM(periodicite) INTO nb_per_v FROM activite_agenda NATURAL JOIN activites WHERE idAgenda = :new.idAgenda;
    IF nb_per_v != nb_occur_v
    THEN
        RAISE_APPLICATION_ERROR(-20004, 'Il n y a pas le meme nombre de occurences que de periodicite');
    END IF;
END;
/

SHOW ERRORS
-- 4) 
/*
  Pour les agendas où la simultanéité d’activité n’est pas autorisée, interdire que deux activités aient une intersection non nulle de leur créneau.
*/
CREATE OR REPLACE TRIGGER interdire_simul
  BEFORE INSERT ON activite_agenda
  FOR EACH ROW
  DECLARE
    rowdate_v DATE := NULL;
  BEGIN
    SELECT MAX(dateOccurence) INTO rowdate_v FROM (SELECT dateOccurence FROM activite_agenda NATURAL JOIN occurences WHERE idAgenda = :new.idAgenda)
                  NATURAL JOIN (SELECT dateOccurence FROM occurences WHERE idActivite = :new.idActivite);
    IF rowdate_v != NULL THEN
      RAISE_APPLICATION_ERROR(-20001, 'Il y a de simultanéité d activités, impossible d ajouter.');
    END IF;
END;
/

SELECT max(dateOccurence) FROM (SELECT dateOccurence FROM activite_agenda NATURAL JOIN occurences WHERE idAgenda = 2) INTERSECT
              (SELECT dateOccurence FROM occurences WHERE idActivite = 4);

-- activite, agenda et priorite
insert into activite_agenda values(4,2,3);

-- 5)
/*
 Afin de limiter le spam d'évaluation, un utilisateur enregistré depuis moins d'un semaine ne pourra écrire une évaluation que toutes les 5 minutes.
*/
CREATE OR REPLACE TRIGGER ev_control
  BEFORE INSERT ON evaluations
  FOR EACH ROW
  DECLARE
    date_diff_v INTEGER;
    date_ins_v DATE;
    date_ev_v DATE;
  begin
    SELECT max(dateEvaluation) INTO date_ev_v FROM evaluations WHERE idUtilisateur = :new.idUtilisateur;
    SELECT dateinscription INTO date_ins_v FROM utilisateurs WHERE idUtilisateur = :new.idUtilisateur;
    date_diff_v := SYSDATE - date_ins_v;
    IF date_diff_v < 7 THEN
      IF (sysdate - date_ev_v)*24*60 < 5 THEN
        RAISE_APPLICATION_ERROR(-20004, 'Vous devez attendre 5 minutes pour pouvoir faire une autre évaluation');
      END IF;
    END IF;
END;
/
SHOW ERRORS
