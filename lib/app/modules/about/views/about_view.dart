

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salvage_app/app/modules/about/controllers/about_controller.dart';

class AboutView extends GetView<AboutController> {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('About', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          return ListView(
            children: controller.sections.map((section) {
              final isExpanded = controller.expanded[section] ?? false;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(section, style: const TextStyle(color: Colors.black)),
                    trailing: Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.black,
                    ),
                    onTap: () => controller.toggleSection(section),
                  ),
                  if (isExpanded) _buildCustomCard(section),
                  const Divider(color: Colors.black26),
                ],
              );
            }).toList(),
          );
        }),
      ),
    );
  }

  Widget _buildCustomCard(String section) {
    final cardData = controller.sectionCards[section];
    return Container(
      width: MediaQuery.of(Get.context!).size.width * 0.9, // 90% de la largeur de l'écran
      constraints: const BoxConstraints(maxHeight: 250), // Hauteur maximale pour éviter l'overflow
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView( // Gestion de l'overflow vertical
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              section,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            if (cardData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cardData['status'] ?? ''}',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${cardData['date'] ?? ''}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}