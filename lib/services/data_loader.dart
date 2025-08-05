// lib/services/data_service.dart

import 'dart:convert'; //lire les fichiers json
import 'package:flutter/services.dart'
    show rootBundle; // pour accéder aux fichiers de l'app
import '../models/patient.dart'; // on a besoin du modele patient
import '../models/rendezvous.dart'; // on a besoin du modele rendez-vous
import '../models/dossier.dart'; // on a besoin du modele dossier
import '../models/recommendations.dart'; // on a besoin du modele recommandations

// cette classe s'occupe de charger toutes nos donné
// elle va chercher les fichiers json dans les asset de l'app
class DataLoader {
  // cette fonction charge les infos du patient depuis le fichier patient.json
  Future<Patient> loadPatient() async {
    // on lit le contenu du fichier patient.json
    final String response = await rootBundle.loadString('assets/patient.json');
    // on transforme le texte du fichier en données utilisables
    final data = await json.decode(response);
    // et on crée un objet patient avec ces données
    return Patient.fromJson(data);
  }

  // cette fonction charge la liste des rendezvous depuis le fichier rendezvous.json
  Future<List<Rendezvous>> loadRendezvous() async {
    // on lit le contenu du fichier rendezvous.json
    final String response =
        await rootBundle.loadString('assets/rendezvous.json');
    // o transform le texte en une liste de données
    final List<dynamic> data = await json.decode(response);
    // et on crée une liste d'objet rendez-vous
    return data.map((json) => Rendezvous.fromJson(json)).toList();
  }

  // fonction qui charge les infos du dossier médical depuis le fichier dossier.json
  Future<Dossier> loadDossier() async {
    // on lit le contenu du fichier dossier.json
    final String response = await rootBundle.loadString('assets/dossier.json');
    // on transforme le texe en donnée utilisables
    final data = await json.decode(response);
    // et on crée un objet dossier avec ces données
    return Dossier.fromJson(data);
  }

  // cette fonction charge la liste des recommendations depuis le fichier recommendations.json
  Future<List<Recommendations>> loadRecommendations() async {
    // on lit le contenu du fichier recommendations.json
    final String response =
        await rootBundle.loadString('assets/recommendations.json');
    // on transforme le texte en une liste de données
    final List<dynamic> data = await json.decode(response);
    // et on crée une liste d'objets recommendation
    return data.map((json) => Recommendations.fromJson(json)).toList();
  }
}
