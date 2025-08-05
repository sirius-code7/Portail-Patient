// lib/models/rendezvous.dart

// ce fichier c'est pour gérer les rendez-vous du patient
class Rendezvous {
  // chaque rdv a un id unique
  final String id;
  // le nom du docteur qu'on va voir
  final String medecin;
  // sa spécialité genre dermatologue ou cardiologue
  final String specialite;
  // la date et l'heure du rdv
  final String date;
  // l'endroit
  final String lieu;
  //  "à venir" ou "passé"
  final String statut;

  // ca c'est pour créer un nouveau rendez-vous
  Rendezvous({
    required this.id,
    required this.medecin,
    required this.specialite,
    required this.date,
    required this.lieu,
    required this.statut,
  });

  // transformer les données du fichier json
  factory Rendezvous.fromJson(Map<String, dynamic> json) {
    return Rendezvous(
      // on prend l'id du json
      id: json['id'] as String,
      // le médecin
      medecin: json['medecin'] as String,
      //  spécialité
      specialite: json['specialite'] as String,
      // la date
      date: json['date'] as String,
      // le lieu
      lieu: json['lieu'] as String,
      // et le statut
      statut: json['statut'] as String,
    );
  }
}
