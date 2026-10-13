# CLAUDE.md — Contexte complet du projet SLSD

> Ce fichier est lu en premier par Claude Code. Il contient tout ce qu'il faut savoir pour travailler sur SLSD sans repartir de zéro.
> Dernière mise à jour : 13 octobre 2026 (Supabase connecté).

---

## 1. Le fondateur et la façon de travailler

- **Fondateur :** Giresse, basé à Douala (Cameroun). Étudiant en BTS Génie Logiciel.
- **Propriétaire unique :** Giresse a racheté les parts des anciens associés. SLSD est désormais son projet à lui seul.
- **Équipe de développement :** Giresse + Claude. Personne d'autre.
- **Langue de travail :** français.
- **Environnement :** Giresse code **uniquement sur téléphone Android** pour l'instant (ordinateur en réparation).
  - Éditeur : **Acode**.
  - Terminal : **Termux** (Node.js et Git installés).
  - Dossier du projet sur le téléphone : `/storage/emulated/0/slsd/slsd` (dans Termux : `~/storage/shared/slsd/slsd`).
  - Dépôt GitHub : `https://github.com/giresse-codes/SLSD-` (branche `main`).
  - Claude Code ne tourne pas en natif dans Termux (pas de binaire Android) : on travaille via Claude Code sur le web / l'application, connecté au dépôt GitHub.
- **Règle de test :** toujours tester le site via « Open in browser » dans Acode (vrai navigateur). Le navigateur intégré d'Acode provoque de faux bugs (ex. la création de compte qui reste bloquée sur « Création du compte… »).
- **Style pédagogique attendu :** Giresse préfère **comprendre** le code et le coller lui-même plutôt que recevoir des fichiers tout faits. Expliquer simplement, une étape à la fois, commandes décomposées morceau par morceau. Il débute en terminal : attention aux espaces, majuscules, tirets.

---

## 2. Identité de SLSD

- **Nom :** SLSD. Branche business historique : Jay Corp by SLSD.
- **Slogan :** « Today. Tomorrow. Beyond. » (le logo affiche « Today • Tomorrow »).
- **Logo :** personnage rond gris aux yeux mi-clos (nonchalant), flèche orange vers le haut, couronne dorée, arc or et blanc, texte SLSD en blanc. Fichier : `assets/logo.jpg`.
- **Identité visuelle :** thème sombre, noir / blanc / or, élégant, professionnel. Pas d'effets gadget façon « IA générique » (logo qui tourne). Site intelligent, structuré, avec de vraies images (produits, personnes, contexte africain).
- **Phrase d'accueil de référence :** « Tout ce dont vous avez besoin. Tous ceux qui peuvent le fournir. »
- **Positionnement :** une plateforme universelle multi-services, « l'Alibaba de l'Afrique », pensée depuis Douala, monnaie **FCFA (XAF)**.

---

## 3. La vision

