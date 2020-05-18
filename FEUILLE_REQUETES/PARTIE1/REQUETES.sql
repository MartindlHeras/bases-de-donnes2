/*-----------------------------------------------------
                     REQUÊTES SQL
-------------------------------------------------------*/

-- 1) Nombre d'activites des agendas par catégories et par utilisateurs
select count(a.idActivite) NbActivite, a.idType as Categorie, g.idutilisateur utilisateur 
from activite_agenda aa
inner join activites a on a.idActivite = aa.idactivite
inner join agendas g on g.idAgenda = aa.idAgenda
group by a.idType, g.idutilisateur;

--g.idAgenda,

-- 2) Nombre d'évaluations totales pour les utilisateurs actifs: ayant édité un
-- agenda au cours des trois mois  environ 90 jours par rapport à la date courante
select e.idUtilisateur,count(e.note) NbTotal--,AVG(e.note) MOYENNE
from evaluations e inner join agendas a on a.idUtilisateur = e.idutilisateur
where (sysdate - a.dateModification) <= 90
group by e.idutilisateur order by idutilisateur;


-- 3) Les agendas ayant eu au moins cinq évaluations et dont la note moyenne 
-- est inférieure à trois.
select idagenda
from evaluations
where idagenda in
(select e.idagenda from evaluations e
group by e.idagenda having count(e.idutilisateur) > 4)
group by idagenda having avg(note) < 3;


-- 4) L'agenda ayant le plus nombre d'activités en moyenne par semaine
select idagenda,max(to_char(datemodification , 'ww') - to_char(datecreation, 'ww')) as week
from agendas group by to_char(datemodification , 'ww') - to_char(datecreation, 'ww'),idagenda
having max(to_char(datemodification , 'ww') - to_char(datecreation, 'ww')) =
(select max(to_char(datemodification , 'ww') - to_char(datecreation, 'ww')) from agendas );


-- 5) 
/*
    Pour chaque utilisateur, son login, son nom, son prénom, son adresse, son   nombre d'agendas, son nombre d'activités et son nombre d'évaluation.
*/
select distinct u.login,u.nom,u.prenom,u.adresse, count(a.idagenda) NbAgenda, ac.nbActivite, e.nbEvaluation
from agendas a
left join (select idagenda, count(idutilisateur) nbEvaluation
from evaluations group by idagenda) e
on a.idagenda = e.idagenda
left join (select idagenda , count(idactivite) nbActivite
from activite_agenda group by idagenda) ac
on a.idagenda = ac.idagenda
inner join utilisateurs u on a.idutilisateur = u.idutilisateur
group by a.idutilisateur,u.login,u.nom,u.prenom,u.adresse, ac.nbActivite, e.nbEvaluation;


-------------------------------- FIN PREMIERE PARTIE-----------------------------------
