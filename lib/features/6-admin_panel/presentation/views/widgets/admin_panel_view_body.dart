import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/widgets/custom_listtile.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/manage_users_view.dart';
import 'package:shopak/generated/l10n.dart';

class AdminPanelViewBody extends StatelessWidget {
  const AdminPanelViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomListTile(
            title: S.of(context).manage_users,
            icon: Icons.admin_panel_settings_outlined,
            onTap: () {
              Navigator.of(context).pushNamed(ManageUsersView.routeName);
            },
          ),
          CustomListTile(
            title: S.of(context).manage_sellers,
            icon: Icons.admin_panel_settings_outlined,
            onTap: () {
              // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
            },
          ),
          CustomListTile(
            title: S.of(context).sellers_requests,
            icon: Icons.store_outlined,
            onTap: () {
              // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
            },
          ),
        ],
      ),
    );
  }
}
