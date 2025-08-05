// lib/widgets/filter_tabs.dart

import 'package:flutter/material.dart';

// ce widget c'est pour faire les boutons de filtre
// comme "tous" "à venir" "passés" pour les rendezvous
class FilterTabs extends StatelessWidget {
  // la liste de tous les filtre qu'on peut choisir
  final List<String> filters;
  // le filtre qui est sélectionné en ce moment
  final String currentFilter;
  // ce qui se passe quand on clic sur un filtre
  final Function(String) onFilterSelected;

  // ca c'est pour créer les onglets de filtre
  // on lui donne la liste des filtres le filtre actuel et la fonction à appele
  const FilterTabs({
    super.key,
    required this.filters,
    required this.currentFilter,
    required this.onFilterSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // pour pouvoir faire défiler les filtres s'il y en a trop
      scrollDirection: Axis.horizontal, // defil horizontalement
      child: Row(
        // on met les filtre cote à cote
        children: filters.map((filter) {
          // pour chaque filtre dans notre liste
          final bool isSelected = currentFilter ==
              filter; // vérifie si ce filtre est celui qui est choisi
          final String label = filter[0].toUpperCase() +
              filter.substring(
                  1); // on mets la première lettre en majuscule pour l'affichage

          return GestureDetector(
            // pour que chaque filtre soit cliquable
            onTap: () => onFilterSelected(
                filter), // quand on clique on appelle la fonction avec le filtre choisi
            child: Container(
              margin: const EdgeInsets.only(
                  right: 8), // un petit space entre les filtres
              padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8), // un peu d'espace à l'intérieur du bouton
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(
                        0xFF64B5F6) // si le filtre est choisi il a cette couleur
                    : Colors.white, // sinon il est blanc
                borderRadius:
                    BorderRadius.circular(20), // coin bien rond pour les bouton
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(0.05), // une légère ombre sous le bouton
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                label, // texte du filtre
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Colors
                          .black54, // text blanc si sélectionné sinon gris foncé
                  fontWeight: FontWeight.bold, // texte en gras
                ),
              ),
            ),
          );
        }).toList(), // on transforme tout ca en liste de widget
      ),
    );
  }
}
