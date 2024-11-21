## Raflette, la plateforme pour tout rafler.

(Oui, c'est un mauvais mot-valise entre rafler et raclette, et j'assume. C'est pas tous les jours qu'on peut inventer des noms de startup pourris)

Tout d'abord, vous allez probablement noter que certains de mes choix sont basés sur de possibles évolutions futures du produit. Je suis conscient de la limite de l'exercice et j'essaie au maximum de ne pas compliquer un système en me basant sur des hypothèses (YAGNI). Cela-dit, parfois, ça me semble utile de préparer un peu le terrain en laissant la porte ouverte à des évolutions, en adoptant une architecture et des pratiques qui me laissent de la flexibilité.

J'ai pris comme première décision d'architecture de ne pas mentionner de patates dans le domain model. Je pars du principe que si on fait du trading avec des patates, rien ne nous empêche à l'avenir d'en faire avec d'autres investissements en puissance, comme les oignons, le morbier, ou l'abondance.

J'ai donc pris le parti de nommer le modèle `MarketPrice`, ce qui permettra de spécialiser ultérieurement si le besoin s'en fait sentir. 
Je valide le modèle de données en m'assurant que les timestamps soient uniques et que chaque champs soit dûment rempli. 

## Afficher le cours 

Etant donné que je souhaite renvoyer une  liste de prix, j'ai opté pour un contrôleur `market_prices` avec une action index. Ces endpoints finissent très souvent par devenir une machine à filtres.

Je pars du principe que les développeurs front auront très probablement envie d'ajouter de nouveaux widgets basés sur la liste des prix et qu'ils pourront à l'avenir utiliser ce endpoint à cette fin en filtrant comme bon leur semble.

Pour faciliter le travail de cette équipe, je valide les paramètres de date et je renvoie des erreurs http aussi explicites que possible.

## Afficher le meilleur gain possible

Cette fois, étant donné que je ne souhaite afficher qu'une information, j'ai opté pour un contrôleur `best_potential_daily_profits` avec une action show, dont la mission est uniquement d'afficher le meilleur gain pour un jour donné.

J'ai tendance à penser que ce genre de endpoints a une relation 1-1 avec le widget, donc je l'ai spécialisé. Je préfère de manière générale avoir plus de contrôleurs qui renvoient un classique CRUD que des contrôleurs avec de nombreuses actions aux noms divers.

Je valide toujours les dates de la même manière, mais rails va de toutes façons raise une erreur si je ne fournis pas de date ou une date vide donc je ne m'en occupe pas. Je ne sais pas si c'est une bonne pratique de bypasser cette erreur avec une erreur custom.

### Algorithme

J'ai localisé pour faire simple l'algorithme dans les modèles, ce qui me semble aussi légitime que dans un autre dossier. Je veux juste qu'il soit isolé et testable facilement.

Pour me faciliter la vie ultérieurement, je ne transforme pas les données active record. Même si c'est inutile aujourd'hui, il est fort probable que cet algorithme évolue et puisse renvoyer plus d'informations sur le "meilleur gain possible". J'ai dans un coin de la tête que le moment du prix d'achat le plus bas et celui de vente le plus haut peuvent être intéressants, ce qui voudrait dire utiliser le champs time par exemple.

L'algorithme est assez simple, il prend la liste ordonnée des prix passés et retourne le profit maximal possible, avec un integer comme demandé dans la spec.

On fait en sorte de ne pas permettre d'achat après la vente, donc les données sont traitées dans l'ordre, une par une.

L'algorithme renvoie 3 types de réponses :
- dans le cas général, le profit, donc un integer supérieur à 0.
- si on n'a pas eu la possibilité de revendre (donc avec aucun voire un seul prix de marché), on renvoie nil. C'est très probablement un scénario qui n'arrive jamais dans la vraie vie.
- Si durant toute la journée, les prix n'ont pas permis de faire de bénéfice, on renvoie 0. Ca ne doit pas arriver souvent mais c'est moins improbable que pas de prix du tout.

J'ai décidé de ne pas traiter ces 3 types de réponse avec des json différents dans le contrôleur, je pars du principe que je documenterais ce que retourne le contrôleur pour indiquer aux équipes front comment traiter l'information.

Je ne suis pas certain du bien fondé de ce choix. Je pars du principe que contrairement aux erreurs http comme bad_request qui sont destinées à corriger la demande client, ici l'application fonctionne normalement et renvoie la réponse qu'elle est supposée renvoyer. Dans le doute, je fais simple.


## Ce que je n'ai pas fait durant ce test 
- Ma version de ruby n'est probablement pas à jour
- je n'ai pas du tout nettoyé l'app rails
- Je n'ai pas implémenté d'authentification, j'imagine que c'est hors scope, mais on ne veut pas laisser nos précieuses patates filer dans les mains d'un pathacker donc il faudrait sécuriser l'accès.
- Je n'ai pas documenté les endpoints, mais ce serait probablement une bonne idée pour la bonne entente entre les peuples du back et du front.
- Je n'ai pas factorisé de code, j'ai préféré me répéter un peu que complexifier.

