class Client {
  final String clientId;
  final String cin;
  final String nom;
  final String prenom;
  final String adr;
  final String numTelephone;
  final List<String> histClient;

  Client({
    required this.clientId,
    required this.cin,
    required this.nom,
    required this.prenom,
    required this.adr,
    required this.numTelephone,
    this.histClient = const [],
  });

  factory Client.fromMap(Map<String, dynamic> map, String id) {
    return Client(
      clientId: id,
      cin: map['cin'] ?? '',
      nom: map['nom'] ?? '',
      prenom: map['prenom'] ?? '',
      adr: map['adr'] ?? '',
      numTelephone: map['numTelephone'] ?? '',
      histClient: List<String>.from(map['histClient'] ?? []),
    );
  }

  Map<String, dynamic> toMap() => {
    'cin': cin,
    'nom': nom,
    'prenom': prenom,
    'adr': adr,
    'numTelephone': numTelephone,
    'histClient': histClient,
  };
}