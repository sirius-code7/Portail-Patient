// lib/widgets/dossier_section.dart

import 'package:flutter/material.dart';

// ce widget cune petite carte pour afficher une section du dossier médical
// genre les antécédents ou les allergies
class DossierSection extends StatelessWidget {
  // le titre de la section par exemple "antécédents médicaux
  final String title;
  // le texte en dessous du titre qui donne plus de détails
  final String subtitle;
  // l'icône à côté du titre
  final IconData icon;
  // quand on clic dessus
  final VoidCallback onTap;

  // ca c'est pour créer une nouvelle section de dossier
  // on lui donne le titre l'icône et ce qui se passe au click
  const DossierSection({
    super.key,
    required this.title,
    this.subtitle = '', // si pas de sous-titre on met une chaine vide
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // pour que la carte soit cliquable
      onTap: onTap, // la fonction à appeler quand on clic
      child: Container(
        margin: const EdgeInsets.only(
            bottom: 12), // un petit espace en bas de chaque carte
        padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical:
                40), // on augmente le padding vertical pour que la carte soit plus haute
        decoration: BoxDecoration(
          color: Colors.white, // fond blanc pour la carte
          borderRadius: BorderRadius.circular(16), // on arrondis les coin
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // une légère ombre
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // le texte et l'icône sont espacés
          children: [
            Expanded(
              // pour que le texte prenne toute la place
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start, // tout aligné à gauche
                children: [
                  Text(
                    title, // le titre de la section
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold), // texte en gras
                  ),
                  if (subtitle
                      .isNotEmpty) // si le sous-titre n'est pas vide on l'affiche
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 4.0), // un petit espace au-dessus du sous-titre
                      child: Text(
                        subtitle, // soustitre
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color:
                                Colors.black54), // texte gris un peu plus petit
                        overflow: TextOverflow
                            .ellipsis, // si le texte est trop long on met "..."
                        maxLines:
                            2, // le texte peut s'étaler sur 2 lignes maximum
                      ),
                    ),
                ],
              ),
            ),
            Icon(icon, color: Colors.blue), // l'icône en blue
          ],
        ),
      ),
    );
  }
}
