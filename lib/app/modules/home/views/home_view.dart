import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/widgets/custom_action_card.dart';
import 'package:salvage_app/app/widgets/appointment_card.dart';
import 'package:salvage_app/app/widgets/custom_bottom_nav_bar.dart';
import 'package:salvage_app/app/widgets/custom_toast.dart';
import 'package:salvage_app/app/routes/app_pages.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

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
            Expanded(child: _buildAppointmentHistory()),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(activeIndex: 0),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          CustomToast.showSuccess(context, "Chat ouvert");
        },
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/logorb.png', height: 48),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ohio Vehicle',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    'Inspection Scheduler',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 28),
            onPressed: () {
              CustomToast.showError(context, "Aucune nouvelle notification");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMainActionCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CustomActionCard(
            icon: Icons.upload_file,
            label: 'Téléverser',
            background: AppColors.primary,
            iconColor: Colors.white,
            textColor: Colors.white,
            onTap: () {
              Get.toNamed(Routes.UPLOAD_DOCUMENTS);
            },
          ),
          CustomActionCard(
            icon: Icons.calendar_today,
            label: 'Rendez-vous',
            background: AppColors.secondary,
            iconColor: Colors.black,
            textColor: Colors.black,
            onTap: () {
              CustomToast.showSuccess(context, "Navigation vers Rendez-vous");
              // TODO: Naviguer vers la page de planification
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentHistory() {
    final appointments = [
      {"status": "Complété", "date": "2025-04-25 14:30", "success": true},
      {"status": "Échoué", "date": "2025-04-20 10:00", "success": false},
      {"status": "En attente", "date": "2025-05-05 09:00", "success": null},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Historique des rendez-vous',
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
              separatorBuilder: (_, __) => const SizedBox(height: 12),
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
    );
  }
}
