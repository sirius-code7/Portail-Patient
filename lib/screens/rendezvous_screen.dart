// lib/screens/rendezvous_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portail_patient/models/rendezvous.dart';
import 'package:portail_patient/services/data_loader.dart';
import 'package:portail_patient/widgets/rendezvous_card.dart';
import 'package:portail_patient/widgets/filter_tabs.dart';

// cet écran c'est pour voir tous les rendez-vous du patient
// on peut filtrer les rendez-vous pour voir à venir ou ceux passés
class RendezvousScreen extends StatefulWidget {
  const RendezvousScreen({super.key});

  @override
  State<RendezvousScreen> createState() => _RendezvousScreenState();
}

class _RendezvousScreenState extends State<RendezvousScreen> {
  // ca garde en mémoire le filtre qu'on a choisi par exemple "tous ou "à venir
  String _currentFilter = 'tous';
  // cette liste contient les options de filtre pour les rendez-vous
  final List<String> _filters = ['tous', 'à venir', 'passés'];

  // pas de initState ici car le chargement est fait directement dans le build
  // et le filtre est géré par le setState dans onFilterSelected

  @override
  Widget build(BuildContext context) {
    // on récupère le truc qui charge nos données
    final dataLoader = Provider.of<DataLoader>(context);
    // on récupère la hauteur de la barre du haut du téléphone
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7), // un fond gris très clair
      // on attend que les rendez-vous se chargent
      body: FutureBuilder<List<Rendezvous>>(
        future: dataLoader
            .loadRendezvous(), // on charge les rendez-vous depuis le data loader
        builder: (context, snapshot) {
          // si ca charge on met une petite roue
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // s'il y a un souci on affiche l'erreur
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // si les données sont là on les utilise
            final allRendezvous = snapshot.data!;
            List<Rendezvous> filteredRendezvous;

            // on filtre les rendez-vous selon le filtre choisi
            if (_currentFilter == 'passés') {
              filteredRendezvous = allRendezvous
                  .where((rdv) => rdv.statut == 'passé')
                  .toList(); // on garde seulement les rendez-vous passés
            } else if (_currentFilter == 'à venir') {
              filteredRendezvous = allRendezvous
                  .where((rdv) => rdv.statut == 'à venir')
                  .toList(); // on garde seulement les rendez-vous à venir
            } else {
              filteredRendezvous =
                  allRendezvous; // si c'est "tous" on prend tout
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
                    'Mes Rendez-vous', // le titre de l'écran
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
                    // ce widget permet de choisir les filtre (les catégories de rendez-vous)
                    filters:
                        _filters, // la liste de toutes les options de filtre
                    currentFilter:
                        _currentFilter, // le filtre actuellement sélectionné
                    onFilterSelected: (newFilter) {
                      // ce qui se passe quand on choisit un nouveau filtre
                      setState(() {
                        _currentFilter =
                            newFilter; // on mets à jour le filtr et l'écran se rafraîchit
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20), // un espace vertical
                Expanded(
                  // pour que la list prenne toute la place restante
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0), // un peu d'espace sur les côtés
                    itemCount: filteredRendezvous
                        .length, // autant d'éléments que de rendez vous filtrés
                    itemBuilder: (context, index) {
                      final rendezvous =
                          filteredRendezvous[index]; // un rendezvous à la fois
                      return RendezvousCard(
                          rendezvous:
                              rendezvous); // on affiche chaque rendez-vous dans une carte spécial
                    },
                  ),
                ),
              ],
            );
          } else {
            // si aucun rendez-vous n'est trouvé
            return const Center(child: Text('Aucun rendez-vous trouvé.'));
          }
        },
      ),
    );
  }
}
