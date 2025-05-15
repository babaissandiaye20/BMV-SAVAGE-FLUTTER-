import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/theme/app_theme.dart';
import 'package:salvage_app/app/routes/app_pages.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int activeIndex;

  const CustomBottomNavBar({Key? key, this.activeIndex = 0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'label': 'Accueil'},
      {'icon': Icons.calendar_today_outlined, 'label': 'Rendez-vous'},
      {'icon': Icons.chat_bubble_outline, 'label': 'Chat'},
      {'icon': Icons.person_outline, 'label': 'Profil'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background, // Fond gris clair
        border: Border(top: BorderSide(color: AppColors.inputBackground)), // Bordure noire
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final Map<String, Object> item = items[index];
          final bool isActive = index == activeIndex;

          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  Get.offAllNamed(Routes.HOME);
                  break;
                case 1:
                  Get.toNamed(Routes.APPOINTMENT);
                  break;
                case 2:
                  Get.toNamed(Routes.CHAT);
                  break;
                case 3:
                  Get.toNamed(Routes.PROFILE);
                  break;

              }
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: isActive ? AppColors.primary : AppColors.secondary, // Rouge si actif, noir sinon
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? AppColors.primary : AppColors.secondary,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
