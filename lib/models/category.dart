

import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor =  Color(0xFFFFFFFF);

  bool isSelected;

  CategoryModel({
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];
      categories.add(CategoryModel(
      name: 'Rendez-vous',
      iconPath: 'assets/icons8-appointment-48.png',
      // Example route to navigate to
    ));
    categories.add(CategoryModel(
      name: 'Notification',
      iconPath: 'assets/icons8-notification-96.png',
      
    ));
    categories.add(CategoryModel(
      name: 'Exam Tension',
      iconPath: 'assets/icons8-hypertension-96.png',
      ));
    categories.add(CategoryModel(
      name: 'Activity',
      iconPath: 'assets/icons8-walking.gif',
         ));
    categories.add(CategoryModel(
      name: 'Chat',
      iconPath: 'assets/icons8-chat-96.png',
    ));
    categories.add(CategoryModel(
      name: 'Medicament',
      iconPath: 'assets/heartbeat.gif',
         ));
        return categories;
  }
}
