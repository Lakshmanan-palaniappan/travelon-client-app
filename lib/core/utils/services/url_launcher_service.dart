import 'package:url_launcher/url_launcher.dart';

/// Service for launching native apps using device URL schemes.
///
/// Handles:
/// - Opening the phone dialer
/// - Opening the default messaging app
class UrlLauncherService {
  /// Opens the native phone dialer with the provided [phoneNumber].

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(
        RegExp(r'\s+\(\)-'),
        '',
      ), // Remove spaces and special characters from the phone number
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Device cannot handle phone call intent
    }
  }

  /// Opens the default SMS app with the provided [phoneNumber]
  /// and pre-filled [message].
  static Future<void> sendSMS(String phoneNumber, String message) async {
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{'body': message},
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      final String url =
          "smsto:$phoneNumber?body=${Uri.encodeComponent(message)}";
      if (await launchUrl(Uri.parse(url))) {
        // Fallback SMS scheme launched successfully
      } else {
        // Device does not support SMS launching
      }
    }
  }
}
