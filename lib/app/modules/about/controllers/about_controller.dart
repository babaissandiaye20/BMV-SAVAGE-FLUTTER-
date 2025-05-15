import 'package:get/get.dart';

class AboutController extends GetxController {
  final expanded = <String, bool>{}.obs;

  final sections = [
    'About the App',
    'Developed by',
    'Legal Notices',
    'Contact',
  ];

  final sectionCards = {
    'About the App': {
      'status': 'Manage salvage inspections',
      'date': 'Ohio DMV – since 2024',
      'success': true,
    },
    'Developed by': {
      'status': 'XYZ Corp',
      'date': 'Flutter / Firebase',
    },
    'Legal Notices': {
      'status': 'Complies with Ohio Law',
      'date': 'Last updated 2025',
    },
    'Contact': {
      'status': 'support@xyz.com',
      'date': '+1 800 123 4567',
    },
  };

  @override
  void onInit() {
    for (var section in sections) {
      expanded[section] = false;
    }
    super.onInit();
  }

  void toggleSection(String section) {
    expanded[section] = !(expanded[section] ?? false);
  }
}
