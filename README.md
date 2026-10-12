# SLSD — site web (phase 1, fondation)

Site statique (HTML, CSS, JavaScript) pensé pour être édité sur téléphone avec Acode.

## Organisation

```
slsd/
├── index.html         Accueil : recherche, 3 portes, univers, offres
├── catalogue.html     Recherche et filtres (produits, services, professionnels)
├── offre.html         Fiche d'une offre (?id=...)
├── panier.html        Panier et paiement protégé (simulation)
├── connexion.html     Connexion
├── inscription.html   Inscription par rôle (client, vendeur, professionnel)
├── espace.html        Espace personnel selon le rôle
├── css/style.css      Style commun (thème sombre et clair)
├── js/config.js       Réglages : clés Supabase (vides = mode démo)
├── js/app.js          Code commun : outils, panier, comptes, en-tête
├── js/data.js         Offres d'exemple (remplacées plus tard par la base)
├── assets/logo.jpg    Logo
└── sql/schema.sql     Base de données (à coller dans Supabase)
```

## Tester maintenant (mode démo)

1. Garde tous les dossiers ensemble, tels quels.
2. Dans Acode, ouvre le dossier `slsd`, puis `index.html`, puis lance l'aperçu.
3. Crée un compte : il reste sur ton téléphone (aucun mot de passe n'est enregistré en mode démo).

Il faut Internet pour les polices et les photos d'exemple.

## Brancher la vraie base (Supabase)

1. Crée un projet gratuit sur supabase.com.
2. Ouvre « SQL Editor », colle `sql/schema.sql`, puis « Run ».
3. Dans « Project Settings > API », copie l'URL du projet et la clé « anon public ».
4. Colle-les dans `js/config.js`. Le site passe automatiquement en mode réel.
5. N'utilise jamais la clé « service_role » dans le site : elle est secrète.

## Ce qui est fait / à faire

- Fait : pages, navigation, recherche, panier, comptes (démo ou Supabase), espaces par rôle.
- Ensuite : ajout de produits par les vendeurs, vérification des profils, vrai paiement Mobile Money, avis, litiges, administration.
