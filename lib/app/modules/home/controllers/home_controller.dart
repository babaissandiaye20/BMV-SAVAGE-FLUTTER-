import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../config/config.dart';


class HomeController extends GetxController {
  final String phoneNumber = Config.supportPhoneNumber;

  Future<void> contactOnWhatsApp() async {
    final message = Uri.encodeComponent("Hello, can you please call me for service?");
    final url = 'https://wa.me/$phoneNumber?text=$message';
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("WhatsApp", "Unable to open WhatsApp. Please call: +$phoneNumber");
    }
  }
}
