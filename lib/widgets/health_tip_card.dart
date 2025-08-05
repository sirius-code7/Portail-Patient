// lib/widgets/health_tip_card.dart

import 'package:flutter/material.dart';
import 'package:portail_patient/models/recommendations.dart'; // on a besoin du modèle recommendation

// ce widget c'est une carte pour afficher un conseil santé
// chaque conseil a son propre design ici
class HealthTipCard extends StatelessWidget {
  // la recommendation qu'on va afficher dans cette carte
  final Recommendations recommendations;

  // ca c'est pour créer une nouvelle carte de recommendation
  // on lui donne directement la recommendation à afficher
  const HealthTipCard({
    super.key,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 16), // un petit epace en bas de chaque carte
      padding: const EdgeInsets.all(16), // un space intérieur pour le contenu
      decoration: BoxDecoration(
        color: Colors.white, // fond blanc pour la carte
        borderRadius: BorderRadius.circular(16), // coins arrondis
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(0.05), // une légère ombre sous la carte
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // tout aligné à gauche
        children: [
          Text(
            recommendations.titre, // le titre du conseil
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.bold), // texte en gras
          ),
          const SizedBox(height: 8), // un petit espace
          Text(
            recommendations.description, // la desc du conseil
            style: Theme.of(context).textTheme.bodyMedium, // texte normal
          ),
          const SizedBox(height: 12), // space
          Align(
            alignment:
                Alignment.bottomRight, // on aligne la catégorie en bas à droite
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6), // un petit espace à l'intérieur du tag
              decoration: BoxDecoration(
                color: const Color(
                    0xFF64B5F6), // la couleur bleue pour le tag de catégorie
                borderRadius:
                    BorderRadius.circular(20), // des coin bien rond pour le tag
              ),
              child: Text(
                recommendations.categorie, // nom de la catégorie
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white, // texte blanc
                      fontWeight: FontWeight.bold, // texte en gras
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