- SLSD est **« une maison »**, pas juste un projet : produits + services + talents réunis au même endroit.
- **Objectif final (cahier des charges) :** faire de SLSD « le système d'exploitation du commerce et de la collaboration mondiale ».
- **Émotion à l'arrivée :** d'abord la **curiosité** (« qu'est-ce que c'est, je veux comprendre »), puis l'**émerveillement** devant la richesse des options.
- **Ce qui fait rester un client : la CONFIANCE**, grâce à la sécurité du paiement. « La confiance est tellement rare » — c'est elle qui attire.
- **Différence avec Facebook / WhatsApp :** SLSD est un vrai marché dédié, le produit ne se perd pas dans un flux. Produit posté → partagé → le client l'ajoute au panier ou va sur la page du vendeur. SLSD trace les échanges et vérifie qualité et tests.
- **Pour les professionnels :** SLSD fonctionne comme une entreprise qui **leur apporte du travail**.
- **Vision 5–10 ans :** une SLSD avec sa propre IA. Stratégie : démarrer simple, accessible et rentable, puis **réinvestir les revenus** pour monter en puissance.
- **Ambition géographique :** multi-pays dès que possible (zone CEMAC d'abord, ex. Gabon), mais **valider d'abord à Douala**.

---

## 4. Les grandes sections (cahier des charges v1.0)

1. **SLSD Market** — marketplace (technologie, mode, industrie, agriculture, immobilier, automobile…).
2. **SLSD Services** — marché des compétences ; le client publie un besoin, les experts répondent.
3. **SLSD Intellectual Hub** — vente d'inventions, brevets, logiciels, designs, licences.
4. **SLSD Global Trade** — import Chine → Afrique, export Afrique → monde.
5. **SLSD AI** — recherche intelligente, aide aux vendeurs, analyses.

Systèmes transverses : **SLSD Verified** (badges vendeur vérifié / entreprise certifiée / expert reconnu, notation qualité-délais-satisfaction), **SLSD Logistics** (suivi colis, transporteurs partenaires), portefeuille SLSD.

---

## 5. Les trois portes d'entrée (dès l'accueil)

Chacune a son propre parcours de création de compte :

1. **Client** — cherche un besoin quelconque : produit, service, architecte, développeur, maçon…
2. **Vendeur de produits** — ouvre sa boutique.
3. **Professionnel / freelance** — vend ses compétences ou de la propriété intellectuelle.

**Condition pour vendre (décision) :** position médiane entre Alibaba (trop fermé) et Facebook (trop ouvert). On accepte les particuliers et petits commerçants pour remplir vite la plateforme, **mais avec une preuve de statut** : carte de commerçant, patente, registre de commerce, ou pièce d'identité + photo de la boutique / du stock.

---

## 6. Les trois acteurs — fonctionnement de base (socle validé)

### Le visiteur (sans compte)
- **Peut tout VOIR** : produits, annonces de services, profils, avis. On veut qu'il tombe amoureux de l'offre.
- **Ne peut RIEN FAIRE d'actif** : acheter, commander, contacter, publier un besoin, laisser un avis.
- Le mur « Crée ton compte » apparaît **au moment où il veut agir**, quand il est déjà séduit. Jamais à l'entrée.

### Le client
- Arrive avec un besoin.
- Deux façons de trouver (à proposer toutes les deux à terme) :
  - **Parcourir** les annonces, lire les avis, comparer prix et notes, choisir (modèle Fiverr).
  - **Publier son besoin** et laisser les professionnels venir avec des propositions (modèle Upwork).
- Il paie → l'argent est **bloqué en séquestre** → il reçoit → il **valide** (argent libéré) ou **ouvre un litige** (SLSD tranche : remboursement ou reprise du travail).

### Le freelance / vendeur
- Crée un profil-vitrine (portfolio, anciens travaux).
- Publie une annonce à prix de départ, ou répond aux besoins publiés.
- Quand un client paie, il **voit** que l'argent est déposé mais ne le touche pas → il travaille sans peur → il livre → le client valide → l'argent arrive dans son solde → retrait vers mobile money / banque. SLSD prend sa commission.

### Principe-cœur
**Les deux côtés sont protégés en même temps** : le freelance est sûr d'être payé (l'argent est déjà déposé), le client est sûr de ne rien perdre (l'argent ne part qu'après validation).

---

## 7. Modèle économique

- **Commissions : 2 à 10 %** sur les transactions.
- **Abonnements** SLSD Basic (petits vendeurs) / Business (entreprises) / Enterprise (grandes organisations) — logique « gratuit pour entrer, payant pour briller ».
- **Services premium :** publicité, mise en avant, certification, analyse de marché.
- À terme, SLSD veut **employer** des vendeurs et travailleurs.

---

## 8. Paiement et séquestre — règle d'or

- **SLSD ne détient JAMAIS l'argent des utilisateurs.** Détenir des fonds exige le statut d'établissement de paiement (capital minimum de 500 millions FCFA, SA/SAS, agréments BEAC/COBAC).
- **Solution :** se brancher via API sur un **agrégateur agréé** qui bloque et libère les fonds. SLSD n'envoie que deux signaux : **« libère »** ou **« rembourse »**. Le séquestre est une **règle logicielle**, pas un coffre.
- **Agrégateurs envisagés :**
  - Phase 1 (Cameroun) : **Fapshi** ou **CamPay** (simples, API unique MTN MoMo + Orange Money). Aussi : CamerPay, Monetbil, Diool, Smobilpay.
  - Expansion : **Notch Pay** (multi-pays).
- **À vérifier avec l'agrégateur choisi :** capacité réelle de bloquer puis libérer les fonds.
- **Zone CEMAC :** même monnaie, même banque centrale, infrastructure GIMAC → paiements Cameroun ↔ Gabon sans conversion de devise.

---

## 9. Cadre légal (à faire valider par un juriste camerounais avant lancement)

