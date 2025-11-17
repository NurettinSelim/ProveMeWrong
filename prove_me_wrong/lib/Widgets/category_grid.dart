import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key});

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  Set<int> selectedIndices = {};
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
      ),
      itemCount: Categories.values.length,
      itemBuilder: (context, index) {
        bool isSelected = selectedIndices.contains(index);
        return InkWell(
          onTap: () {
            if (isSelected) {
              selectedIndices.remove(index);
            } else {
              selectedIndices.add(index);
            }
            setState(() {});
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.secondary),
              color: isSelected ? AppColors.tertiary : null,
            ),
            child: Text(
              Categories.values[index].value,
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
