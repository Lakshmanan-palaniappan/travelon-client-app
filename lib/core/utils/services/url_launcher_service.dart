import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {
  /// Opens the native dialer with the phone number pre-filled
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'\s+\(\)-'), ''), // Clean the string
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Handle the error (e.g., on a tablet with no dialer)
      print('Could not launch dialer for $phoneNumber');
    }
  }

  /// Opens the default messaging app with a pre-filled message
  static Future<void> sendSMS(String phoneNumber, String message) async {
    // Try 'smsto' which is often more reliable on Android
    final Uri launchUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{'body': message},
    );

    // On Android, sometimes the Uri construction above adds '+' or spaces
    // that break the 'sms' scheme. Try manual parsing if canLaunch fails.
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Fallback for Android using smsto:
      final String url =
          "smsto:$phoneNumber?body=${Uri.encodeComponent(message)}";
      if (await launchUrl(Uri.parse(url))) {
        // Success
      } else {
        print('Could not launch messaging app');
      }
    }
  }
}
