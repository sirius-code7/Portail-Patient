// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:portail_patient/models/patient.dart';
import 'package:portail_patient/models/rendezvous.dart';
import 'package:portail_patient/models/recommendations.dart';
import 'package:portail_patient/services/data_loader.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // on prépare pour charger les infos du patient plus tard
  late Future<Patient> _patientFuture;
  // our charger la liste des rendez-vous plus tard
  late Future<List<Rendezvous>> _rendezvousFuture;
  // pour charger la liste des recommandations plus tard
  late Future<List<Recommendations>> _recommendationsFuture;

  // ca c'est pour faire une petite animation quand l'écran apparaî
  late final AnimationController _controller = AnimationController(
    duration:
        const Duration(milliseconds: 1500), // l'animation dure 1.5 secondes
    vsync: this, // important pour l'animation
  )..forward(); // on lance

  // définir comment l'animation va se comporte
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn, // en douceur
  );

  @override
  void initState() {
    super.initState();
    // quand l'écran démarre on prépare le chargement des données
    final dataService = Provider.of<DataLoader>(context, listen: false);
    _patientFuture = dataService.loadPatient();
    _rendezvousFuture = dataService.loadRendezvous();
    _recommendationsFuture = dataService.loadRecommendations();
  }

  @override
  void dispose() {
    // quand on quitte l'écran on arrête l'animation
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // on récupère la hauteur de la barre de statut du téléphone
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F7F7), // une couleur de fond très claire
      body: SingleChildScrollView(
        // pour pouvoir faire défiler le contenu si besoin
        child: Padding(
          padding:
              const EdgeInsets.all(20.0), // un peu d'espace autour du contenu
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // tout est aligné à gauche
            children: [
              // on ajoute un espace en haut pour ne pas cacher le contenu sous la barre de statut
              SizedBox(height: statusBarHeight + 16),
              // on applique l'animation à en-tête
              FadeTransition(
                opacity: _animation,
                child:
                    _buildHeader(), // c'est la fonction qui construit l'en-tête
              ),
              const SizedBox(height: 24), // un espace vertical
              // le titre de la section "rendez-vous à venir" avec un bouton voir toutt
              _buildSectionHeader(
                  "Rendez-vous à venir",
                  "Voir tout",
                  () => context.go(
                      '/rendez-vous')), // click ca nous emmène à la page des rendez-vous
              const SizedBox(height: 12), // un petit espace
              _buildNextRendezvousCard(), // affiche le prochain rendez-vous
              const SizedBox(height: 24), // un autre espace
              // le titre de la section "recommandations du jour"
              _buildSectionHeader("Recommandations du jour"),
              const SizedBox(height: 12), // un petit espace
              _buildRecommendationsList(), // a liste des cartes de recommandations
            ],
          ),
        ),
      ),
    );
  }

  // cette fonction construit la partie supérieure de l'écran
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, //space entre les éléments pour aerer
      children: [
        _buildGreeting(), // le message de bienvenue au patient
        IconButton(
          icon: const Icon(Icons.notifications_none,
              color: Colors.black54), // l'icône de notification
          onPressed:
              () {}, // pour l'instant ca ne fait rien quand on clique dessus
        ),
      ],
    );
  }

  // cette fonction affiche un message de bienvenu personnalisé pour le patient
  Widget _buildGreeting() {
    return FutureBuilder<Patient>(
      future:
          _patientFuture, // on attend que les infos du patient soient chargées
      builder: (context, snapshot) {
        // si les données sont en cours de chargement on affiche une roue
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // s'il y a une erreur on l'affiche
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // si les données sont là on affiche le prénom et le nom du patient
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Salut, ${snapshot.data!.prenom} ${snapshot.data!.nom} 👋', // le message avec le nom du patient et un emoji cool 😁
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                'Comment va la santé !?', // une phrase d'accueil ça va de soi
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black54),
              ),
            ],
          );
        } else {
          // si on n'a pas encore de données on affiche "chargement"
          return const Text('Chargement...');
        }
      },
    );
  }

  // cette fonction crée un titre de section avec un bouton voir tout optionnel
  Widget _buildSectionHeader(String title,
      [String? action, VoidCallback? onTap]) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // le titre et le bouton sont espacés
      children: [
        Text(
          title, // le texte du titre de la section
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        // si un texte d'action et une fonction de clic sont fournis on affiche le bouton
        if (action != null && onTap != null)
          GestureDetector(
            onTap: onTap, // la fonction à exécuter quand on clique
            child: Text(
              action, // le texte du bouton d'action
              style: TextStyle(
                color: Theme.of(context)
                    .primaryColor, // la couleur principale de l'app
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  // cette fonction construit la carte du prochain rendez-vous
  Widget _buildNextRendezvousCard() {
    return FutureBuilder<List<Rendezvous>>(
      future: _rendezvousFuture, // on attend la liste des rendez-vous
      builder: (context, snapshot) {
        // si ca charge on met une roue
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // s'il y a une erreur on l'affiche
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // on cherche le premier rendez-vous qui est à venir
          final nextRendezvous = snapshot.data!
              .where((rdv) => rdv.statut == 'à venir')
              .firstOrNull;

          if (nextRendezvous != null) {
            // on convertit la date et on formate
            final date = DateTime.parse(nextRendezvous.date);
            final formattedDate =
                DateFormat('dd MMMM yyyy, HH:mm', 'fr_FR').format(date);

            return Container(
              padding: const EdgeInsets.all(16), // un espace intérieur
              decoration: BoxDecoration(
                color: const Color(
                    0xFF64B5F0), // une couleur de fond pour la carte
                borderRadius: BorderRadius.circular(16), // des coins arrondi
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withAlpha((0.05 * 255).round()), // ombre
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // tout aligné à gauche
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person,
                            color: Colors
                                .black54), // icône de personne pour le médecin
                      ),
                      const SizedBox(width: 12), // un petit espace
                      Expanded(
                        // pour que le texte prenne la place restante
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' ${nextRendezvous.medecin}', // le nom du médecin
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white), // texte en blanc et gras
                            ),
                            Text(
                              '${nextRendezvous.specialite} • ${nextRendezvous.lieu}', // la spécialité et le lieu
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors
                                          .white70), // texte en blanc un peu transparent et gras
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // un espace
                  Container(
                    // bloc avec la date et l'heure
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white, // fond blanc pour le bloc date
                      borderRadius: BorderRadius.circular(20), // coins ronds
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize
                          .min, // le bloc prend juste la taille nécessaire
                      children: [
                        const Icon(Icons.access_time,
                            size: 20, color: Colors.black54), // icône d'horloge
                        const SizedBox(width: 8), // un petit espace
                        Text(
                          formattedDate, // la date et l'heure formaté
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            // si aucun rendez-vous à venir n'est trouvé
            return const Text('Aucun rendez-vous à venir trouvé.');
          }
        } else {
          // si la liste des rendez-vous est vide
          return const Text('Aucun rendez-vous trouvé.');
        }
      },
    );
  }

  // cette fonction construit la liste des cartes de recommendations
  Widget _buildRecommendationsList() {
    return FutureBuilder<List<Recommendations>>(
      future: _recommendationsFuture, // on attend la liste des recommendation
      builder: (context, snapshot) {
        // si les données sont en cours de chargement on affiche une roue
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // s'il y a une erreur on l'affiche
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return SizedBox(
            height:
                280, // la hauteur de la zone où sont les cartes de recommendations
            child: ListView.builder(
              scrollDirection:
                  Axis.horizontal, // les cartes défilent horizontalement
              padding: const EdgeInsets.only(
                  right: 20.0), // un peu d'espace à droite
              itemCount: snapshot.data!
                  .length, // on crée autant de cartes qu'il y a de recommendations
              itemBuilder: (context, index) {
                final recommendation = snapshot
                    .data![index]; // on prend une recommendation à la fois

                // on choisit l'image à afficher en fonction de la catégorie et du titre de la recommendation
                Widget imageWidget;
                if (recommendation.categorie == 'Nutrition' &&
                    recommendation.titre ==
                        "Hydratation : Pensez à boire de l'eau") {
                  imageWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(
                        12), // bords arrondis pour l'image
                    child: Image.asset(
                      'assets/images/hydration_water_glass.png', // notre image du verre d'eau
                      fit: BoxFit
                          .contain, // pour que l'image soit visible en entier
                      height: 100, // hauteur de l'image
                      width: double
                          .infinity, // l'image prend toute la largeur disponible
                      errorBuilder: (context, error, stackTrace) {
                        // si l'image ne charge pas on affiche une icône d'erreur
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 40),
                          ),
                        );
                      },
                    ),
                  );
                } else if (recommendation.categorie == 'Activité physique' &&
                    recommendation.titre == "Marchez 30 minutes par jour") {
                  imageWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/walking-man.png', // notre image
                      fit: BoxFit
                          .contain, // pour que l'image soit visible en entier
                      height: 100,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 40),
                          ),
                        );
                      },
                    ),
                  );
                } else if (recommendation.categorie == 'Sommeil' &&
                    recommendation.titre == "7h de sommeil, c'est l'idéal") {
                  imageWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/sleeping.png', // notre image de la lune pour le sommeil
                      fit: BoxFit.contain, // visibité
                      height: 100,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 40),
                          ),
                        );
                      },
                    ),
                  );
                } else if (recommendation.categorie == 'Nutrition' &&
                    recommendation.titre == "Préparez vos repas à l'avance") {
                  imageWidget = ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/cereal.png', // notre image de la préparation de repas
                      fit: BoxFit.contain, // visible en entier
                      height: 100,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child:
                                Icon(Icons.error, color: Colors.red, size: 40),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  // si on n'a pas d'image spécifique pour cette recommendations on met une image par défaut
                  imageWidget = Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.image, color: Colors.grey, size: 40),
                    ),
                  );
                }

                return Container(
                  width: MediaQuery.of(context).size.width *
                      0.80, // la largeur de chaque carte (80% de l'écran)
                  margin: const EdgeInsets.only(
                      right: 16), // un espace entre les carte
                  decoration: BoxDecoration(
                    color: Colors.white, // fond blanc pour la carte
                    borderRadius: BorderRadius.circular(16), // coin arrondis
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(
                            (0.1 * 255).round()), // legere ombre sous la carte
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(
                        10.0), // un peu d'espace à l'intérieur de la carte
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // tout aligné à gauche
                      children: [
                        imageWidget, // on affiche l'image qu'on a choisie pour la recommandation
                        const SizedBox(height: 8), // un petit espace
                        Text(
                          '#${index + 1} ${recommendation.categorie}', // le numéro et la catégorie de la recomm
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .primaryColor, // la couleur principale de l'app
                          ),
                        ),
                        const SizedBox(height: 4), // espace
                        Text(
                          recommendation.titre, // le titre du conseil
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 2, // le titre ne dépasse pas 2 lignes
                          overflow: TextOverflow
                              .ellipsis, // si c'est trop long on met "..."
                        ),
                        const SizedBox(height: 4), // un petit espace
                        Text(
                          recommendation.description, // la description
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                  color: Colors
                                      .black54), // texte gris un peu plus petit
                          maxLines: 3, // la description ne dépasse pas 3 lignes
                          overflow: TextOverflow
                              .ellipsis, // si c'est trop long on met "..."
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          // si la liste des recommandations est vide
          return const Text('Aucune recommandation trouvée.');
        }
      },
    );
  }
}
