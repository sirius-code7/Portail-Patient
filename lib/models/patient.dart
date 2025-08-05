// lib/models/patient.dart

// ce fichier c'est la carte d'identité du patient
// il dit qui est le patient et ce qu'on sait de lui
class Patient {
  // prenom
  final String prenom;
  // som de famille
  final String nom;
  // mail
  final String email;
  // date de naissance
  final String dateNaissance;

  // ca c'est pour créer un nouveau patient
  // on lui donne toutes les infos direct
  Patient({
    required this.prenom,
    required this.nom,
    required this.email,
    required this.dateNaissance,
  });

  // cette partie c'est pour transformer les données du fichier json
  // en un patient que l'app peut utiliser
  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      // on prend le prenom du json
      prenom: json['prenom'] as String,
      // le nom aussi
      nom: json['nom'] as String,
      // et l'email
      email: json['email'] as String,
      // et la date de naissance
      dateNaissance: json['date_naissance'] as String,
    );
  }
}
