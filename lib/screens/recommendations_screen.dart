// lib/screens/recommandations_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portail_patient/models/recommendations.dart';
import 'package:portail_patient/services/data_loader.dart';
import 'package:portail_patient/widgets/health_tip_card.dart';
import 'package:portail_patient/widgets/filter_tabs.dart';

// cet écran c'est là où on voit toutes les recommendations santé
// on peut les filtrer par catégorie
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  // ca garde en mémoire le filtre qu'on a choisi par exemple "tous" ou "nutrition"
  String _currentFilter = 'Tous';
  // cette liste va contenir toutes les catégories de recommendations disponibles
  List<String> _categories = ['Tous'];

  @override
  void initState() {
    super.initState();
    // quand l'écran s'ouvre on charge les catégories de recommendations
    _loadCategories();
  }

  // cette fonction va chercher toutes les catégories de recommendations
  void _loadCategories() async {
    // on récupère le truc qui charge nos données
    final dataLoader = Provider.of<DataLoader>(context, listen: false);
    // on charge toutes les recommendations
    final recommendations = await dataLoader.loadRecommendations();
    // on extrait toutes les catégories uniques et on les met dans une liste
    final categories = recommendations.map((r) => r.categorie).toSet().toList();
    categories.sort(); // on trie les catégorie par ordre alphabétique
    setState(() {
      // on met à jour la liste des catégories avec "tous" en premier
      _categories = ['Tous', ...categories];
    });
  }

  @override
  Widget build(BuildContext context) {
    // o récupère encore le chargeur de données
    final dataLoader = Provider.of<DataLoader>(context);
    // on récupe²re la hauteur de la barre du haut du téléphone
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // un fond gris très clair
      // on attend que les recommendations se chargent
      body: FutureBuilder<List<Recommendations>>(
        future: dataLoader.loadRecommendations(),
        builder: (context, snapshot) {
          // si ca charge on met une petite roue
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // s'il y a un souci on affiche l'erreur
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // si les données sont là on les utilise
            final allRecommendations = snapshot.data!;
            List<Recommendations> filteredRecommendations;

            // on filtre les recommandations selon le filtre choisi
            if (_currentFilter == 'Tous') {
              filteredRecommendations =
                  allRecommendations; // si c'est tous on prend tout
            } else {
              // sinon on garde seulement celles de la catégorie choisie
              filteredRecommendations = allRecommendations
                  .where((r) => r.categorie == _currentFilter)
                  .toList();
            }

            return Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // tout aligné à gauche
              children: [
                SizedBox(
                    height: statusBarHeight +
                        20), // un espace pour la barre du haut
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // un peu d'espace sur les côtés
                  child: Text(
                    'Recommandations Santé', // le titre de l'écran
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16), // un espace vertical
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0), // un peu d'espace sur les côtés
                  child: FilterTabs(
                    // ce widget permet de choisir les filtres catégories
                    filters: _categories, // la liste de toute les catégories
                    currentFilter:
                        _currentFilter, // le filtre actuellement sélectionnéé
                    onFilterSelected: (newFilter) {
                      // ce qui se passe quand on choisit un nouveau filtre
                      setState(() {
                        _currentFilter =
                            newFilter; // on met à jour le filtre et l'écran se rafraîchit
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20), // un espace vertical
                Expanded(
                  // pour que la liste prenne toute la place restante
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // un peu d'espace sur les côtés
                    itemCount: filteredRecommendations
                        .length, // autant d'éléments que de recommendations filtrées
                    itemBuilder: (context, index) {
                      final recommendations = filteredRecommendations[
                          index]; // une recommandation à la fois
                      return HealthTipCard(
                          recommendations:
                              recommendations); // on affiche chaque recommendation dans une carte spécial
                    },
                  ),
                ),
              ],
            );
          } else {
            // si aucune recommandation n'est trouvée
            return const Center(child: Text('Aucune recommandation trouvée.'));
          }
        },
      ),
    );
  }
}
