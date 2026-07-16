import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const outputDir = join(process.cwd(), 'assets', 'themes');
mkdirSync(outputDir, { recursive: true });

const maxPairCount = 300;
const maxWordUses = 2;
const maxRepeatedWordRatio = 0.3;
const maxJokeRatio = 0.05;

const themeOrder = [
  'general',
  'manga',
  'cuisine',
  'super_heros',
  'jeu_video',
  'sorcier_fantasy',
  'cinema',
  'personnalites_connues',
  'dessin_anime',
  'pop_culture',
];

const themes = {
  general: {
    id: 'general',
    name: 'General',
    description: 'Des mots accessibles pour lancer une partie rapide.',
    icon: 'general',
    color: '#36E879',
    groups: [
      ['Pizza', 'Burger', 'Tacos', 'Kebab'],
      ['Cinema', 'Theatre', 'Concert', 'Spectacle'],
      ['Plage', 'Piscine', 'Lac', 'Riviere'],
      ['Train', 'Metro', 'Tramway', 'Bus'],
      ['Chat', 'Chien', 'Lapin', 'Hamster'],
      ['Cafe', 'The', 'Chocolat chaud', 'Jus'],
      ['Telephone', 'Ordinateur', 'Tablette', 'Console'],
      ['Ecole', 'College', 'Lycee', 'Universite'],
      ['Boulangerie', 'Patisserie', 'Epicerie', 'Supermarche'],
      ['Foot', 'Basket', 'Tennis', 'Rugby'],
      ['Paris', 'Lyon', 'Marseille', 'Bordeaux'],
      ['Montagne', 'Colline', 'Foret', 'Campagne'],
      ['Livre', 'Magazine', 'Journal', 'BD'],
      ['Stylo', 'Crayon', 'Feutre', 'Marqueur'],
      ['Canape', 'Fauteuil', 'Chaise', 'Tabouret'],
      ['Voiture', 'Moto', 'Velo', 'Trottinette'],
      ['Avion', 'Helicoptere', 'Fusee', 'Montgolfiere'],
      ['Soleil', 'Lune', 'Etoile', 'Planete'],
      ['Hiver', 'Ete', 'Printemps', 'Automne'],
      ['Pluie', 'Neige', 'Orage', 'Brouillard'],
      ['Mer', 'Ocean', 'Vague', 'Maree'],
      ['Hotel', 'Appartement', 'Maison', 'Villa'],
      ['Banque', 'Poste', 'Mairie', 'Prefecture'],
      ['Medecin', 'Dentiste', 'Pharmacien', 'Infirmier'],
      ['Police', 'Pompier', 'Ambulance', 'Urgence'],
      ['Carte', 'Plan', 'GPS', 'Boussole'],
      ['Chemise', 'T-shirt', 'Pull', 'Veste'],
      ['Basket', 'Chaussure', 'Botte', 'Sandale'],
      ['Montre', 'Bracelet', 'Collier', 'Bague'],
      ['Valise', 'Sac', 'Cartable', 'Sacoche'],
      ['Jardin', 'Balcon', 'Terrasse', 'Veranda'],
      ['Cuisine', 'Salon', 'Chambre', 'Salle de bain'],
      ['Fourchette', 'Couteau', 'Cuillere', 'Assiette'],
      ['Sel', 'Poivre', 'Sucre', 'Farine'],
      ['Orange', 'Citron', 'Pomme', 'Poire'],
      ['Rouge', 'Bleu', 'Vert', 'Jaune'],
      ['Matin', 'Midi', 'Soir', 'Nuit'],
      ['Dimanche', 'Samedi', 'Vendredi', 'Lundi'],
      ['Anniversaire', 'Mariage', 'Fete', 'Soiree'],
      ['Photo', 'Video', 'Selfie', 'Story'],
      ['Internet', 'Wifi', 'Bluetooth', 'Reseau'],
      ['Facture', 'Recu', 'Ticket', 'Devis'],
      ['Vacances', 'Week-end', 'Conge', 'Repos'],
      ['Bureau', 'Reunion', 'Dossier', 'Projet'],
      ['Question', 'Reponse', 'Indice', 'Solution'],
      ['Chance', 'Hasard', 'Destin', 'Coïncidence'],
      ['Silence', 'Bruit', 'Musique', 'Conversation'],
      ['Vitesse', 'Frein', 'Virage', 'Route'],
      ['Memoire', 'Souvenir', 'Reve', 'Idee'],
      ['Clavier', 'Souris', 'Ecran', 'Imprimante'],
      ['Cinema 4DX', 'Siege qui bouge', 'Popcorn renverse', 'Film trop long'],
      ['Reveil', 'Alarme', 'Retard', 'Excuse'],
    ],
    jokes: [
      ['Regime demain', 'Pizza ce soir', 'soft_joke'],
    ],
  },
  manga: {
    id: 'manga',
    name: 'Manga',
    description: 'Anime, rivalites, pouvoirs, memes et refs de fans.',
    icon: 'magic',
    color: '#FF8A2A',
    disableAutoCross: true,
    groups: [
      ['Naruto', 'Sasuke', 'Sakura', 'Kakashi'],
      ['Luffy', 'Zoro', 'Sanji', 'Nami'],
      ['Goku', 'Vegeta', 'Gohan', 'Piccolo'],
      ['Ichigo', 'Rukia', 'Byakuya', 'Aizen'],
      ['Eren', 'Mikasa', 'Armin', 'Levi'],
      ['Deku', 'Bakugo', 'Todoroki', 'All Might'],
      ['Tanjiro', 'Nezuko', 'Zenitsu', 'Inosuke'],
      ['Light Yagami', 'L', 'Ryuk', 'Misa'],
      ['Gon', 'Killua', 'Kurapika', 'Hisoka'],
      ['Edward Elric', 'Alphonse Elric', 'Roy Mustang', 'Scar'],
      ['Saitama', 'Genos', 'Tatsumaki', 'Garou'],
      ['Natsu', 'Grey', 'Lucy', 'Erza'],
      ['Yugi', 'Kaiba', 'Exodia', 'Magicien Sombre'],
      ['Seiya', 'Shiryu', 'Hyoga', 'Ikki'],
      ['Jotaro', 'Dio', 'Joseph Joestar', 'Giorno'],
      ['Denji', 'Power', 'Aki', 'Makima'],
      ['Yuji Itadori', 'Megumi', 'Nobara', 'Gojo'],
      ['Mob', 'Reigen', 'Dimple', 'Ritsu'],
      ['Kaneki', 'Touka', 'Amon', 'Rize'],
      ['Shinji', 'Rei', 'Asuka', 'Eva-01'],
      ['Akira', 'Kaneda', 'Tetsuo', 'Neo Tokyo'],
      ['Totoro', 'Chihiro', 'Haku', 'No-Face'],
      ['Dracaufeu', 'Pikachu', 'Mewtwo', 'Evoli'],
      ['Salameche', 'Reptincel', 'Dracaufeu', 'Mega Dracaufeu'],
      ['Sharingan', 'Byakugan', 'Rinnegan', 'Mangekyo'],
      ['Haki', 'Fruit du demon', 'Gear 5', 'Grand Line'],
      ['Bankai', 'Zanpakuto', 'Shinigami', 'Hollow'],
      ['Titan Assaillant', 'Titan Colossal', 'Titan Cuirasse', 'Titan Feminin'],
      ['Kamehameha', 'Genkidama', 'Ultra Instinct', 'Super Saiyan'],
      ['Demon Slayer', 'Pilier', 'Souffle de l eau', 'Lame du nichirin'],
      ['Chunin', 'Hokage', 'Akatsuki', 'Bijuu'],
      ['One Piece', 'Naruto', 'Dragon Ball', 'Bleach'],
      ['Manga papier', 'Anime', 'Scan', 'Episode filler'],
      ['Opening', 'Ending', 'OST', 'AMV'],
      ['Sensei', 'Rival', 'Tournoi', 'Entrainement'],
      ['Arc long', 'Flashback', 'Power-up', 'Plot armor'],
      ['Crocodile One Piece', 'Doflamingo', 'Kaido', 'Big Mom'],
      ['Freezer', 'Cell', 'Buu', 'Beerus'],
      ['Madara', 'Obito', 'Pain', 'Orochimaru'],
      ['Shanks', 'Mihawk', 'Barbe Blanche', 'Roger'],
      ['Itachi', 'Kisame', 'Deidara', 'Sasori'],
      ['Netero', 'Meruem', 'Chrollo', 'Biscuit'],
      ['Toji', 'Sukuna', 'Mahito', 'Geto'],
      ['Rengoku', 'Tengen', 'Mitsuri', 'Muichiro'],
      ['Roronoa Zoro', 'Levi Ackerman', 'Gojo Satoru', 'Kakashi Hatake'],
    ],
    curatedPairs: [
      ['Genos', 'C-17'],
      ['Genos', 'Dr Gero'],
      ['Doflamingo', 'Kankuro'],
      ['Brigade Fantome', 'Akatsuki'],
      ['Nen', 'Energie occulte'],
      ['Kunai', 'Shuriken'],
      ['Sharingan', 'Byakugan'],
      ['Haki', 'Nen'],
      ['Bankai', 'Domaine d extension'],
      ['Kamehameha', 'Rasengan'],
      ['Gear 5', 'Ultra Instinct'],
      ['Titan Assaillant', 'Kyubi'],
      ['Fruit du demon', 'Alter'],
      ['Zanpakuto', 'Lame du nichirin'],
      ['Guilde Fairy Tail', 'Equipage du Chapeau de Paille'],
      ['Examen Chunin', 'Hunter Exam'],
      ['Tournoi du Pouvoir', 'Tournoi des Tenkaichi'],
      ['Hokage', 'Roi des Pirates'],
      ['Shinigami', 'Exorciste'],
      ['Pilier', 'S-Class Hero'],
      ['Bijuu', 'Titan primordial'],
      ['Akatsuki', 'Espada'],
      ['Sukuna', 'Kurama'],
      ['Gojo Satoru', 'Kakashi Hatake'],
      ['Levi Ackerman', 'Roronoa Zoro'],
      ['Light Yagami', 'Lelouch'],
      ['Misa', 'Yuno Gasai'],
      ['Hisoka', 'Dio'],
      ['Madara', 'Aizen'],
      ['Orochimaru', 'Mayuri'],
      ['Makima', 'Aizen'],
      ['Freezer', 'Doflamingo'],
      ['Kaido', 'Meruem'],
      ['Netero', 'Maitre Roshi'],
      ['Gon', 'Naruto'],
      ['Killua', 'Sasuke'],
      ['Tanjiro', 'Deku'],
      ['Bakugo', 'Vegeta'],
      ['Todoroki', 'Zuko'],
      ['Nezuko', 'Power'],
      ['Zenitsu', 'Usopp'],
      ['Saitama', 'Mob'],
      ['Reigen', 'Maitre Roshi'],
      ['Edward Elric', 'Senku'],
      ['Alphonse Elric', 'C-16'],
      ['Eva-01', 'Gundam'],
      ['Mewtwo', 'Meruem'],
      ['Dracaufeu', 'Kurama'],
      ['Salameche', 'Dracaufeu'],
      ['Crocodile One Piece', 'Crocodile Famille Pirate'],
      ['Nami', 'Bulma'],
      ['Sanji', 'Brock'],
      ['Zoro', 'Killer Bee'],
      ['Kakashi', 'Gojo Satoru'],
      ['Itachi', 'Byakuya'],
      ['Deidara', 'Mr 5'],
      ['Sasori', 'Kankuro'],
      ['Pain', 'Shigaraki'],
      ['Obito', 'Geto'],
      ['Kisame', 'Jinbei'],
      ['Inosuke', 'Bakugo'],
      ['Rengoku', 'Ace'],
      ['Tengen', 'Hisoka'],
      ['Mitsuri', 'Boa Hancock'],
      ['Muichiro', 'Killua'],
      ['Chrollo', 'Geto'],
      ['Kurapika', 'Sasuke'],
      ['Meruem', 'Cell'],
      ['Biscuit', 'Tsunade'],
      ['Aki', 'Megumi'],
      ['Power', 'Nobara'],
      ['Makima', 'Esdeath'],
      ['Denji', 'Yuji Itadori'],
      ['Mob', 'Saiki Kusuo'],
      ['Dimple', 'Kurama'],
      ['Reigen', 'Hercule Satan'],
      ['Kaneki', 'Eren'],
      ['Touka', 'Mikasa'],
      ['Amon', 'Erwin'],
      ['Rize', 'Makima'],
      ['Rei', 'Mikasa'],
      ['Asuka', 'Nobara'],
      ['Tetsuo', 'Mob'],
      ['Kaneda', 'Mikey'],
      ['No-Face', 'Ryuk'],
      ['Totoro', 'Snorlax'],
      ['Pikachu', 'Happy'],
      ['Mewtwo', 'Cell'],
      ['Evoli', 'Chopper'],
      ['Rinnegan', 'Six Eyes'],
      ['Mangekyo', 'Domaine d extension'],
      ['Grand Line', 'Route du serpent'],
      ['Hollow', 'Demon'],
      ['Super Saiyan', 'Mode Ermite'],
      ['Souffle de l eau', 'Rasengan'],
      ['Lame du nichirin', 'Zanpakuto'],
      ['Akatsuki', 'Brigade Fantome'],
      ['Bijuu', 'Fruit du demon'],
      ['One Piece', 'Hunter x Hunter'],
      ['Dragon Ball', 'Naruto'],
      ['Bleach', 'Jujutsu Kaisen'],
      ['Scan', 'Episode filler'],
      ['Opening', 'AMV'],
      ['Sensei', 'Maitre'],
      ['Rival', 'Antagoniste'],
      ['Power-up', 'Transformation'],
      ['Plot armor', 'Amitie magique'],
      ['Sakura', 'Poubelle', 'troll'],
      ['Yamcha', 'Victime', 'troll'],
    ],
    jokes: [
      ['Usopp', 'Mytho', 'troll'],
      ['Zenitsu', 'Alarme', 'troll'],
      ['Piccolo', 'Vrai pere de Gohan', 'soft_joke'],
    ],
  },
  cuisine: {
    id: 'cuisine',
    name: 'Cuisine',
    description: 'Ingredients, plats, ustensiles et classiques de table.',
    icon: 'chef',
    color: '#8995FF',
    groups: [
      ['Four', 'Micro-ondes', 'Air fryer', 'Plaque'],
      ['Poele', 'Casserole', 'Marmite', 'Wok'],
      ['Sel', 'Poivre', 'Paprika', 'Curry'],
      ['Sucre', 'Miel', 'Sirop', 'Caramel'],
      ['Farine', 'Levure', 'Maizena', 'Chapelure'],
      ['Pates', 'Riz', 'Semoule', 'Quinoa'],
      ['Pizza', 'Lasagne', 'Gratin', 'Tarte salee'],
      ['Burger', 'Hot-dog', 'Kebab', 'Tacos'],
      ['Sushi', 'Maki', 'Sashimi', 'Onigiri'],
      ['Couscous', 'Tajine', 'Chakchouka', 'Harira'],
      ['Boeuf', 'Poulet', 'Agneau', 'Dinde'],
      ['Saumon', 'Thon', 'Cabillaud', 'Crevette'],
      ['Tomate', 'Poivron', 'Aubergine', 'Courgette'],
      ['Carotte', 'Pomme de terre', 'Patate douce', 'Navet'],
      ['Oignon', 'Ail', 'Echalote', 'Ciboulette'],
      ['Basilic', 'Persil', 'Coriandre', 'Menthe'],
      ['Pomme', 'Poire', 'Peche', 'Abricot'],
      ['Fraise', 'Framboise', 'Myrtille', 'Cerise'],
      ['Orange', 'Citron', 'Pamplemousse', 'Clementine'],
      ['Fromage', 'Yaourt', 'Creme', 'Beurre'],
      ['Camembert', 'Brie', 'Comte', 'Roquefort'],
      ['Pain', 'Baguette', 'Brioche', 'Croissant'],
      ['Gateau', 'Tarte', 'Fondant', 'Muffin'],
      ['Crepe', 'Gaufre', 'Pancake', 'Blinis'],
      ['Cafe', 'The', 'Chocolat chaud', 'Smoothie'],
      ['Eau plate', 'Eau gazeuse', 'Limonade', 'Jus'],
      ['Entree', 'Plat', 'Dessert', 'Fromage'],
      ['Recette', 'Menu', 'Carte', 'Degustation'],
      ['Chef', 'Commis', 'Serveur', 'Plongeur'],
      ['Restaurant', 'Cantine', 'Bistro', 'Brasserie'],
      ['Barbecue', 'Plancha', 'Grill', 'Brochette'],
      ['Sauce tomate', 'Sauce blanche', 'Sauce barbecue', 'Mayonnaise'],
      ['Ketchup', 'Moutarde', 'Harissa', 'Pesto'],
      ['Omelette', 'Oeuf dur', 'Oeuf au plat', 'Oeuf brouille'],
      ['Salade', 'Soupe', 'Veloute', 'Bouillon'],
      ['Frite', 'Potatoes', 'Puree', 'Gratin dauphinois'],
      ['Glace', 'Sorbet', 'Milkshake', 'Yaourt glace'],
      ['Chocolat noir', 'Chocolat au lait', 'Chocolat blanc', 'Praline'],
      ['Cuisson saignante', 'Cuisson a point', 'Bien cuit', 'Bleu'],
      ['Couteau', 'Fourchette', 'Cuillere', 'Spatule'],
      ['Planche', 'Passoire', 'Fouet', 'Louche'],
      ['Frigo', 'Congelateur', 'Placard', 'Cave'],
      ['Marinade', 'Panure', 'Friture', 'Vapeur'],
      ['Petit dejeuner', 'Brunch', 'Dejeuner', 'Diner'],
      ['Food truck', 'Buffet', 'Traiteur', 'Livraison'],
      ['Nutella', 'Confiture', 'Beurre de cacahuete', 'Compote'],
    ],
    jokes: [
      ['Air fryer', 'Four TikTok', 'soft_joke'],
    ],
  },
  super_heros: {
    id: 'super_heros',
    name: 'Super-heros',
    description: 'DC, MCU, Marvel, pouvoirs, costumes et rivalites.',
    icon: 'shield',
    color: '#E84142',
    preferCrossThemePairs: true,
    groups: [
      ['Iron Man', 'War Machine', 'Rescue', 'Jarvis'],
      ['Captain America', 'Bucky', 'Falcon', 'US Agent'],
      ['Thor', 'Loki', 'Odin', 'Hela'],
      ['Hulk', 'She-Hulk', 'Abomination', 'Red Hulk'],
      ['Black Widow', 'Hawkeye', 'Yelena', 'Kate Bishop'],
      ['Spider-Man', 'Miles Morales', 'Venom', 'Green Goblin'],
      ['Doctor Strange', 'Wong', 'Dormammu', 'Ancient One'],
      ['Black Panther', 'Shuri', 'Killmonger', 'Okoye'],
      ['Star-Lord', 'Gamora', 'Drax', 'Rocket'],
      ['Groot', 'Rocket', 'Nebula', 'Mantis'],
      ['Ant-Man', 'Wasp', 'Kang', 'Hank Pym'],
      ['Scarlet Witch', 'Vision', 'Quicksilver', 'Agatha'],
      ['Deadpool', 'Wolverine', 'Cable', 'Domino'],
      ['Professor X', 'Magneto', 'Mystique', 'Beast'],
      ['Cyclope', 'Jean Grey', 'Storm', 'Rogue'],
      ['Batman', 'Robin', 'Nightwing', 'Batgirl'],
      ['Superman', 'Supergirl', 'Zod', 'Lois Lane'],
      ['Wonder Woman', 'Aquaman', 'Flash', 'Cyborg'],
      ['Green Lantern', 'Martian Manhunter', 'Shazam', 'Black Adam'],
      ['Joker', 'Harley Quinn', 'Riddler', 'Penguin'],
      ['Thanos', 'Ultron', 'Loki', 'Kang'],
      ['Joker', 'Lex Luthor', 'Darkseid', 'Deathstroke'],
      ['Gotham', 'Metropolis', 'Wakanda', 'Asgard'],
      ['Batmobile', 'Quinjet', 'Helicarrier', 'Invisible Jet'],
      ['Mjolnir', 'Stormbreaker', 'Bouclier vibranium', 'Anneau vert'],
      ['Vibranium', 'Adamantium', 'Kryptonite', 'Arc reactor'],
      ['Infinity Stones', 'Mother Box', 'Tesseract', 'Lasso de verite'],
      ['Cowl', 'Cape', 'Armure', 'Masque'],
      ['Multivers', 'Timeline', 'Variant', 'Cameo'],
      ['Post-credit', 'Trailer', 'Reboot', 'Retcon'],
      ['Avengers', 'Justice League', 'X-Men', 'Fantastic Four'],
      ['Civil War', 'Infinity War', 'Endgame', 'Secret Wars'],
      ['Arkham', 'Daily Planet', 'Stark Tower', 'Sanctum Sanctorum'],
      ['Pepper Potts', 'Mary Jane', 'Gwen Stacy', 'Lois Lane'],
      ['Alfred', 'Happy Hogan', 'Nick Fury', 'Commissioner Gordon'],
      ['Daredevil', 'Punisher', 'Jessica Jones', 'Luke Cage'],
      ['Moon Knight', 'Blade', 'Ghost Rider', 'Elektra'],
      ['Homelander', 'Omni-Man', 'Invincible', 'The Deep'],
      ['Syndrome', 'Mr Indestructible', 'Elastigirl', 'Frozone'],
      ['Civilian identity', 'Secret identity', 'Sidekick', 'Nemesis'],
      ['Laser eyes', 'Super strength', 'Flight', 'Healing factor'],
      ['Billionaire hero', 'Alien hero', 'Mutant hero', 'Street hero'],
      ['Phase 1', 'Phase 2', 'Phase 3', 'Phase 4'],
      ['DC Comics', 'Marvel Comics', 'Image Comics', 'Dark Horse'],
      ['Gardiens de la Galaxie', 'Suicide Squad', 'Thunderbolts', 'Eternals'],
    ],
    curatedPairs: [
      ['Batman', 'Iron Man'],
      ['Superman', 'Captain Marvel'],
      ['Aquaman', 'Namor'],
      ['Flash', 'Quicksilver'],
      ['Green Arrow', 'Hawkeye'],
      ['Green Lantern', 'Doctor Strange'],
      ['Wonder Woman', 'Captain America'],
      ['Cyborg', 'War Machine'],
      ['Shazam', 'Thor'],
      ['Black Panther', 'Batman'],
      ['Joker', 'Green Goblin'],
      ['Lex Luthor', 'Kingpin'],
      ['Darkseid', 'Thanos'],
      ['Deathstroke', 'Deadpool'],
      ['Harley Quinn', 'Domino'],
      ['Catwoman', 'Black Cat'],
      ['Professor X', 'Martian Manhunter'],
      ['Magneto', 'Doctor Doom'],
      ['Wolverine', 'Deadpool'],
      ['Daredevil', 'Batman'],
      ['Punisher', 'Red Hood'],
      ['Moon Knight', 'Batman'],
      ['Scarlet Witch', 'Zatanna'],
      ['Vision', 'Red Tornado'],
      ['Ultron', 'Brainiac'],
      ['Avengers', 'Justice League'],
      ['X-Men', 'Teen Titans'],
      ['Suicide Squad', 'Thunderbolts'],
      ['Vibranium', 'Adamantium'],
      ['Kryptonite', 'Vibranium'],
      ['Mjolnir', 'Stormbreaker'],
      ['Batmobile', 'Quinjet'],
      ['Wakanda', 'Atlantis'],
      ['Gotham', 'Hell Kitchen'],
      ['Asgard', 'Themyscira'],
      ['Infinity Stones', 'Mother Box'],
      ['Bouclier vibranium', 'Lasso de verite'],
      ['Secret identity', 'Civilian identity'],
      ['Sidekick', 'Apprenti'],
      ['Cape', 'Masque'],
      ['Batman', 'Milliardaire', 'soft_joke'],
      ['Aquaman', 'Sauveteur', 'soft_joke'],
      ['Hawkeye', 'Flechette', 'troll'],
    ],
    jokes: [
      ['Superman', 'Kryptonite', 'soft_joke'],
      ['Cyclope', 'Lunettes rouges', 'soft_joke'],
    ],
  },
  jeu_video: {
    id: 'jeu_video',
    name: 'Jeu video',
    description: 'Consoles, persos cultes, boss, loot et rage quit.',
    icon: 'gamepad',
    color: '#00C2FF',
    groups: [
      ['Mario', 'Luigi', 'Peach', 'Bowser'],
      ['Yoshi', 'Toad', 'Wario', 'Waluigi'],
      ['Link', 'Zelda', 'Ganondorf', 'Epona'],
      ['Pikachu', 'Evoli', 'Mewtwo', 'Dracaufeu'],
      ['Sacha', 'Ondine', 'Pierre', 'Team Rocket'],
      ['Sonic', 'Tails', 'Knuckles', 'Dr Eggman'],
      ['Kratos', 'Atreus', 'Zeus', 'Ares'],
      ['Master Chief', 'Cortana', 'Arbiter', 'Flood'],
      ['Nathan Drake', 'Lara Croft', 'Indiana Jones', 'Tomb Raider'],
      ['Geralt', 'Ciri', 'Yennefer', 'Triss'],
      ['Cloud', 'Sephiroth', 'Tifa', 'Aerith'],
      ['Ryu', 'Ken', 'Chun-Li', 'Akuma'],
      ['Scorpion', 'Sub-Zero', 'Raiden', 'Liu Kang'],
      ['Jinx', 'Vi', 'Caitlyn', 'Ekko'],
      ['Tracer', 'Genji', 'Mercy', 'Reaper'],
      ['Minecraft', 'Terraria', 'Roblox', 'Fortnite'],
      ['GTA', 'Red Dead Redemption', 'Mafia', 'Watch Dogs'],
      ['FIFA', 'NBA 2K', 'Rocket League', 'eFootball'],
      ['Call of Duty', 'Battlefield', 'Valorant', 'Counter-Strike'],
      ['League of Legends', 'Dota 2', 'Smite', 'Heroes of the Storm'],
      ['Elden Ring', 'Dark Souls', 'Bloodborne', 'Sekiro'],
      ['Skyrim', 'Fallout', 'Starfield', 'Oblivion'],
      ['Resident Evil', 'Silent Hill', 'Dead Space', 'The Evil Within'],
      ['Among Us', 'Fall Guys', 'Gang Beasts', 'Human Fall Flat'],
      ['Animal Crossing', 'Stardew Valley', 'The Sims', 'Harvest Moon'],
      ['Switch', 'PlayStation', 'Xbox', 'PC Gamer'],
      ['Manette', 'Clavier souris', 'Joystick', 'Volant'],
      ['Sauvegarde', 'Checkpoint', 'Respawn', 'Game over'],
      ['Boss final', 'Mini-boss', 'Mob', 'PNJ'],
      ['Loot', 'Skin', 'Battle pass', 'Emote'],
      ['Ranked', 'Casual', 'Matchmaking', 'Lobby'],
      ['Noob', 'Smurf', 'Tryhard', 'Campeur'],
      ['Headshot', 'Kill streak', 'Assist', 'Ace'],
      ['Open world', 'Couloir', 'Donjon', 'Map'],
      ['Speedrun', 'Glitch', 'Skip', 'World record'],
      ['RPG', 'FPS', 'MOBA', 'Battle royale'],
      ['Solo', 'Coop', 'Multijoueur', 'Split screen'],
      ['Patch note', 'Nerf', 'Buff', 'Meta'],
      ['Craft', 'Farm', 'Grind', 'XP'],
      ['Quete principale', 'Quete annexe', 'Succes', 'Trophee'],
      ['Zelda Breath of the Wild', 'Zelda Tears of the Kingdom', 'Ocarina of Time', 'Majora Mask'],
      ['Mario Kart', 'Smash Bros', 'Splatoon', 'Pokemon Unite'],
      ['Bioshock', 'Portal', 'Half-Life', 'Dishonored'],
      ['Hades', 'Celeste', 'Hollow Knight', 'Cuphead'],
      ['Crash Bandicoot', 'Spyro', 'Rayman', 'Ratchet'],
    ],
    jokes: [
      ['Manette drift', 'Fantome dans le joystick', 'soft_joke'],
    ],
  },
  sorcier_fantasy: {
    id: 'sorcier_fantasy',
    name: 'Sorcier & fantasy',
    description: 'Magie, ecoles, anneaux, dragons et quetes impossibles.',
    icon: 'magic',
    color: '#A66CFF',
    groups: [
      ['Harry Potter', 'Ron Weasley', 'Hermione Granger', 'Draco Malefoy'],
      ['Dumbledore', 'Voldemort', 'Severus Rogue', 'Hagrid'],
      ['Sirius Black', 'Remus Lupin', 'Bellatrix', 'Lucius Malefoy'],
      ['Gryffondor', 'Serpentard', 'Serdaigle', 'Poufsouffle'],
      ['Poudlard', 'Beauxbatons', 'Durmstrang', 'Ministere de la Magie'],
      ['Baguette', 'Balai', 'Cape invisibilite', 'Carte du Maraudeur'],
      ['Quidditch', 'Vif d or', 'Cognard', 'Souafle'],
      ['Expecto Patronum', 'Expelliarmus', 'Avada Kedavra', 'Wingardium Leviosa'],
      ['Horcruxe', 'Reliques de la Mort', 'Pierre philosophale', 'Retourneur de temps'],
      ['Hobbit', 'Elfe', 'Nain', 'Orc'],
      ['Frodon', 'Sam', 'Gandalf', 'Aragorn'],
      ['Legolas', 'Gimli', 'Boromir', 'Gollum'],
      ['Sauron', 'Saroumane', 'Nazgul', 'Balrog'],
      ['Anneau unique', 'Mordor', 'Comte', 'Gondor'],
      ['Rohan', 'Fondcombe', 'Moria', 'Isengard'],
      ['Bilbon', 'Thorin', 'Smaug', 'Bard'],
      ['Daenerys', 'Jon Snow', 'Arya Stark', 'Tyrion'],
      ['Cersei', 'Jaime', 'Sansa', 'Bran'],
      ['Dragon', 'Loup-garou', 'Vampire', 'Fantome'],
      ['Sorcier', 'Mage', 'Druide', 'Necromancien'],
      ['Potion', 'Sortilege', 'Malefice', 'Enchantement'],
      ['Grimoire', 'Parchemin', 'Rune', 'Relique'],
      ['Donjon', 'Quete', 'Guilde', 'Taverne'],
      ['Epee', 'Arc', 'Dague', 'Hache'],
      ['Armure', 'Bouclier', 'Casque', 'Cape'],
      ['Mana', 'Experience', 'Niveau', 'Competence'],
      ['Licorne', 'Griffon', 'Phoenix', 'Basilic'],
      ['Dragon rouge', 'Dragon noir', 'Dragon blanc', 'Wyverne'],
      ['Narnia', 'Poudlard', 'Terre du Milieu', 'Westeros'],
      ['Aslan', 'Sorciere blanche', 'Caspian', 'Edmund'],
      ['Merlin', 'Morgane', 'Arthur', 'Lancelot'],
      ['Excalibur', 'Graal', 'Table ronde', 'Avalon'],
      ['Geralt de Riv', 'Yennefer', 'Ciri', 'Jaskier'],
      ['Monstre', 'Chasseur', 'Contrat', 'Potion de sorceleur'],
      ['Barde', 'Paladin', 'Voleur', 'Ranger'],
      ['Clerc', 'Barbare', 'Ensorceleur', 'Warlock'],
      ['D20', 'Initiative', 'Jet critique', 'Echec critique'],
      ['Campagne', 'One-shot', 'Maître du jeu', 'Fiche perso'],
      ['Portail', 'Dimension', 'Prophétie', 'Malédiction'],
      ['Roi', 'Reine', 'Prince', 'Chevalier'],
      ['Tour sombre', 'Chateau', 'Foret enchantee', 'Marais maudit'],
      ['Familier', 'Chouette', 'Crapaud', 'Chat noir'],
      ['Mandragore', 'Saule cogneur', 'Detraqueur', 'Hippogriffe'],
      ['Troll des cavernes', 'Ent', 'Uruk-hai', 'Gobelin'],
      ['Anneau', 'Amulette', 'Talisman', 'Couronne'],
    ],
    jokes: [
      ['Ron Weasley', 'Ed Sheeran', 'troll'],
      ['Voldemort', 'Nez en option', 'troll'],
      ['Gandalf', 'Controleur de pont', 'soft_joke'],
      ['Frodon', 'Livreur de bijou anxieux', 'troll'],
      ['Draco Malefoy', 'Blond privilege', 'troll'],
      ['Balai magique', 'Uber sans siege', 'soft_joke'],
      ['Gollum', 'Influenceur bague', 'troll'],
      ['Bran Stark', 'Camera de surveillance medievale', 'troll'],
      ['Dumbledore', 'RH toxique de Poudlard', 'troll'],
      ['Legolas', 'Shampoing elfique', 'soft_joke'],
      ['Hagrid', 'SPA des monstres dangereux', 'soft_joke'],
      ['Quidditch', 'Sport ou les regles trichent', 'troll'],
    ],
  },
  cinema: {
    id: 'cinema',
    name: 'Cinema',
    description: 'Films, genres, scenes cultes et metiers du cinema.',
    icon: 'film',
    color: '#FFD166',
    groups: [
      ['Titanic', 'Avatar', 'Aliens', 'Terminator'],
      ['Star Wars', 'Star Trek', 'Dune', 'Blade Runner'],
      ['Matrix', 'Inception', 'Interstellar', 'Tenet'],
      ['Jurassic Park', 'King Kong', 'Godzilla', 'Jaws'],
      ['Harry Potter', 'Seigneur des Anneaux', 'Hobbit', 'Narnia'],
      ['Indiana Jones', 'Tomb Raider', 'Uncharted', 'La Momie'],
      ['James Bond', 'Jason Bourne', 'Mission Impossible', 'Kingsman'],
      ['Rocky', 'Creed', 'Raging Bull', 'Million Dollar Baby'],
      ['Le Parrain', 'Scarface', 'Les Affranchis', 'Casino'],
      ['Pulp Fiction', 'Kill Bill', 'Reservoir Dogs', 'Django Unchained'],
      ['Forrest Gump', 'Green Mile', 'Seul au monde', 'Philadelphia'],
      ['La La Land', 'Whiplash', 'Moulin Rouge', 'Chicago'],
      ['Shining', 'Scream', 'Halloween', 'Conjuring'],
      ['Alien', 'Predator', 'The Thing', 'Terminator'],
      ['Toy Story', 'Cars', 'Ratatouille', 'Wall-E'],
      ['Le Roi Lion', 'Aladdin', 'Mulan', 'La Belle et la Bete'],
      ['Intouchables', 'Bienvenue chez les Ch tis', 'Asterix Mission Cleopatre', 'Le Diner de cons'],
      ['Amelie Poulain', 'La Haine', 'Les Choristes', 'OSS 117'],
      ['Comedie', 'Drame', 'Thriller', 'Action'],
      ['Science-fiction', 'Fantasy', 'Horreur', 'Romance'],
      ['Realisation', 'Scenario', 'Montage', 'Cadrage'],
      ['Acteur', 'Realisateur', 'Producteur', 'Cascadeur'],
      ['Camera', 'Micro', 'Projecteur', 'Clap'],
      ['Bande-annonce', 'Affiche', 'Avant-premiere', 'Sortie nationale'],
      ['Oscar', 'Cesar', 'Palme d or', 'Golden Globe'],
      ['Popcorn', 'Nachos', 'Soda', 'Bonbons'],
      ['Salle obscure', 'Ecran geant', 'Siege rouge', 'Projection'],
      ['VF', 'VO', 'Sous-titres', 'Doublage'],
      ['Plan sequence', 'Travelling', 'Gros plan', 'Champ contrechamp'],
      ['Twist final', 'Cliffhanger', 'Flashback', 'Ellipse'],
      ['Hero', 'Vilain', 'Second role', 'Figurant'],
      ['Remake', 'Reboot', 'Suite', 'Prequel'],
      ['Saga', 'Trilogie', 'Spin-off', 'Cross-over'],
      ['Netflix', 'Disney+', 'Prime Video', 'Canal+'],
      ['Festival de Cannes', 'Mostra de Venise', 'Berlinale', 'Sundance'],
      ['Charlie Chaplin', 'Buster Keaton', 'Laurel et Hardy', 'Tati'],
      ['Spielberg', 'Nolan', 'Tarantino', 'Scorsese'],
      ['Kubrick', 'Hitchcock', 'Cameron', 'Ridley Scott'],
      ['DiCaprio', 'Brad Pitt', 'Tom Cruise', 'Denzel Washington'],
      ['Meryl Streep', 'Natalie Portman', 'Scarlett Johansson', 'Emma Stone'],
      ['Western', 'Peplum', 'Film noir', 'Biopic'],
      ['Court-metrage', 'Long-metrage', 'Documentaire', 'Animation'],
      ['Box-office', 'Critique presse', 'Note spectateur', 'Flop'],
      ['Scene culte', 'Replique culte', 'Musique culte', 'Costume culte'],
      ['Casting', 'Audition', 'Lecture de table', 'Improvisation'],
    ],
    jokes: [
      ['Twist final', 'Mensonge avec budget', 'soft_joke'],
    ],
  },
  personnalites_connues: {
    id: 'personnalites_connues',
    name: 'Personnalites connues',
    description: 'Stars, sportifs, artistes, figures publiques et icones.',
    icon: 'user',
    color: '#F7B2BD',
    groups: [
      ['Kylian Mbappe', 'Erling Haaland', 'Cristiano Ronaldo', 'Lionel Messi'],
      ['Zinedine Zidane', 'Ronaldinho', 'Neymar', 'Karim Benzema'],
      ['Michael Jordan', 'LeBron James', 'Kobe Bryant', 'Stephen Curry'],
      ['Serena Williams', 'Rafael Nadal', 'Roger Federer', 'Novak Djokovic'],
      ['Usain Bolt', 'Teddy Riner', 'Simone Biles', 'Tony Parker'],
      ['Beyonce', 'Rihanna', 'Adele', 'Taylor Swift'],
      ['Drake', 'Kanye West', 'Jay-Z', 'Eminem'],
      ['Aya Nakamura', 'Stromae', 'Orelsan', 'Damso'],
      ['Booba', 'Ninho', 'SCH', 'PNL'],
      ['Daft Punk', 'David Guetta', 'DJ Snake', 'Martin Solveig'],
      ['Leonardo DiCaprio', 'Brad Pitt', 'Tom Cruise', 'Will Smith'],
      ['Denzel Washington', 'Morgan Freeman', 'Samuel L Jackson', 'Jamie Foxx'],
      ['Zendaya', 'Timothee Chalamet', 'Ryan Gosling', 'Margot Robbie'],
      ['Marion Cotillard', 'Omar Sy', 'Jean Dujardin', 'Leila Bekhti'],
      ['Jamel Debbouze', 'Kev Adams', 'Gad Elmaleh', 'Florence Foresti'],
      ['Squeezie', 'Cyprien', 'Norman', 'Mister V'],
      ['Inoxtag', 'Michou', 'Mastu', 'AmineMaTue'],
      ['Gotaga', 'Kameto', 'ZeratoR', 'Domingo'],
      ['Elon Musk', 'Mark Zuckerberg', 'Bill Gates', 'Jeff Bezos'],
      ['Steve Jobs', 'Tim Cook', 'Sundar Pichai', 'Satya Nadella'],
      ['Barack Obama', 'Emmanuel Macron', 'Joe Biden', 'Angela Merkel'],
      ['Nelson Mandela', 'Martin Luther King', 'Gandhi', 'Malala'],
      ['Albert Einstein', 'Marie Curie', 'Isaac Newton', 'Nikola Tesla'],
      ['Leonard de Vinci', 'Picasso', 'Van Gogh', 'Frida Kahlo'],
      ['Moliere', 'Victor Hugo', 'Shakespeare', 'Jules Verne'],
      ['Cristina Cordula', 'Nabilla', 'Kim Kardashian', 'Kris Jenner'],
      ['Gordon Ramsay', 'Philippe Etchebest', 'Cyril Lignac', 'Mercotte'],
      ['Bear Grylls', 'Mike Horn', 'Nicolas Hulot', 'Yann Arthus-Bertrand'],
      ['Oprah Winfrey', 'Ellen DeGeneres', 'Jimmy Fallon', 'Stephen Colbert'],
      ['Greta Thunberg', 'Jane Goodall', 'David Attenborough', 'Hubert Reeves'],
      ['Banksy', 'JR', 'Keith Haring', 'Basquiat'],
      ['Michael Jackson', 'Prince', 'Madonna', 'Whitney Houston'],
      ['Elvis Presley', 'Freddie Mercury', 'David Bowie', 'John Lennon'],
      ['Ariana Grande', 'Billie Eilish', 'Dua Lipa', 'Lady Gaga'],
      ['The Weeknd', 'Bruno Mars', 'Justin Bieber', 'Ed Sheeran'],
      ['Hugh Jackman', 'Robert Downey Jr', 'Chris Evans', 'Chris Hemsworth'],
      ['Henry Cavill', 'Jason Momoa', 'Gal Gadot', 'Ben Affleck'],
      ['Greta Gerwig', 'Sofia Coppola', 'Kathryn Bigelow', 'Ava DuVernay'],
      ['Anne-Sophie Pic', 'Alain Ducasse', 'Paul Bocuse', 'Joel Robuchon'],
      ['Jean-Paul Gaultier', 'Karl Lagerfeld', 'Coco Chanel', 'Yves Saint Laurent'],
      ['Mbappe sourire', 'Haaland robot', 'Messi dribble', 'Ronaldo celebration'],
      ['Streamer', 'Youtubeur', 'Acteur', 'Chanteur'],
      ['Influenceur', 'Journaliste', 'Animateur', 'Humoriste'],
      ['Prix Nobel', 'Oscar', 'Ballon d Or', 'Grammy'],
      ['Tapis rouge', 'Interview', 'Conference', 'Autographe'],
    ],
    jokes: [
      ['Ronaldo celebration', 'Siuuu collectif', 'soft_joke'],
    ],
  },
  dessin_anime: {
    id: 'dessin_anime',
    name: 'Dessin anime',
    description: 'Cartoons, classiques TV, enfance et refs francophones.',
    icon: 'cartoon',
    color: '#FF70A6',
    groups: [
      ['Bob l eponge', 'Patrick', 'Carlo', 'Mr Krabs'],
      ['Sandy', 'Plancton', 'Gary', 'Madame Puff'],
      ['Tom', 'Jerry', 'Titi', 'Grosminet'],
      ['Bugs Bunny', 'Daffy Duck', 'Porky Pig', 'Elmer'],
      ['Scooby-Doo', 'Sammy', 'Vera', 'Daphné'],
      ['Fred', 'Daphné', 'Vera', 'Mystery Machine'],
      ['Les Simpson', 'Homer', 'Marge', 'Bart'],
      ['Lisa', 'Maggie', 'Moe', 'Flanders'],
      ['South Park', 'Cartman', 'Kenny', 'Stan'],
      ['Rick', 'Morty', 'Summer', 'Beth'],
      ['Mickey', 'Minnie', 'Donald', 'Dingo'],
      ['Picsou', 'Riri', 'Fifi', 'Loulou'],
      ['Winnie', 'Tigrou', 'Porcinet', 'Bourriquet'],
      ['Shrek', 'Ane', 'Fiona', 'Chat Potte'],
      ['Gru', 'Minion', 'Vector', 'Agnes'],
      ['Moi moche et mechant', 'Minions', 'Les Indestructibles', 'Megamind'],
      ['Les Indestructibles', 'Elastigirl', 'Violette', 'Dash'],
      ['Toy Story', 'Woody', 'Buzz', 'Jessie'],
      ['Ratatouille', 'Remy', 'Linguini', 'Colette'],
      ['Cars', 'Flash McQueen', 'Martin', 'Sally'],
      ['Nemo', 'Dory', 'Marin', 'Crush'],
      ['Monstres et Cie', 'Sully', 'Bob Razowski', 'Boo'],
      ['La Reine des Neiges', 'Elsa', 'Anna', 'Olaf'],
      ['Vaiana', 'Maui', 'Hei Hei', 'Te Fiti'],
      ['Mulan', 'Mushu', 'Shang', 'Cri-Kee'],
      ['Aladdin', 'Jasmine', 'Genie', 'Jafar'],
      ['Le Roi Lion', 'Simba', 'Nala', 'Scar'],
      ['Timon', 'Pumbaa', 'Zazu', 'Rafiki'],
      ['Totally Spies', 'Sam', 'Clover', 'Alex'],
      ['Martin Mystere', 'Diana', 'Java', 'MOM'],
      ['Code Lyoko', 'Odd', 'Ulrich', 'Yumi'],
      ['Aelita', 'Jeremy', 'XANA', 'Lyoko'],
      ['Oggy', 'Jack', 'Joey', 'Dee Dee'],
      ['Les Razmoket', 'Casse-Bonbon', 'La Binocle', 'Couette-Couette'],
      ['La Famille Pirate', 'Victor Mac Bernik', 'Lucile', 'Scampi'],
      ['Rapido', 'Razmo', 'Ramzy', 'Ratz'],
      ['Crocodile Famille Pirate', 'Crocodile One Piece', 'Captain Crochet', 'Capitaine Flam'],
      ['Franklin', 'Petit Ours Brun', 'Tchoupi', 'Oui-Oui'],
      ['Dora', 'Babouche', 'Chipeur', 'Diego'],
      ['Ben 10', 'Gwen', 'Kevin', 'Vilgax'],
      ['Avatar Aang', 'Katara', 'Sokka', 'Zuko'],
      ['Korra', 'Toph', 'Azula', 'Iroh'],
      ['Adventure Time', 'Finn', 'Jake', 'Princesse Chewing-gum'],
      ['Regular Show', 'Mordecai', 'Rigby', 'Benson'],
      ['Steven Universe', 'Garnet', 'Amethyst', 'Pearl'],
    ],
    jokes: [
      ['Rapido', 'Ramzy', 'troll'],
      ['Rapido', 'Razmo', 'normal'],
      ['Dora', 'GPS qui demande la route', 'troll'],
      ['Crocodile Famille Pirate', 'Crocodile One Piece', 'troll'],
    ],
  },
  pop_culture: {
    id: 'pop_culture',
    name: 'Pop culture',
    description: 'Memes, web, series, musiques, refs et melanges improbables.',
    icon: 'sparkle',
    color: '#7AE582',
    groups: [
      ['TikTok', 'Instagram', 'YouTube', 'Twitch'],
      ['Netflix', 'Disney+', 'Prime Video', 'Crunchyroll'],
      ['Meme', 'Template', 'Reaction GIF', 'Sticker'],
      ['POV', 'Storytime', 'Trend', 'Challenge'],
      ['Like', 'Follow', 'Subscribe', 'Share'],
      ['Influenceur', 'Streamer', 'Youtubeur', 'Tiktokeur'],
      ['Vlog', 'Podcast', 'Live', 'Short'],
      ['Hashtag', 'Caption', 'Bio', 'Thread'],
      ['Marvel', 'DC', 'Star Wars', 'Harry Potter'],
      ['Manga', 'Anime', 'Cartoon', 'Comics'],
      ['K-pop', 'Rap FR', 'Pop US', 'Afrobeats'],
      ['Concert', 'Festival', 'Showcase', 'Tournee'],
      ['Sneakers', 'Streetwear', 'Casquette', 'Hoodie'],
      ['Nike', 'Adidas', 'Jordan', 'New Balance'],
      ['Barbie', 'Oppenheimer', 'Wednesday', 'Stranger Things'],
      ['Squid Game', 'Casa de Papel', 'The Boys', 'Euphoria'],
      ['Game of Thrones', 'House of the Dragon', 'The Witcher', 'The Last of Us'],
      ['Among Us', 'Fortnite', 'Minecraft', 'Roblox'],
      ['Pokemon', 'Yu-Gi-Oh', 'Magic', 'Uno'],
      ['Emoji', 'GIF', 'Sticker', 'Bitmoji'],
      ['Red flag', 'Green flag', 'Ick', 'Crush'],
      ['Stan', 'Fanbase', 'Hater', 'Community manager'],
      ['Drama', 'Clash', 'Thread Twitter', 'Apology video'],
      ['Cancel culture', 'Bad buzz', 'Reputation', 'Comeback'],
      ['Cosplay', 'Convention', 'Comic Con', 'Japan Expo'],
      ['Goodies', 'Figurine', 'Poster', 'Collector'],
      ['Spoiler', 'Leak', 'Teaser', 'Trailer'],
      ['Canon', 'Fan theory', 'Retcon', 'Lore'],
      ['Crossover', 'Caméo', 'Multivers', 'Timeline'],
      ['Ship', 'OTP', 'Fanfic', 'Headcanon'],
      ['Playlist', 'Album', 'Single', 'Clip'],
      ['Autotune', 'Freestyle', 'Featuring', 'Remix'],
      ['Vinyle', 'CD', 'Streaming', 'Radio'],
      ['Buzz', 'Viral', 'Algorithme', 'For You Page'],
      ['Filtre', 'Transition', 'Montage', 'Slow motion'],
      ['Ring light', 'Micro cravate', 'Fond vert', 'Setup'],
      ['Unboxing', 'Haul', 'Review', 'Reaction'],
      ['Tier list', 'Iceberg', 'Blind test', 'Quiz'],
      ['Nostalgie', 'Gen Z', 'Millennial', 'Boomer'],
      ['MSN', 'Skyblog', 'Facebook', 'Snapchat'],
      ['Beyonce', 'Rihanna', 'Taylor Swift', 'Lady Gaga'],
      ['Squeezie', 'Mister V', 'Gotaga', 'Kameto'],
      ['Baby Yoda', 'Grogu', 'Mandalorian', 'Dark Vador'],
      ['Ron Weasley', 'Ed Sheeran', 'Rupert Grint', 'Ginger multiverse'],
      ['Sakura', 'Poubelle', 'Meme manga', 'Debat impossible'],
    ],
    jokes: [
      ['Red flag', 'Gyrophare sentimental', 'soft_joke'],
    ],
  },
};

