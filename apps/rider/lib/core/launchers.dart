import 'package:url_launcher/url_launcher.dart';

/// Opens turn-by-turn directions to [lat],[lng] in the Google Maps app
/// (falls back to the browser). Returns false when nothing could handle it.
Future<bool> openDirections({required double lat, required double lng, String? label}) async {
  // Universal link: opens the Google Maps app when installed, web otherwise.
  final web = Uri.parse(
    'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving',
  );
  final appScheme = Uri.parse('comgooglemaps://?daddr=$lat,$lng&directionsmode=driving');
  try {
    if (await canLaunchUrl(appScheme)) {
      return launchUrl(appScheme);
    }
    return launchUrl(web, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}

/// Starts a phone call to [phone]. Returns false when the dialer is missing.
Future<bool> callPhone(String phone) async {
  final cleaned = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (cleaned.isEmpty) return false;
  try {
    return await launchUrl(Uri(scheme: 'tel', path: cleaned));
  } catch (_) {
    return false;
  }
}
