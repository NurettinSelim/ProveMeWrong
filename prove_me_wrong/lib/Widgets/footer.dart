import 'package:flutter/material.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int selectedIndex = 0;

  final items = [
    {"icon": Icons.home, "label": "Main Page"},
    {"icon": Icons.chat_bubble_outline, "label": "Rooms"},
    {"icon": Icons.add, "label": "Create Room"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0, left: 10, right: 10),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: AppColors.onPrimary,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AppColors.secondary),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () => setState(() => selectedIndex = index),
              child: AnimatedContainer(
                height: 36,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 0),
                decoration: isSelected
                    ? BoxDecoration(
                        color: AppColors.tertiary,
                        borderRadius: BorderRadius.circular(20),
                      )
                    : null,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item["icon"] as IconData,
                      size: 24,
                      color: isSelected
                          ? AppColors.primaryContainer
                          : Colors.black,
                    ),
                    if (isSelected) SizedBox(width: 6),
                    if (isSelected)
                      Text(
                        item["label"] as String,
                        style: TextStyle(
                          color: AppColors.primaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
