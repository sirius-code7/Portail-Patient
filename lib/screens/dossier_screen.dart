// lib/screens/dossier_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:portail_patient/models/dossier.dart';
import 'package:portail_patient/services/data_loader.dart';
import 'package:portail_patient/widgets/dossier_section.dart';

// cet écran c'est là où on voit le dossier médical du patient
// c'est un peu le résumé de sa santé
class DossierScreen extends StatelessWidget {
  const DossierScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // on récupère le truc qui charge nos données
    final dataLoader = Provider.of<DataLoader>(context);
    // on calcule la hauteur de la barre du haut du téléphone
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      // on attend que le dossier se charge
      body: FutureBuilder<Dossier>(
        future: dataLoader.loadDossier(),
        builder: (context, snapshot) {
          // si ça charge on met une petite roue
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // s'il y a un souci on affiche l'erreur
            return Center(child: Text('Erreur: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // si le dossier est là on l'affiche
            final dossier = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // on met un espace pour pas que le texte soit sous la barre du haut
                  SizedBox(height: statusBarHeight + 20),
                  // le titre de l'écran "Dossier Médical"
                  Text(
                    'Dossier Médical',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  // on utilise un widget spécial pour afficher chaque section du dossier
                  DossierSection(
                    title: 'Antécédents médicaux',
                    subtitle: dossier.antecedents
                        .join(', '), // on mets tous les antécédent bout à bout
                    icon: Icons.history_edu,
                    onTap: () {
                      // action quand on clique sur cette section
                    },
                  ),
                  DossierSection(
                    title: 'Allergies',
                    subtitle:
                        dossier.allergies.join(', '), // toutes les allergies
                    icon: Icons.medical_services,
                    onTap: () {
                      // action quand on clique sur cette section
                    },
                  ),
                  DossierSection(
                    title: 'Traitements en cours',
                    subtitle: dossier.traitementsEnCours
                        .join(', '), // tous les traitements
                    icon: Icons.medication,
                    onTap: () {
                      // action quand on clique sur cette section
                    },
                  ),
                  // autres................................................
                ],
              ),
            );
          } else {
            // si pas de dossier on dit qu'il n'y en a pas
            return const Center(child: Text('Aucun dossier médical trouvé.'));
          }
        },
      ),
    );
  }
}