- Loi sur le commerce électronique n° 2010/021.
- Loi sur la protection des données personnelles n° 2024/017 (autorité APDP, sanctions lourdes).
- **CGU** acceptées par case à cocher à l'inscription, couvrant : règles du séquestre, engagements vendeur (délai + qualité), procédure de litige et arbitrage SLSD, commissions, catégories interdites, protection des données. *(Rédaction reportée.)*

---

## 10. Feuille de route

- **Phase 1 — Fondation (vitale, objectif « quelques mois ») :** vente en ligne + proposition de services, profils, boutiques, paiement sécurisé. Simple mais **solide** (rapide ≠ bâclé).
- **Phase 2 — Services + Freelance :** experts, projets, contrats, publication de besoins, niveaux de vendeurs.
- **Phase 3 — Global Trade :** import / export, logistique.
- **Phase 4 — IA avancée :** assistant intelligent, automatisation ; programme vidéo façon TikTok Shop (vendeurs qui testent leurs produits en vidéo).

---

## 11. Leçons des concurrents (à garder en tête)

- **Alibaba :** ne vend rien lui-même, pur intermédiaire (pas de stock). Revenus variés (abonnements, pub, services). **Trade Assurance** = séquestre + engagement vendeur + équipe litiges + conservation des preuves. Faille : presque tous les fournisseurs sont « Gold », le badge ne veut plus rien dire → **un badge SLSD doit rester rare et mérité.**
- **Fiverr :** le vendeur crée un « gig » à prix fixe, le client commande directement. Commission fixe 20 % vendeur + frais acheteur ~5 %. Niveaux de vendeur qui donnent de la visibilité.
- **Upwork :** le client publie un besoin, les freelances proposent. Commission dégressive (récompense les relations longues). Escrow déposé avant le travail, visible mais inaccessible. Le partenaire financier agréé détient l'argent, pas la plateforme.

---

## 12. État actuel du code

Site statique **HTML / CSS / JavaScript** multi-pages. Il bascule tout seul : **mode réel** si `js/config.js` contient les clés Supabase (c'est le cas depuis le 13 octobre 2026), **mode démo** (données fictives sur l'appareil) si elles sont vides ou si le script Supabase ne charge pas.

```
slsd/
├── index.html          Accueil (3 portes d'entrée, recherche, menu Produits / Professionnels / Services / Vision)
├── catalogue.html      Catalogue des offres
├── offre.html          Détail d'une offre (prix XAF, vendeur vérifié, « Paiement protégé »)
├── panier.html         Panier
├── connexion.html      Connexion
├── inscription.html    Inscription
├── espace.html         Mon espace (formulaire : nom, e-mail, mot de passe, ville, numéro Mobile Money)
├── vision.html         Page vision
├── css/style.css
├── js/config.js        URL + clé publique Supabase (vides = mode démo)
├── js/app.js           Logique du site
├── js/data.js          Données démo : 9 univers, 20 offres
├── assets/logo.jpg
├── sql/schema.sql      Base Supabase : profils, listings, orders/order_items
│                       (avec séquestre), reviews, règles RLS
└── README.md
```

