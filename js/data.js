/* Données de démonstration (remplacées plus tard par la base de données). */
(function () {
  var S = window.SLSD;
  S.UV = [
    ["Tech & High-tech", "Téléphones, audio, ordinateurs", "photo-1511707171634-5f897ff02aa9", "#1c2a44"],
    ["Maison & Équipement", "Électroménager, mobilier", "photo-1571175443880-49e1d25b2bc5", "#3b2a14"],
    ["Mode & Sur-mesure", "Vêtements, tenues, accessoires", "photo-1591047139829-d91aecb6caea", "#3d1a2e"],
    ["Bâtiment & Architecture", "Plans, ingénierie, chantiers", "photo-1503387762-592deb58ef4e", "#16304a"],
    ["Informatique & Digital", "Sites, applis, marketing", "photo-1498050108023-c5249f4df085", "#2d1a40"],
    ["Design & Création", "Logo, identité, UI", "photo-1517694712202-14dd9538aa97", "#40201a"],
    ["Juridique & Administratif", "NIU, société, contrats, traduction", "photo-1522071820081-009f0129c71c", "#1a3a30"],
    ["Import & Logistique", "Chine vers Afrique, livraison", "photo-1578575437130-527eed3abbec", "#2a2a14"],
    ["Logiciels & PI", "Licences, créations, brevets simples", "photo-1531297484001-80022131f5a1", "#241a44"]
  ];
  S.ITEMS = [
    {t:"produit",u:"Tech & High-tech",n:"iPhone 13 reconditionné 128 Go",s:"TechDouala",c:"Douala",p:285000,k:"telephone iphone smartphone apple portable mobile",i:"photo-1511707171634-5f897ff02aa9"},
    {t:"produit",u:"Tech & High-tech",n:"Écouteurs sans fil Bluetooth",s:"Akwa Digital",c:"Douala",p:18500,k:"ecouteurs casque audio bluetooth musique",i:"photo-1505740420928-5e560c06d30e"},
    {t:"produit",u:"Maison & Équipement",n:"Réfrigérateur double porte 350 L",s:"Maison Plus",c:"Douala",p:425000,k:"frigo refrigerateur double porte electromenager froid",i:"photo-1571175443880-49e1d25b2bc5"},
    {t:"produit",u:"Maison & Équipement",n:"Réfrigérateur double porte 320 L",s:"ElectroKribi",c:"Kribi",p:449000,k:"frigo refrigerateur double porte electromenager froid",i:"photo-1571175443880-49e1d25b2bc5"},
    {t:"produit",u:"Maison & Équipement",n:"Frigo double porte inox",s:"Habitat Pro",c:"Yaoundé",p:410000,k:"frigo refrigerateur double porte electromenager froid",i:"photo-1571175443880-49e1d25b2bc5"},
    {t:"produit",u:"Mode & Sur-mesure",n:"Sneakers urbaines",s:"Mode Bonamoussadi",c:"Douala",p:32000,k:"chaussures baskets sneakers mode",i:"photo-1549298916-b41d501d3772"},
    {t:"produit",u:"Mode & Sur-mesure",n:"Montre classique acier",s:"Horlogerie Bastos",c:"Yaoundé",p:55000,k:"montre accessoire bracelet",i:"photo-1523275335684-37898b6baf30"},
    {t:"service",u:"Mode & Sur-mesure",n:"Tenue sur mesure (costume, robe)",s:"Atelier Ewondo",c:"Yaoundé",p:45000,pl:"dès",k:"tenue sur mesure couture couturier costume robe pagne vetement",i:"photo-1591047139829-d91aecb6caea"},
    {t:"service",u:"Juridique & Administratif",n:"Obtention du NIU",s:"Cabinet Fiscalis",c:"Douala",p:25000,pl:"dès",k:"niu numero identifiant unique impots fiscal entreprise administratif"},
    {t:"service",u:"Juridique & Administratif",n:"Création de société (statuts, RCCM)",s:"Cabinet Fiscalis",c:"Douala",p:150000,pl:"dès",k:"societe entreprise statuts rccm creation juridique"},
    {t:"service",u:"Design & Création",n:"Logo et identité visuelle",s:"Studio Kolo",c:"Douala",p:60000,pl:"dès",k:"logo identite marque graphisme branding charte",i:"photo-1517694712202-14dd9538aa97"},
    {t:"service",u:"Import & Logistique",n:"Import Chine : achat groupé et fret",s:"SLSD Global Trade",c:"Shenzhen → Douala",pl:"sur devis",k:"import importer chine alibaba container fret douane achat groupe",i:"photo-1578575437130-527eed3abbec"},
    {t:"service",u:"Import & Logistique",n:"Livraison urbaine express",s:"Rapid Livraison",c:"Douala",p:1500,pl:"dès",k:"livraison coursier colis express moto transport"},
    {t:"talent",u:"Bâtiment & Architecture",n:"Architecte : plans de maison",s:"Mireille N.",c:"Douala",p:250000,pl:"dès",k:"architecte architecture maison plan villa construction batiment",ini:"M"},
    {t:"talent",u:"Bâtiment & Architecture",n:"Ingénieur génie civil",s:"Samuel E.",c:"Yaoundé",p:150000,pl:"dès",k:"ingenieur genie civil structure chantier calcul batiment",ini:"S"},
    {t:"talent",u:"Informatique & Digital",n:"Développeur web et mobile",s:"Fabrice M.",c:"Douala",p:200000,pl:"dès",k:"developpeur site web application appli logiciel programmation informatique",ini:"F"},
    {t:"talent",u:"Informatique & Digital",n:"Community manager",s:"Estelle R.",c:"Yaoundé",p:60000,pl:"dès",k:"community manager reseaux sociaux marketing publicite contenu",ini:"E"},
    {t:"talent",u:"Design & Création",n:"Designer UI/UX",s:"Aïssatou N.",c:"Douala",p:120000,pl:"dès",k:"designer design interface ux ui maquette",ini:"A"},
    {t:"talent",u:"Juridique & Administratif",n:"Traductrice français-anglais",s:"Grace M.",c:"Bafoussam",p:25000,pl:"dès",k:"traduction traductrice traduire anglais francais langue",ini:"G"},
    {t:"service",u:"Logiciels & PI",n:"Logiciel de gestion de stock (licence)",s:"DevAfrik",c:"Douala",p:35000,pl:"licence",k:"logiciel gestion stock licence boutique caisse application"}
  ];
  S.ITEMS.forEach(function (x, i) { x.id = i; x.h = S.norm([x.n, x.s, x.c, x.u, x.k].join(" ")); });
})();
