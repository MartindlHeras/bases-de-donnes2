/*****************************
** File: CREATE TABLES.SQL
** Desc: script de création de tables et 
** les contraintes nécessaires.
** Auth: KALUMVUATI Duramana et DE LAS HERAS MORENO Martin
** Date: 10/2019
*******************************/

--	CREATION DE TABLES


-- Création de table "activite_agenda". Table qui fait la liaison entre l'agenda et
-- ses activités.
CREATE TABLE activite_agenda (
    idactivite   NUMBER NOT NULL,
    idagenda     NUMBER NOT NULL,
    priorite     NUMBER DEFAULT 0
);

ALTER TABLE activite_agenda ADD CONSTRAINT activite_agenda_pk PRIMARY KEY ( idactivite, idagenda );

-- Création de table "activitesArchivees
-- elle permet de faire le transfère des activitées supprimées
-- pour enfin de les récupérer

CREATE TABLE activitesarchivees (
    idactivite      NUMBER NOT NULL,
    titre           VARCHAR2(100),
    description     VARCHAR2(500),
    estpause        CHAR(1),
    localisation    VARCHAR2(250),
    idtype          NUMBER NOT NULL,
    datedebut       DATE NOT NULL,
    datefin         DATE NOT NULL,
    periodicite     NUMBER NOT NULL,
    idutilisateur   NUMBER NOT NULL
);

ALTER TABLE activitesarchivees ADD CONSTRAINT activitesarc_pk PRIMARY KEY ( idactivite );

-- Création de table "activites". Table des activités.
-- estArchivée : permet à qualifier l'état d'une activité (archivée ou pas). Mis
-- en place pour éviter d'avoir la copie de la table "activite"s pour y mettre
-- les activités archivées.
CREATE TABLE activites (
    idactivite     NUMBER NOT NULL,
    titre          VARCHAR2(100),
    description    VARCHAR2(500),
    estpause       CHAR(1) DEFAULT '0',
    localisation   VARCHAR2(250),
    idtype         NUMBER NOT NULL,
    datedebut      DATE NOT NULL,
    datefin        DATE NOT NULL,
    periodicite    NUMBER NOT NULL,
    idutilisateur   NUMBER NOT NULL
);

ALTER TABLE activites 
    ADD CONSTRAINT activites_pk PRIMARY KEY ( idactivite );
ALTER TABLE activites ADD CONSTRAINT activites_titre_u UNIQUE ( titre );

-- Mise en place la table agendasArchives
-- vu la nécessité de vouloir récuperer les agendas
-- qui furent supprimés
CREATE TABLE agendasArchives (
    idAgenda           NUMBER NOT NULL,
    nomAgenda          VARCHAR2(100),
    dateCreation       DATE DEFAULT SYSDATE,
    dateModification   DATE DEFAULT SYSDATE,
    idUtilisateur      NUMBER NOT NULL,
    allowSimult        CHAR(1) DEFAULT '0'
);

-- Création de table "agendas". Table des agendas, créée par un certain utilisateur.
-- la colonne "estArchive" idem que celle de l'activité

CREATE TABLE agendas (
    idagenda           NUMBER NOT NULL,
    nomagenda          VARCHAR2(100),
    datecreation       DATE DEFAULT SYSDATE,
    datemodification   DATE DEFAULT SYSDATE,
    idutilisateur      NUMBER NOT NULL,
    allowsimult        CHAR(1) DEFAULT '0'
);

ALTER TABLE agendas ADD CONSTRAINT agendas_pk PRIMARY KEY ( idagenda );
ALTER TABLE agendas ADD CONSTRAINT agendas_nomagenda_u UNIQUE ( nomagenda );
ALTER TABLE agendas ADD CONSTRAINT agendas_ck CHECK (allowSimult BETWEEN 0 AND 1);
-- Création de table "evaluations". Table qui permet à garder les évaluations
-- des agendas et l'utilisateur qui l'évalue.
CREATE TABLE evaluations (
    idutilisateur    NUMBER NOT NULL,
    idagenda         NUMBER NOT NULL,
    note             NUMBER(1) NOT NULL,
    dateevaluation   DATE DEFAULT SYSDATE
);

ALTER TABLE evaluations ADD 
CONSTRAINT evaluations_pk PRIMARY KEY ( idutilisateur,idagenda );

ALTER TABLE evaluations ADD
CONSTRAINT evaluations_ck CHECK (note between 1 and 5);

-- Création de table "inscrip_util_act". Table qui fait la liaison entre
-- l'utilisateur et les activités dans lesquelles il est inscrit.
CREATE TABLE inscrip_util_act (
    idutilisateur   NUMBER NOT NULL,
    idactivite      NUMBER NOT NULL
);

ALTER TABLE inscrip_util_act ADD 
CONSTRAINT inscrip_util_act_pk PRIMARY KEY ( idutilisateur,idactivite );


-- Création de table "inscrip_util_agenda". Table qui fait la liaison entre
-- l'utilisateur et les agendas  dans les quels il est inscrit.
CREATE TABLE inscrip_util_agenda (
    idutilisateur   NUMBER NOT NULL,
    idagenda        NUMBER NOT NULL,
    estabonne       CHAR(1) default '0'
);