- **Supabase est connecté (13 octobre 2026) :**
  - projet `slsd` créé (région Europe de l'Ouest, plan gratuit) ;
  - `sql/schema.sql` installé : **6 tables** (`profiles`, `profils_prives`, `listings`, `orders`, `order_items`, `reviews`) avec règles RLS et la fonction `passer_commande()` ;
  - authentification **par e-mail** activée, inscription autorisée ;
  - **« Confirm email » désactivé pour les tests** → à **réactiver avant le lancement public** ;
  - la **Publishable key** (`sb_publishable_…`) et l'URL du projet sont dans `js/config.js` (clé publique, sans danger dans le code) ;
  - **l'inscription crée un vrai compte** dans `profiles`.
- **Jamais dans le code du site :** la clé `sb_secret_…`, la clé `service_role` et le mot de passe de la base.
- **Ce qui reste en démo dans `js/app.js` et les pages (à brancher, étape 4) :** offres lues depuis `data.js`, panier, publication d'offre, création de commande, chiffres de « Mon espace ».
- Le script CDN Supabase est **présent dans les 8 pages HTML** (vérifié le 13 octobre 2026). Sa version doit être fixée (pas `@2` tout court) pour éviter qu'une mise à jour casse le site sans prévenir.
- **Choix validés pour le mode réel :** chaque nouvelle offre est « en attente » et Giresse la valide lui-même dans Supabase (Table Editor → `listings` → `status` = `active`). Statuts de commande sans accents dans la base : `en_attente_paiement`, `paye_bloque`, `livre`, `valide`, `litige`, `rembourse` (affichés avec accents sur le site).
- Stack long terme envisagée : React / Next.js, TypeScript, Node.js / Python, PostgreSQL.

---

## 13. Prochaines étapes (dans l'ordre conseillé)

1. Vérifier dans le vrai navigateur : lien Vision, recherche, ajout au panier, Mon espace, déconnexion / reconnexion.
2. ~~Créer le compte Supabase~~ — **fait** (13 octobre 2026). Reste : brancher `js/app.js` sur la base (offres, publication, panier, commandes).
3. Choisir l'agrégateur de paiement (Fapshi ou CamPay) et confirmer le blocage / libération des fonds.
4. Implémenter le parcours séquestre : paiement → bloqué → validation → libération / litige.
5. Ajouter la vérification vendeur (preuve de statut).
6. Rédiger le squelette des CGU.
7. Faire valider le montage par un juriste camerounais.
8. Lancer avec de vrais premiers utilisateurs à Douala.

### À faire — liste ajoutée le 13 octobre 2026

- **Refonte visuelle animée** : site sombre très animé, noir et or, avec GSAP + ScrollTrigger (voir section 15). On montre d'abord l'accueil seul.
- **Petit œil 👁 pour afficher le mot de passe** (pages `inscription.html` et `connexion.html`). Le champ reste de type `password` par défaut ; l'œil le bascule en `text` et doit être utilisable au doigt (bouton assez grand, `aria-label`).
- **Format du numéro Mobile Money avec l'indicatif +237** (champ `#ph` de `inscription.html`) : afficher « +237 » fixe devant le champ, n'accepter que 9 chiffres commençant par 6 (ex. 6 XX XX XX XX), enregistrer le numéro en `+2376XXXXXXXX`. La base accepte déjà 30 caractères.
- Réactiver « Confirm email » dans Supabase avant le lancement public.

---

## 14. Consignes pour Claude Code

- Parler **français**, simplement, une étape à la fois.
- **Expliquer avant de modifier**, et montrer ce qui change.
- Garder le site **léger et compatible mobile** (Giresse teste sur téléphone).
- Ne jamais coder de logique où SLSD détiendrait l'argent : toujours passer par l'agrégateur.
- Respecter l'identité visuelle noir / blanc / or.
- Après chaque changement poussé sur GitHub, rappeler à Giresse de faire `git pull` dans Termux puis de tester via « Open in browser ».

---

## 15. Direction visuelle — refonte prévue (après le passage au mode réel)

Demandée le 13 octobre 2026. **Ordre : d'abord finir Supabase (mode réel), ensuite la refonte**, sur la même branche, puis pousser sur `main`.

**Inspirations (vidéos fournies par Giresse) :**
- *Le plus proche* — site sombre de motion design (Scalyx) : fond très sombre, **une seule couleur d'accent**, cartes et captures qui glissent et s'agrandissent au défilement, textes révélés progressivement.
- Site immobilier « FIND » : grande image plein écran, très grand titre, typographie géante (« Buy / Sell / Rent ») qui défile, beaucoup d'espace.
- Site logistique (camions) : grandes photos plein écran, sections qui s'ouvrent l'une après l'autre.

**Ce que la refonte doit donner :**
- Accueil : grande image plein écran et grand titre qui apparaît en douceur.
- Animations au défilement : sections qui glissent, s'ouvrent ou s'agrandissent ; textes révélés progressivement.
- Grandes cartes avec photos pour les univers (produits, services, professionnels).
- Typographie très grande et élégante, beaucoup d'espace.
- Sombre, avec **l'or comme seule couleur d'accent** (identité noir / blanc / or). Pas de logo qui tourne, pas d'effet gadget.

**Règles techniques :**
- GSAP + ScrollTrigger autorisés via CDN (version fixée).
- Rapide sur un Android moyen en connexion lente : images légères (largeur adaptée, `loading="lazy"`), animations fluides (uniquement `transform` et `opacity`).
- Respecter `prefers-reduced-motion` : aucune animation pour ceux qui l'ont demandé.
- **Si une animation ne charge pas, le contenu reste visible et utilisable** : le contenu est visible par défaut, c'est le JavaScript qui le cache juste avant de l'animer.
- Garder tous les `id`, classes et attributs utilisés par `js/app.js` et les scripts des pages (ex. `#hdr`, `#ftr`, `#gr`, `#uni`, `#cn`, `#au`, `data-add`…).
- **Montrer d'abord l'accueil seul** à Giresse avant de refaire les autres pages.