function normalizeWord(value) {
  return value
    .normalize('NFD')
    .replace(/\p{Diacritic}/gu, '')
    .trim()
    .toLowerCase();
}

function addPair(
  pairs,
  seen,
  wordUses,
  graph,
  civilianWord,
  undercoverWord,
  style = 'normal',
) {
  if (!civilianWord || !undercoverWord || civilianWord === undercoverWord) return;
  const civilianKey = normalizeWord(civilianWord);
  const undercoverKey = normalizeWord(undercoverWord);
  if ((wordUses.get(civilianKey) ?? 0) >= maxWordUses) return;
  if ((wordUses.get(undercoverKey) ?? 0) >= maxWordUses) return;

  const civilianNeighbors = graph.get(civilianKey) ?? new Set();
  const undercoverNeighbors = graph.get(undercoverKey) ?? new Set();
  for (const neighbor of civilianNeighbors) {
    if (undercoverNeighbors.has(neighbor)) return;
  }

  const projectedUses = new Map(wordUses);
  projectedUses.set(civilianKey, (projectedUses.get(civilianKey) ?? 0) + 1);
  projectedUses.set(undercoverKey, (projectedUses.get(undercoverKey) ?? 0) + 1);
  const projectedUniqueWords = projectedUses.size;
  const projectedRepeatedWords = [...projectedUses.values()].filter(
    (count) => count > 1,
  ).length;
  if (projectedRepeatedWords / projectedUniqueWords > maxRepeatedWordRatio) {
    return;
  }

  const key = `${normalizeWord(civilianWord)}::${normalizeWord(undercoverWord)}`;
  const reverseKey = `${normalizeWord(undercoverWord)}::${normalizeWord(civilianWord)}`;
  if (seen.has(key) || seen.has(reverseKey)) return;
  seen.add(key);
  wordUses.set(civilianKey, (wordUses.get(civilianKey) ?? 0) + 1);
  wordUses.set(undercoverKey, (wordUses.get(undercoverKey) ?? 0) + 1);
  if (!graph.has(civilianKey)) graph.set(civilianKey, new Set());
  if (!graph.has(undercoverKey)) graph.set(undercoverKey, new Set());
  graph.get(civilianKey).add(undercoverKey);
  graph.get(undercoverKey).add(civilianKey);
  pairs.push({ civilianWord, undercoverWord, style });
}

