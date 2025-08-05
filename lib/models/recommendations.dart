// lib/models/recommendations.dart

// ce fichier c'est pour nos conseils santé
class Recommendations {
  // un id
  final String id;
  // le titre du conseil
  final String titre;
  // une desc
  final String description;
  // une catégorie du conseil genre nutrition ou sport
  final String categorie;

  // ca c'est pour créer une nouvelle recomm
  Recommendations({
    required this.id,
    required this.titre,
    required this.description,
    required this.categorie,
  });

  // cette partie c'est pour transformer les données du fichier json
  factory Recommendations.fromJson(Map<String, dynamic> json) {
    return Recommendations(
      // on prend l'id du json
      id: json['id'] as String,
      // le titre aussi
      titre: json['titre'] as String,
      // et la desc
      description: json['description'] as String,
      // puisla catégorie
      categorie: json['categorie'] as String,
    );
  }
}
