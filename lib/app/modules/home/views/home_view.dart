import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_action_card.dart';
import 'package:salvage_app/app/widgets/appointment_card.dart';
import 'package:salvage_app/app/widgets/custom_bottom_nav_bar.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/routes/app_pages.dart';
import 'package:salvage_app/app/modules/home/controllers/home_controller.dart';
import 'package:salvage_app/app/widgets/custom_confirmation_modal.dart'; // Assure-toi d'importer le bon fichier

class HomeView extends StatelessWidget {
  HomeView({super.key});

  final controller = Get.put(HomeController());
  String? selectedOption;

  void _showPreAppointmentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomConfirmationModal(
        title: "Avant de continuer",
        description: "Est-ce un rendez-vous pour vous-même ?",
        radioOptions: ["Oui, c'est pour moi", "Non, pour quelqu’un d’autre"],
        selectedOption: selectedOption,
        onRadioChanged: (value) {
          selectedOption = value;
          Navigator.pop(context);
          _showPreAppointmentModal(context);
        },
        onConfirm: () {
          if (selectedOption != null) {
            Navigator.pop(context);
            Get.toNamed(Routes.CREATE_APPOINTMENT);
          } else {
            CustomToast.showError(context, "Veuillez sélectionner une option.");
          }
        },
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomToast.setContext(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            _buildHeader(context),
            const SizedBox(height: 32),
            _buildMainActionCards(context),
            const SizedBox(height: 32),
            _buildAppointmentHistory(),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Get.toNamed(Routes.CHAT);
        },
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/images/logorb.png', height: 48, color: Colors.white),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ohio Vehicle',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Inspection Scheduler',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.notifications_none_outlined,
                        size: 28,
                        color: AppColors.primary),
                    onPressed: () {
                      CustomToast.showError(context, "No new notifications");
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainActionCards(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: CustomActionCard(
                    icon: Icons.upload_file,
                    label: 'Upload',
                    background: AppColors.primary,
                    iconColor: Colors.white,
                    textColor: Colors.white,
                    onTap: () {
                      Get.toNamed(Routes.UPLOAD_DOCUMENTS);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomActionCard(
                    icon: Icons.calendar_today,
                    label: 'Appointment',
                    background: AppColors.secondary,
                    iconColor: Colors.black,
                    textColor: Colors.black,
                    onTap: () {
                      _showPreAppointmentModal(context); // Remplace la navigation directe
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: controller.contactOnWhatsApp,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 36,
                          height: 36,
                          child: Image.asset(
                            'assets/images/whatsapp.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Contact via WhatsApp',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentHistory() {
    final appointments = [
      {"status": "Completed", "date": "2025-04-25 14:30", "success": true},
      {"status": "Failed", "date": "2025-04-20 10:00", "success": false},
      {"status": "Pending", "date": "2025-05-05 09:00", "success": null},
    ];

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Appointment History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: appointments.length,
                  separatorBuilder: (_, __) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final item = appointments[index];
                    return AppointmentCard(
                      status: item["status"] as String,
                      date: item["date"] as String,
                      success: item["success"] as bool?,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
