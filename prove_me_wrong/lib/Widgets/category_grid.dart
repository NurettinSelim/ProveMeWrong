import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/data/category_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class CategoryGrid extends StatefulWidget {
  const CategoryGrid({super.key, required this.categoryList});
  final CategoryList categoryList;

  @override
  State<CategoryGrid> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 3,
        mainAxisExtent: 40,
      ),
      padding: EdgeInsets.zero,
      itemCount: Categories.values.length,
      itemBuilder: (context, index) {
        bool isSelected = widget.categoryList.categories.contains(
          Categories.values[index],
        );
        return InkWell(
          onTap: () {
            if (isSelected) {
              widget.categoryList.categories.remove(Categories.values[index]);
            } else {
              widget.categoryList.categories.add(Categories.values[index]);
            }
            widget.categoryList.listChanged = true;
            setState(() {});
          },
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.secondary),
              color: isSelected ? AppColors.tertiary : null,
            ),
            child: Text(
              Categories.values[index].value,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: "Azer29LT"),
            ),
          ),
        );
      },
    );
  }
}
