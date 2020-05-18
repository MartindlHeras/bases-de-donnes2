/******************************
** File: DROP_TABLES.SQL
** Desc: Fichier contenant les suppressions de tables.
** Auth: KALUMVUATI Duramana et DE LAS HERAS MORENO Martin
** Date: 10/2019
*******************************/

-- SUPPRESSION DE TABLES

delete from evaluations;
delete from activitesArchivees;
delete from agendasArchives;
delete from occurences;
delete from activ_agenda;
delete from inscription_util_agenda;
delete from inscription_util_act;
delete from activites;
delete from types;
delete from agendas;
delete from utilisateurs;

-- SUPPRIMER LES CONTENUS
drop table evaluations;
drop table activitesarchivees;
drop table agendasArchives;
drop table occurences;
drop table activite_agenda;
drop table inscrip_util_agenda;
drop table inscrip_util_act;
drop table activites;
drop table types;
drop table agendas;
drop table utilisateurs;
drop sequence SeqOccurence;