function buildTheme(theme) {
  const pairs = [];
  const seen = new Set();
  const wordUses = new Map();
  const graph = new Map();

  for (const [civilianWord, undercoverWord, style] of theme.curatedPairs ?? []) {
    addPair(
      pairs,
      seen,
      wordUses,
      graph,
      civilianWord,
      undercoverWord,
      style ?? 'normal',
    );
  }

  for (const [civilianWord, undercoverWord, style] of theme.jokes ?? []) {
    addPair(pairs, seen, wordUses, graph, civilianWord, undercoverWord, style);
  }

  const addInternalPairs = () => {
    for (const group of theme.groups) {
      for (let i = 0; i < group.length - 1; i += 2) {
        addPair(pairs, seen, wordUses, graph, group[i], group[i + 1]);
      }
    }
  };

  addInternalPairs();

  const pairsWithCappedJokes = capJokes(pairs);
  const balancedPairs = trimRepeatedWords(pairsWithCappedJokes);

  return {
    id: theme.id,
    name: theme.name,
    description: theme.description,
    icon: theme.icon,
    color: theme.color,
    pairs: balancedPairs.slice(0, maxPairCount),
  };
}

function capJokes(pairs) {
  const normalPairs = pairs.filter((pair) => pair.style === 'normal');
  const jokePairs = pairs.filter((pair) => pair.style !== 'normal');
  const maxJokes = Math.floor(
    (normalPairs.length * maxJokeRatio) / (1 - maxJokeRatio),
  );
  const allowedJokes = new Set(jokePairs.slice(0, maxJokes));
  return pairs.filter((pair) => pair.style === 'normal' || allowedJokes.has(pair));
}

