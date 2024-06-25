import 'package:flutter/material.dart';

class CategoryModel2 {
  String name;
  String iconPath;
  Color boxColor = const Color.fromARGB(255, 158, 158, 158);

  bool isSelected;

  CategoryModel2({
    required this.name,
    required this.iconPath,
    this.isSelected = false,
  });

  static List<CategoryModel2> getCategories() {
    List<CategoryModel2> categories = [];

    categories.add(
      CategoryModel2(
        name: 'Capsule',
        iconPath: 'assets/pills.gif',
      ),
    );

    categories.add(CategoryModel2(
      name: 'Tablet',
      iconPath: 'assets/tablet.gif',
    ));

    categories.add(CategoryModel2(
      name: 'Liquid',
      iconPath: 'assets/liquid.gif',
    ));
     return categories;
  }
}
