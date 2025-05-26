import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:salvage_app/app/modules/home/controllers/home_controller.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/widgets/custom_confirmation_modal.dart';
import 'package:salvage_app/app/widgets/home_card.dart';
import '../../../widgets/custom_bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});
  final controller = Get.put(HomeController());

  void _showWhatsAppConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => CustomConfirmationModal(
        title: 'Continue to WhatsApp?',
        description: 'You are about to leave the app to chat with our team on WhatsApp.\n\n'
            'This channel is reserved for support regarding your documents or appointments.',
        imageAssetPath: 'assets/images/whatsapp-icon.png',
        confirmText: 'Continue',
        cancelText: 'Cancel',
        onConfirm: () {
          Navigator.of(context).pop();
          controller.contactOnWhatsApp();
        },
        onCancel: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomToast.setContext(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open drawer if needed
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {
              CustomToast.showError(context, "No new notifications");
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.74,
          children: [
            HomeCard(
              title: 'Upload Documents',
              subtitle:
              "Scan or import your driver’s license, car title, and inspection receipt.",
              imagePath: 'assets/images/id_card.png',
              onTap: () => Get.toNamed(Routes.UPLOAD_DOCUMENTS),
            ),
            HomeCard(
              title: 'View Appointment',
              subtitle: "Check the details of your appointment",
              imagePath: 'assets/images/event_available.png',
              onTap: () => Get.toNamed(Routes.APPOINTMENT),
            ),
            HomeCard(
              title: 'Chat with Support',
              subtitle: "Get help via in-app live chat support",
              imagePath: 'assets/images/chat.png',
              onTap: () => Get.toNamed(Routes.CHAT),
            ),
            HomeCard(
              title: 'Profile',
              subtitle: "View and manage your account information",
              imagePath: 'assets/images/person-sharp.png',
              onTap: () => Get.toNamed(Routes.PROFILE),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showWhatsAppConfirmation(context),
        backgroundColor: Colors.green,
        child: Image.asset(
          'assets/images/whatsapp-icon.png',
          height: 32,
          width: 32,
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
    );
  }
}
