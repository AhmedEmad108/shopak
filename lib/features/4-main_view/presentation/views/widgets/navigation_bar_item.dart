import 'package:flutter/material.dart';
import 'package:shopak/features/4-main_view/domain/entities/bottom_navigation_bar_entity.dart';
import 'package:shopak/features/4-main_view/presentation/views/widgets/active_item.dart';
import 'package:shopak/features/4-main_view/presentation/views/widgets/in_active_item.dart';

class NavigationBarItem extends StatelessWidget {
  const NavigationBarItem({
    super.key,
    required this.isSelected,
    required this.bottomNavigationBarEntity,
  });
  final bool isSelected;
  final BottomNavigationBarEntity bottomNavigationBarEntity;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          // switchInCurve: Curves.linearToEaseOut,
          // switchOutCurve: Curves.fastOutSlowIn,
          child:
              isSelected
                  ? ActiveItem(
                    text: bottomNavigationBarEntity.name,
                    image: bottomNavigationBarEntity.activeImage,
                  )
                  : InActiveItem(
                    image: bottomNavigationBarEntity.inActiveImage,
                  ),
        ),
      ],
    );
  }
}
