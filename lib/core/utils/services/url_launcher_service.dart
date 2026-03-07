import 'package:url_launcher/url_launcher.dart';

class UrlLauncherService {

  // Opens the native dialer with the phone number pre-filled
  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'\s+\(\)-'), ''), // Clean the string
    );

    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // print('Could not launch dialer for $phoneNumber');
    }
  }

  /// Opens the default messaging app with a pre-filled message
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
    
      } else {
        print('Could not launch messaging app');
      }
    }
  }
}