function trimRepeatedWords(pairs) {
  const balancedPairs = [...pairs];
  while (repeatedWordRatio(balancedPairs) > maxRepeatedWordRatio) {
    const uses = wordUseCounts(balancedPairs);
    const removableIndex = balancedPairs.findLastIndex(
      (pair) =>
        pair.style === 'normal' &&
        (uses.get(normalizeWord(pair.civilianWord)) ?? 0) > 1 &&
        (uses.get(normalizeWord(pair.undercoverWord)) ?? 0) > 1,
    );
    if (removableIndex === -1) break;
    balancedPairs.splice(removableIndex, 1);
  }
  return balancedPairs;
}

function wordUseCounts(pairs) {
  const uses = new Map();
  for (const pair of pairs) {
    for (const word of [pair.civilianWord, pair.undercoverWord]) {
      const key = normalizeWord(word);
      uses.set(key, (uses.get(key) ?? 0) + 1);
    }
  }
  return uses;
}

function repeatedWordRatio(pairs) {
  const uses = wordUseCounts(pairs);
  const repeatedWords = [...uses.values()].filter((count) => count > 1).length;
  return repeatedWords / uses.size;
}

let globalJokes = 0;
let globalPairCount = 0;
for (const id of themeOrder) {
  const theme = buildTheme(themes[id]);
  const themeJokes = theme.pairs.filter((pair) => pair.style !== 'normal').length;
  const themeJokeRatio = themeJokes / theme.pairs.length;
  if (themeJokeRatio > maxJokeRatio) {
    throw new Error(`${id} joke ratio must stay at or below 5%`);
  }
  globalJokes += themeJokes;
  globalPairCount += theme.pairs.length;
  writeFileSync(
    join(outputDir, `${id}.json`),
    `${JSON.stringify(theme, null, 2)}\n`,
  );
  console.log(`${id}: ${theme.pairs.length} pairs`);
}

const jokeRatio = globalJokes / globalPairCount;
console.log(`jokes: ${globalJokes}/${globalPairCount} (${(jokeRatio * 100).toFixed(2)}%)`);

if (jokeRatio > maxJokeRatio) {
  throw new Error('Joke ratio must stay at or below 5%');
}
