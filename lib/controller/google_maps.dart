import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openGoogleMaps({String? latitude, String? longitude}) async {
  final googleMapsUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
    await launchUrl(Uri.parse(googleMapsUrl));
  } else {
    Get.snackbar('Error', 'Tidak bisa membuka Google Maps',
        snackPosition: SnackPosition.BOTTOM);
  }
}
