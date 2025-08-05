// lib/models/dossier.dart

// c'est le plan pour organiser le dossier médical du patient
// en gros ça dit ce qu'on va trouver dedans
class Dossier {
  // ici on garde la liste de tous les antécédents médicaux du patient.
  // genre les maladies qu'il a déjà eues.
  final List<String> antecedents;
  // là c'est pour toutes les allergies connues.
  final List<String> allergies;
  // et ça c'est la liste des médocs que le patient prend en ce moment
  final List<String> traitementsEnCours;

  // ca c'est pour créer un nouveau dossier
  // on lui donne directement les listes d'antécédents, d'allergies et de traitements
  Dossier({
    required this.antecedents,
    required this.allergies,
    required this.traitementsEnCours,
  });

  //  on prend des données qui viennent d'un fichier JSON (comme une petite base de données locale)
  // et les transforme en un objet 'Dossier' que l'app flutter peut comprendre et utiliser
  factory Dossier.fromJson(Map<String, dynamic> json) {
    return Dossier(
      // on récupère la liste des antécédents du JSON.
      antecedents: List<String>.from(json['antecedents'] as List),
      // pareil pour les allergies
      allergies: List<String>.from(json['allergies'] as List),
      // et enfin, les traitements en cours
      traitementsEnCours:
          List<String>.from(json['traitements_en_cours'] as List),
    );
  }
}