ALTER TABLE inscrip_util_agenda ADD 
CONSTRAINT inscrip_util_ag_pk PRIMARY KEY ( idutilisateur, idagenda );

-- Création de table "occurences". Table qui permet à garder les occurences des
-- activités.
CREATE TABLE occurences (
    idoccurence     NUMBER NOT NULL,
    idactivite      NUMBER NOT NULL,
    dateoccurence   DATE NOT NULL
);

ALTER TABLE occurences ADD CONSTRAINT occurences_pk PRIMARY KEY ( idOccurence );

-- Création de table "types". Table qui permet à garder les types/catégories des
-- activités.
CREATE TABLE types (
    idType   NUMBER NOT NULL,
    type     VARCHAR2(100)
);

ALTER TABLE types ADD CONSTRAINT types_pk PRIMARY KEY ( idType );


-- Création de table "utlisateurs". Table qui permet à garder les utilisateurs
-- et ses données. Présence de status ; pour determiner si un user peut modifier
-- ou pas un agenda
CREATE TABLE utilisateurs (
    idUtilisateur   NUMBER NOT NULL,
    login           VARCHAR2(150) NOT NULL,
    motdepass       VARCHAR2(255) NOT NULL,
    nom             VARCHAR2(150),
    prenom          VARCHAR2(150),
    adresse         VARCHAR2(255),
    dateInscription DATE DEFAULT SYSDATE,
    status          CHAR(1) DEFAULT '0' 
);

ALTER TABLE utilisateurs ADD CONSTRAINT utilisateurs_pk PRIMARY KEY ( idUtilisateur );
ALTER TABLE utilisateurs ADD CONSTRAINT utilisateurs_u UNIQUE ( login );

/*----------------------------------------------------------------------------
                                CONTRAINTES
-----------------------------------------------------------------------------*/
ALTER TABLE activite_agenda
    ADD CONSTRAINT activite_agenda_act_fk FOREIGN KEY ( idactivite )
        REFERENCES activites ( idactivite ) ON DELETE CASCADE;

ALTER TABLE activite_agenda
    ADD CONSTRAINT activite_agenda_ag_fk FOREIGN KEY ( idagenda )
        REFERENCES agendas ( idagenda ) ON DELETE CASCADE;

ALTER TABLE activites
    ADD CONSTRAINT activites_types_fk FOREIGN KEY ( idtype )
        REFERENCES types ( idtype ) ON DELETE CASCADE;

ALTER TABLE agendas
    ADD CONSTRAINT agendas_util_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;

ALTER TABLE evaluations
    ADD CONSTRAINT evaluations_agendas_fk FOREIGN KEY ( idagenda )
        REFERENCES agendas ( idagenda ) ON DELETE CASCADE;

ALTER TABLE evaluations
    ADD CONSTRAINT evaluations_utilisateurs_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;

ALTER TABLE inscrip_util_act
    ADD CONSTRAINT inscrip_util_act_act_fk FOREIGN KEY ( idactivite )
        REFERENCES activites ( idactivite ) ON DELETE CASCADE;

ALTER TABLE inscrip_util_act
    ADD CONSTRAINT inscrip_util_act_util_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;

ALTER TABLE inscrip_util_agenda
    ADD CONSTRAINT inscrip_util_agenda_ag_fk FOREIGN KEY ( idagenda )
        REFERENCES agendas ( idagenda ) ON DELETE CASCADE;

ALTER TABLE inscrip_util_agenda
    ADD CONSTRAINT inscrip_util_agenda_util_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;

ALTER TABLE occurences
    ADD CONSTRAINT occurences_activites_fk FOREIGN KEY ( idactivite )
        REFERENCES activites ( idactivite ) ON DELETE CASCADE;


-- Mise en place la séquence, pour tester l'occurence
CREATE SEQUENCE SeqOccurence
  START WITH 1
  INCREMENT BY 1
  CACHE 100 ;

SET SERVEROUTPUT ON

/*
    -- Trigger qui assure la cohérence entre les activités et le nombre d'occurences
*/
CREATE OR REPLACE TRIGGER testActiviteOccurence
AFTER INSERT ON activites
FOR EACH ROW
DECLARE
  compteur_v INTEGER := 1;
BEGIN
  LOOP
      INSERT INTO occurences VALUES(SeqOccurence.nextval, :new.idactivite, sysdate);
      EXIT WHEN compteur_v >= :new.periodicite;
      compteur_v := compteur_v + 1;
  END LOOP;
  DBMS_OUTPUT.put_line('INSERTION DES ACTIVITES AVEC SUCCES, VEILLEZ MODIFIER LES DATES DES OCCURENCES');
END;
/

/*
    Contrainte qui vérifie bien qu'un utilisateur peut que s'inscrire sur une activité qui n'est pas en pause.
*/
CREATE OR REPLACE TRIGGER estPause
BEFORE INSERT ON inscrip_util_act
FOR EACH ROW
DECLARE
  isPause activites.estpause%type;
BEGIN
    SELECT estpause INTO isPause from activites where idactivite = :new.idactivite;
    IF isPause = '1' THEN
        RAISE_APPLICATION_ERROR(-20004, 'CETTE ACTIVITE EST INDISPONIBLE POUR L INSTANT, ESSAYEZ PLUS TARD.');
    END IF;
END;
/

