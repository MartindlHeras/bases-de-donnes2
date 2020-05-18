### RAPORT DU PROJET : BASE DE DONNEES POUR UN SITE WEB

-------------
Ce projet a été réalisé par :
* KALUMVUATI Duramana
* DE LAS HERAS MORENO Martin

-------------
##### Objectif :

<p style='text-align: justify;'> 
Mise en place une base de données pour un site internet permettant aux utilisateurs du site internet de créer des agendas contenant des activités.

Après les utilisateurs pourront partager les activités de leurs agendas. voir aussi celles des autres utilisateurs et de s'inscrire. Et finalement ils pourront évaluer des agendas (à une note comprise entre 1 à 5). </p>


### Méthodologie :

<p style='text-align: justify;'> 
Chassant que cette base de données sera utilisée pour un site web, on en deduit que certains traitements des informations seront faits par celui qui va utiliser la base de données mais, on a voulu aussi faire le maximum de traitement possible pour réduire le travail de celui qui s'occupéra de Back-End.
</p>

### Entités :

<p style='text-align: justify;'> 
Selon les demandes du dévéloppeur Back-End, on a résolu de mettre en place ces entités, capables à répondre aux bésoins cités dans l'énoncé. </p>

**Table de rélation entre agenda et ses activités**

>ACTIV_AGENDA (__#idActivite__, __#idAgenda__, priorite);

<p style='text-align: justify;'> 
Cette table permettra aux utilisateurs de pouvoir créer plusieurs activites et de fusionner les activités des agendas par exemple à un seul agenda.</p>


**Table des activités**


>ACTIVITES (__#idActivite__, titre, description,localisation,estPause, #idType, #idUtilisateur);

<p style='text-align: justify;'> 

>ACTIVITESARCHIVEES (__#idActivite__, titre, description,localisation,estPause, #idType,datedebut,datefin,periodicite, #idUtilisateur );

- *activitesarchivees :* 
Au début, on voulait créer une colonne sur la table activités, pour que chaque fois une activité supprimée, reste sur la même table et juste son état qui change. Nous avons eu quelques problèmes lors de mise en place de trigger qui devait remplir cette tâche. Donc, on a pris la décision, la mise en place de cette table. En effet, ça nous a aidé à faire quelques recherches. Donc, pas de regret, car ça nous a permis d'utiliser d'autre méthode qu'on ne connaissait pas avant. 

- *estPause :* Pour cette colonne, toute activité qui se trouve en pause, ne doit pas être prise en compte et ni permettre les inscriptions sur cette dernière.</p>


**Table des agendas**

>AGENDAS (__#idAgenda__, nomAgenda, estArchive, dateCreation, dateModification, #idUtilisateur,allowsimult);

>AGENDASARCHIVES (__#idAgenda__, nomAgenda, estArchive, dateCreation, dateModification, #idUtilisateur,allowsimult);

<p style='text-align: justify;'> 
Cette table permet de créer des agendas contenant le nom, la date de création, la date de la dernière modification, et l'id de l'utilisateur qui l'a créé.

- *allowsimult :* 
Colonne très importante lors qu'il faudra interdire la simultanéité de date de certaines activités.
</p>


**Table des evaluations**

>EVALUATIONS (__#idAgenda__, __#idUtilisateur__, note,dateevaluation);

Cette table permet aux utilisateurs de noter les agendas, et on souhait aussi garder la date d'évaluation.
Pour pouvoir interdir à certain utilisateur d'évaluer un agenda. Pour le respect du besoin.

**Table de rélation entre utilisateur et activité**

>INSCRIPTION_UTIL_ACT(__#idUtilisateur__, __#idActivite__);

<p style='text-align: justify;'> 
Cette table permet de voir quel utilisateur est inscrit dans quelle activité (si un utilisateur est inscrit dans un agenda).</p>

**Table de rélation entre utilisateurs et agendas**

>INSCRIPTION_UTIL_AGENDA (__#idAgenda__, __#idUtilisateur__, estAbonne);

<p style='text-align: justify;'> 
Cette table permet de voir les utilisateurs qui sont inscrits dans chaque agenda, et aussi avec *estAbonne* on peut savoir si l'utilisateur est abonné dans cet agenda, par défaut est mis à 0 (pas inscrit).</p>

**Table des occurences**

>OCCURENCES (__#idOccurence__, #idActivite, dateoccurence);

<p style='text-align: justify;'> 
Elle permet de voir toutes les occurences des activités (car les activités peuvent avoir une periodicité et apparaître plusieurs fois).
Elle est remplie automatiquement lors d'insertion d'une activité, enfin de garder la cohérence des activités et leurs périodicités.
</p>

**Table des types**

>TYPES (__#idType__, type);

Table des catégories de activités.

**Table des utilisateurs**

>UTILISATEURS (__#idUtilisateur__, login, motdepass, nom, prenom, adresse,dateInscription,status);

Cette table permet de voir tous les utilisateurs. Et la colonne "status" nous permet
de savoir si l'utilisateur est juste un utilisateur simple ou administrateur, enfin de
lui permettre à modifier certaines activités ou agendas.


![image AE](./IMAGES/schema_ea.png)


### Contraintes:

<p style='text-align: justify;'> 
Cette contrainte vérifie sur la table *evaluations* que la note donnée par l'utilisateur est entre 1 et 5.</p>

```sql
ALTER TABLE evaluations ADD
    CONSTRAINT evaluations_ck CHECK (note between 1 and 5);
```

Cette contrainte vérifie l'unicité d'un login.

```sql
ALTER TABLE utilisateurs ADD CONSTRAINT utilisateurs_u UNIQUE ( login );
```

Cette contrainte référencie la colonne *idType* dans la table *activites*.

```sql
ALTER TABLE activites
    ADD CONSTRAINT activites_types_fk FOREIGN KEY ( idtype )
        REFERENCES types ( idtype ) ON DELETE CASCADE;

ALTER TABLE activites ADD CONSTRAINT activites_titre_u UNIQUE ( titre );

ALTER TABLE activites
    ADD CONSTRAINT activites_util_fk FOREIGN KEY ( idUtilisateur )
        REFERENCES utilisateurs ( idUtilisateur ) ON DELETE CASCADE;
```

<p style='text-align: justify;'> 
Elle permet qu'une activité appartienne à plusieurs agendas, et un agendas aie plusieurs activités</p>

```sql
ALTER TABLE activite_agenda
    ADD CONSTRAINT activite_agenda_act_fk FOREIGN KEY ( idactivite )
        REFERENCES activites ( idactivite ) ON DELETE CASCADE;

ALTER TABLE activite_agenda
    ADD CONSTRAINT activite_agenda_ag_fk FOREIGN KEY ( idagenda )
        REFERENCES agendas ( idagenda ) ON DELETE CASCADE;
```

<p style='text-align: justify;'> 
Cette contrainte référencie la colonne *idUtilisateur* de la table *agendas* à la même dans la table *utilisateurs*.</p>

```sql
ALTER TABLE agendas ADD CONSTRAINT agendas_nomagenda_u UNIQUE ( nomagenda );
ALTER TABLE agendas ADD CONSTRAINT agendas_ck CHECK (allowSimult BETWEEN 0 AND 1);

ALTER TABLE agendas
    ADD CONSTRAINT agendas_util_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;
```

<p style='text-align: justify;'> 
Un utilisateur peut évaluer un ou plusieurs agendas.</p>

```sql
ALTER TABLE evaluations
    ADD CONSTRAINT evaluations_agendas_fk FOREIGN KEY ( idagenda )
        REFERENCES agendas ( idagenda ) ON DELETE CASCADE;

ALTER TABLE evaluations
    ADD CONSTRAINT evaluations_utilisateurs_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;
```

<p style='text-align: justify;'> 
Cette contrainte réfferencie une activité dans la table occurences</p>

```sql
ALTER TABLE occurences
    ADD CONSTRAINT occurences_activites_fk FOREIGN KEY ( idactivite )
        REFERENCES activites ( idactivite ) ON DELETE CASCADE;
```

<p style='text-align: justify;'> 
Un utilisateur peut s'inscrire à plusieurs activités</p>

```sql
ALTER TABLE inscrip_util_act
    ADD CONSTRAINT inscrip_util_act_act_fk FOREIGN KEY ( idactivite )
        REFERENCES activites ( idactivite ) ON DELETE CASCADE;

ALTER TABLE inscrip_util_act
    ADD CONSTRAINT inscrip_util_act_util_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;
```

<p style='text-align: justify;'> 
Elles permettent à un utilisateur de s'inscrire à plusieurs agendas</p>

```sql

ALTER TABLE inscrip_util_agenda
    ADD CONSTRAINT inscrip_util_agenda_ag_fk FOREIGN KEY ( idagenda )
        REFERENCES agendas ( idagenda ) ON DELETE CASCADE;

ALTER TABLE inscrip_util_agenda
    ADD CONSTRAINT inscrip_util_agenda_util_fk FOREIGN KEY ( idutilisateur )
        REFERENCES utilisateurs ( idutilisateur ) ON DELETE CASCADE;
```

    -- Mise en place la séquence, pour tester l'occurence
```
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
```
![image Rélationnel](./IMAGES/schema_relationnel.png)

