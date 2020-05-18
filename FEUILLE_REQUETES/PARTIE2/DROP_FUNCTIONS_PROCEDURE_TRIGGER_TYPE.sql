--  PROCEDURE
drop procedure agendasFusion;
drop procedure archiveActivite;
drop procedure archiveAgendas;
drop procedure archiveActivite;
-- FONCTIONS
drop function format_convert;
-- TRIGGERS
drop TRIGGER limiteAgenda;
drop TRIGGER archiver_Act;
drop TRIGGER archiver_ag;
drop trigger ck_nb_occur;
drop trigger interdire_simul;
drop trigger ev_control;

-- TYPES
drop type TabAgenda;