import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_bottom_nav_bar.dart';
import 'package:salvage_app/app/widgets/custom_confirmation_modal.dart';

import '../controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 3),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            _buildMenuItem(Icons.person, 'Personal Details', onTap: () {
              // Get.toNamed(Routes.PERSONAL_DETAILS);
            }),
            _buildMenuItem(Icons.history, 'About', onTap: () {
              Get.toNamed(Routes.ABOUT);
            }),
            _buildMenuItem(Icons.help_outline, 'Help', onTap: () {}),
            _buildMenuItem(Icons.info_outline, 'Log out', onTap: () {
              showDialog(
                context: context,
                builder: (_) => CustomConfirmationModal(
                  title: "Log out?",
                  description: "You are about to log out of your account.\nDo you want to continue?",
                  imageAssetPath: 'assets/images/logout-icon.png', // Ajout de l'icône
                  onCancel: () => Get.back(),
                  onConfirm: () async {
                    Get.back(); // Ferme le dialog
                    await controller.logoutUser(); // Lance la déconnexion
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.black),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}