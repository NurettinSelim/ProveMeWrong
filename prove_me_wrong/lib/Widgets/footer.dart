import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prove_me_wrong/core/data/screens_data.dart';
import 'package:prove_me_wrong/core/theme/app_theme.dart';
import 'package:prove_me_wrong/widgets/create_room.dart';

class Footer extends ConsumerStatefulWidget {
  const Footer({super.key});

  @override
  ConsumerState<Footer> createState() => _FooterState();
}

class _FooterState extends ConsumerState<Footer> {
  int selectedIndex = 0;

  final items = [
    {
      "icon": Icons.home,
      "label": "Main Page",
      "targetScreen": Screens.homeScreen,
    },
    {
      "icon": Icons.chat_bubble_outline,
      "label": "Rooms",
      "targetScreen": Screens.roomsScreen,
    },
    {
      "icon": Icons.add,
      "label": "Create Room",
      "targetScreen": null,
      "isModal": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenNotifier = ref.read(screenProvider.notifier);
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.onPrimary,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.secondary),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 41, 41, 41),
            blurRadius: 20,
            spreadRadius: 0,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final Map item = items[index];
          bool isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              if (item["isModal"] == true) {
                // Modal açılmadan önce mevcut index'i koru
                showModalBottomSheet(
                  context: context,
                  builder: (context) => CreateRoom(),
                ).then((_) {
                  // Modal kapandığında state'i yenile (gerekirse)
                  setState(() {});
                });
              } else {
                setState(() {
                  selectedIndex = index;
                  if (item["targetScreen"] != null) {
                    screenNotifier.state = item["targetScreen"];
                  }
                });
              }
            },

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
    );
  }
}
