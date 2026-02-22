import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Opens the native dialer with the phone number pre-filled
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri uri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch dialer for $phoneNumber');
    }
  }

  /// Opens the default messaging app with a pre-filled message (SMS)
  static Future<void> sendSMS(String phoneNumber, String message) async {
    // Primary attempt: sms: URI (let Uri handle encoding)
    final Uri uri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message, // DO NOT pre-encode
      },
    );

    final bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (launched) {
      return;
    }

    // Fallback for devices that don't like the above format
    final Uri fallback = Uri.parse(
      "smsto:$phoneNumber?body=${Uri.encodeComponent(message)}",
    );

    final bool fallbackLaunched = await launchUrl(
      fallback,
      mode: LaunchMode.externalApplication,
    );

    if (!fallbackLaunched) {
      throw Exception('Could not launch messaging app');
    }
  }

  /// Opens WhatsApp chat with pre-filled message
  /// phoneNumber MUST be digits only: e.g. 919876543210 (no +, no spaces)
  static Future<void> openWhatsApp(String phoneNumber, String message) async {
    final String encodedMessage = Uri.encodeComponent(message);

    final Uri uri = Uri.parse(
      "https://wa.me/$phoneNumber?text=$encodedMessage",
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not open WhatsApp');
    }
  }
}