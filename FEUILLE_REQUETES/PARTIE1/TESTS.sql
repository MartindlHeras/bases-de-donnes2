/******************************
** File: TESTS.SQL
** Desc: Fichier contenant les insertions de tables et les requêtes SQL.
** Auth: KALUMVUATI Duramana et DE LAS HERAS MORENO Martin
** Date: 10/2019
*******************************/

-- INSERTION DE TABLES

-- VALUES
insert into types values(1,'ludique');
insert into types values(2,'aquatique');
insert into types values(3,'accompagnement');
insert into types values(4,'sociale');
insert into types values(5,'romanesque');
insert into types values(6,'cinema');
insert into types values(7,'nature');

-- UTILISATEURS
insert into utilisateurs values (1,'admin','admin','toto','moi','chez-moi',sysdate,'0');
insert into utilisateurs values (2,'jojo','admin','toto','rien','chez-moi',sysdate,'1');
insert into utilisateurs values (3,'rien','admin','toto','moi','moi',sysdate,'0');
insert into utilisateurs values (4,'toi','admin','toto','pas moi','chez-lui',sysdate,'1');
insert into utilisateurs values (5,'user','admin','toto','moi','chez-moi',sysdate,'0');
insert into utilisateurs values (6,'administrateur','admin','toto','moi','chez-moi',sysdate,'1');
insert into utilisateurs values (7,'tutu','admin','toto','moi','chez-moi',sysdate,'1');
insert into utilisateurs values (8,'eux','admin','toto','moi','chez-moi',sysdate,'1');
insert into utilisateurs values (9,'nous','admin','toto','moi','chez-moi',sysdate,'1');
insert into utilisateurs values (10,'tous','admin','toto','moi','chez-moi',sysdate,'0');

/*
    Pour le respect de conhérence, il faut d'abord 
*/
-- ACTIVITES
insert into activites (idActivite,titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (1,'Nager avec des potes',2,3,sysdate,sysdate + 5,5);

insert into activites (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (2,'Nager avec des potes1',1,2,sysdate,sysdate + 10,10);

insert into activites (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (3,'Biodiversites',5,4,sysdate,sysdate + 20,5);

insert into activites (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (4,'La cuisine avec les prof',4,5,sysdate,sysdate + 15,3);

insert into activites (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (5,'Passer son permis en public',3,3,sysdate,sysdate + 20,5);

insert into activites (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (6,'Trouvons les tresors cachés de Louis XIV',1,3,sysdate,sysdate + 20,5);

insert into activites (idActivite, titre,idType,idUtilisateur,dateDebut,dateFin,periodicite)
values (7,'Essayer le declencheur',1,3,sysdate,sysdate + 20,10);

-- AGENDAS
insert into agendas values(1,'Cinema++',sysdate,sysdate + 4, 2,0);
insert into agendas values(2,'Bonjour mes voisins',sysdate,sysdate + 30, 1,1);
insert into agendas values(3,'entre les potes',sysdate,sysdate + 10, 2,0);
insert into agendas values(4,'Choisir de la semaines',sysdate,sysdate + 5, 2,0);
insert into agendas values(5,'Travailler dans la nature',sysdate,sysdate, 1,0);
insert into agendas values(6,'Coder comme jamais',sysdate,sysdate + 5, 3,1);
insert into agendas values(7,'Parlons de C++',sysdate,sysdate + 20, 5,1);
insert into agendas values(8,'Parlons de JAVA',sysdate,sysdate + 20, 10,0);
insert into agendas values(9,'Travailler la motri..',sysdate,sysdate + 20, 8,0);
insert into agendas values(10,'cultivation bio',sysdate,sysdate + 20, 5,0);
insert into agendas values(11,'Parlons de C++ bis',sysdate,sysdate + 20, 4,0);
insert into agendas values(12,'Piscine dans eaux',sysdate,sysdate + 20, 2,1);
insert into agendas values(13,'Que de jeunes',sysdate,sysdate + 20, 5,0);

-- ACTIVITE AGENDA
-- activite, agenda et priorite
insert into activite_agenda values(1,2,3);
insert into activite_agenda values(2,1,1);
insert into activite_agenda values(3,2,5);
insert into activite_agenda values(4,3,1);
insert into activite_agenda values(5,5,2);
insert into activite_agenda values(6,4,4);
insert into activite_agenda values(1,1,3);
insert into activite_agenda values(2,2,1);
insert into activite_agenda values(3,3,3);
insert into activite_agenda values(4,7,3);
insert into activite_agenda values(5,4,2);
insert into activite_agenda values(6,8,4);
insert into activite_agenda values(1,7,3);
insert into activite_agenda values(6,6,1);
insert into activite_agenda values(6,2,2);
insert into activite_agenda values(4,6,5);
insert into activite_agenda values(5,1,2);
insert into activite_agenda values(4,5,4);
insert into activite_agenda values(5,2,4);

-- EVALUATIONS
-- agenda, utilisateur et note entre [1,5]
insert into evaluations values (1,2,3,sysdate);
insert into evaluations values (1,1,5,sysdate);
insert into evaluations values (3,2,4,sysdate);
insert into evaluations values (1,3,4,sysdate);
insert into evaluations values (4,5,1,sysdate);
insert into evaluations values (5,1,2,sysdate);
insert into evaluations values (1,4,4,sysdate);
insert into evaluations values (2,3,4,sysdate);
insert into evaluations values (3,3,4,sysdate);
insert into evaluations values (4,6,4,sysdate);
insert into evaluations values (4,2,4,sysdate);
insert into evaluations values (1,6,4,sysdate);
insert into evaluations values (4,3,4,sysdate);

-- INSCRIPTION UTILISATEUR ACTIVITES
-- utilisateur et activite
insert into inscrip_util_act values (1,1);
insert into inscrip_util_act values (1,2);
insert into inscrip_util_act values (2,3);
insert into inscrip_util_act values (4,5);
insert into inscrip_util_act values (1,4);
insert into inscrip_util_act values (4,2);
insert into inscrip_util_act values (3,3);

-- INSCRIPTION UTILISATEUR AGENDA
-- utlisateur, agenda estabonné(0 : non et 1 : oui)
insert into inscrip_util_agenda values (1,2,0);
insert into inscrip_util_agenda values (2,3,0);
insert into inscrip_util_agenda values (3,2,0);
insert into inscrip_util_agenda values (4,2,1);
insert into inscrip_util_agenda values (5,2,0);
insert into inscrip_util_agenda values (1,4,1);

-- NOMBRE D'OCCURENCES D'UNEACTIVITE ET SES DATES
-- idoccurence, activite, dateDebut, dateFin et periodicite
-- NB : cette partie après avoir lancé les triggers qui vérifie la
-- conhérence des activités insérées, ne sera plus nécessaire. Elle sera faite automatique.
insert into occurences values (1,1,sysdate, sysdate + 4,1);
insert into occurences values (2,2,sysdate, sysdate + 4,1);
insert into occurences values (3,5,sysdate, sysdate + 10,1);
insert into occurences values (4,4,sysdate, sysdate ,1);
insert into occurences values (5,6,sysdate, sysdate + 20,1);
insert into occurences values (6,3,sysdate, sysdate + 1 ,7);



