import 'package:flutter/material.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/widgets/stat_item.dart';

class CustomStatCard extends StatelessWidget {
  const CustomStatCard({
    super.key,
    required this.activeCount,
    required this.inactiveCount,
    required this.activeLabel,
    required this.inactiveLabel,
    this.addLabel,
    this.onTap,
    this.showAddButton = true,
  });

  final int activeCount;
  final int inactiveCount;
  final String activeLabel, inactiveLabel;
  final String? addLabel;
  final void Function()? onTap;
  final bool showAddButton;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            color: Theme.of(context).colorScheme.tertiary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                StatItem(
                  icon: Icons.check_circle_outline,
                  color: AppColor.green,
                  count: activeCount,
                  label: activeLabel,
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: AppColor.grey.withOpacity(0.3),
                ),
                StatItem(
                  icon: Icons.cancel_outlined,
                  color: AppColor.red,
                  count: inactiveCount,
                  label: inactiveLabel,
                ),
              ],
            ),
          ),
        ),
        if (showAddButton) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTap,
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              color: Theme.of(context).colorScheme.tertiary,
              child: StatItem(
                icon: Icons.add,
                color: AppColor.primaryColor,
                label: addLabel!,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
