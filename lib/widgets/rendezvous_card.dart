// lib/widgets/rendezvous_card.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // pour formate les dates joliment
import 'package:portail_patient/models/rendezvous.dart'; // besoin du modèle rendez-vous

// ce widget c'est une carte pour afficher un rendezvous
// chaque rendezvous a sa propre carte
class RendezvousCard extends StatelessWidget {
  // le rendezvous qu'on va afficher dans cette carte
  final Rendezvous rendezvous;

  // ca c'est pour créer une nouvelle carte de rendezvous
  // on lui donne directement le rendezvous à afficher
  const RendezvousCard({super.key, required this.rendezvous});

  @override
  Widget build(BuildContext context) {
    // on transforme la date du rendezvous pour qu'elle soit facile à lire
    final date = DateTime.parse(rendezvous.date);
    final formattedDate =
        DateFormat('dd MMMM yyyy, HH:mm', 'fr_FR').format(date);
    // on vérifie si le rendezvous est "à venir"
    final isUpcoming = rendezvous.statut == 'à venir';

    return Container(
      margin: const EdgeInsets.only(
          bottom: 16), // un petit espace en bas de chaque carte
      padding: const EdgeInsets.all(16), // un espace intérieur pour le contenu
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
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // les éléments sont espacés
            children: [
              Expanded(
                // pour que le contenu prenne la place restante
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor:
                          Color(0xFFF7F7F7), // couleur de fond de l'avatar
                      child: Icon(Icons.person,
                          color: Colors.black54), // icône de personne
                    ),
                    const SizedBox(width: 12), // un petit espace
                    Expanded(
                      // pour que le texte prenne la place restante
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start, // tout aligné à gauche
                        children: [
                          Text(
                            'Dr. ${rendezvous.medecin}', // le nom du médecin
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                    fontWeight:
                                        FontWeight.bold), // texte en gras
                          ),
                          Text(
                            '${rendezvous.specialite} • ${rendezvous.lieu}', // la spécialité et le lieu du rdv
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium, // texte normal
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                // le petit badge qui indique le statut du rdv
                padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4), // un peu d'espace à l'intérieur du badge
                decoration: BoxDecoration(
                  color: isUpcoming
                      ? Colors.green[100] // vert très clair si "à venir"
                      : Colors.grey[200], // gris clair si "passé"
                  borderRadius: BorderRadius.circular(12), // coins arrondis
                ),
                child: Text(
                  isUpcoming ? 'à venir' : 'passé', // le texte du badge
                  style: TextStyle(
                    color: isUpcoming
                        ? Colors.black87 // texte noir si "à venir"
                        : Colors.black54, // texte gris foncé si "passé"
                    fontWeight: FontWeight.bold, // texte en gras
                    fontSize: 12, // petite taille de police
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16), // un espace
          Container(
            // le bloc avec la date et l'heure du rdv
            padding: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8), // un peu d'espace à l'intérieur
            decoration: BoxDecoration(
              color: const Color(0xFF64B5F6), // couleur de fond bleue
              borderRadius: BorderRadius.circular(20), // coins bien ronds
            ),
            child: Row(
              mainAxisSize:
                  MainAxisSize.min, // le bloc prend juste la taille nécessair
              children: [
                const Icon(Icons.access_time,
                    size: 20, color: Colors.white), // icône d'horloge en blanc
                const SizedBox(width: 8), // un petit espace
                Text(
                  formattedDate, // la date et l'heure formatées
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, // texte blanc
                        fontWeight: FontWeight.bold, // texte en gras
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
