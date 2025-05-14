class Config {
  // Base URLs for different environments
  static const String _apiUrlDev = "http://192.168.1.19:3000"; // Development
  static const String _apiUrlProd = "https://votre-api-production.com"; // Production

  // Stripe Publishable Keys
  static const String _stripePublishableKeyDev =
      'pk_test_51RLKZj061cUZkWmHT9cche0aTrHno6ZBZ4VwpQpdf3VWIFHQxpzjNlUwsiJeXUjxPuhyltHG7k7dNrWgprEiGuOt00ZRaQxNe4'; // Test publishable key
  static const String _stripePublishableKeyProd =
      'pk_test_51RLKZj061cUZkWmHT9cche0aTrHno6ZBZ4VwpQpdf3VWIFHQxpzjNlUwsiJeXUjxPuhyltHG7k7dNrWgprEiGuOt00ZRaQxNe4'; // Replace with your live publishable key from Stripe Dashboard

  // Other configurations
  static const String apiVersion = "v1";
  static const String authEndpoint = "/auth";
  static const String uploadEndpoint = "/upload";
  static const String appointmentEndpoint = "/appointments";
  // openai api key
  static const String openRouterApiKey = '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';

  // Example API key
  static const String apiKey = "votre_clé_api_ici";

  // Environment check (development or production)
  static bool get isProduction => const bool.fromEnvironment('dart.vm.product');

  // Get API URL
  static String getApiUrl() {
    return isProduction ? _apiUrlProd : _apiUrlDev;
  }

  // Get Stripe Publishable Key
  static String getStripePublishableKey() {
    return isProduction ? _stripePublishableKeyProd : _stripePublishableKeyDev;
  }
  static const String supportPhoneNumber = "221785619115"; // Numéro de support
}
