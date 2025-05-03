class Config {
  // URL de l'API pour le backend NestJS
  static const String baseUrl = "http://192.168.1.25:3000"; // Pour développement local

  // Autres configurations potentielles
  static const String apiVersion = "v1";
  static const String authEndpoint = "/auth";
  static const String uploadEndpoint = "/upload";
  static const String appointmentEndpoint = "/appointments";

  // Vous pouvez également configurer les environnements (par exemple, développement, production)
  static String getApiUrl() {
    return "$baseUrl";
  }

  // Exemple de configuration pour des clés API ou autre si nécessaire
  static const String apiKey = "votre_clé_api_ici";
}
