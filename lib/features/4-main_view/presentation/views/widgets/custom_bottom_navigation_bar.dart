import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/features/4-main_view/domain/entities/bottom_navigation_bar_entity.dart';
import 'package:shopak/features/4-main_view/presentation/views/widgets/navigation_bar_item.dart';
import 'package:shopak/generated/l10n.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.itemIndex,
    required this.userRole,
  });
  final ValueChanged<int> itemIndex;
  final String userRole;

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarEntity> bottomNavigationBarEntities = [
      BottomNavigationBarEntity(
        name: S.of(context).home,
        activeImage: Assets.imagesHomeActive,
        inActiveImage: Assets.imagesHome,
      ),
      BottomNavigationBarEntity(
        name: S.of(context).products,
        activeImage: Assets.imagesProductActive,
        inActiveImage: Assets.imagesProduct,
      ),
      BottomNavigationBarEntity(
        name: S.of(context).shopping_cart,
        activeImage: Assets.imagesShoppingCartActive,
        inActiveImage: Assets.imagesShoppingCart,
      ),
      if (widget.userRole == 'admin')
        BottomNavigationBarEntity(
          name: S.of(context).admin_panel,
          activeImage: Assets.imagesAdminActive,
          inActiveImage: Assets.imagesAdmin,
        ),
      BottomNavigationBarEntity(
        name: S.of(context).profile,
        activeImage: Assets.imagesProfileActive,
        inActiveImage: Assets.imagesProfile,
      ),
    ];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeIn,
      height: 80,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: ShapeDecoration(
        color: Theme.of(context).colorScheme.onSecondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        shadows: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 25,
            offset: const Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children:
            bottomNavigationBarEntities.asMap().entries.map((e) {
              var index = e.key;
              var entity = e.value;
              return Expanded(
                // flex: selectedIndex == index ? 3 : 2,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      widget.itemIndex(index);
                    });
                  },
                  child: NavigationBarItem(
                    isSelected: selectedIndex == index,
                    bottomNavigationBarEntity: entity,
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
