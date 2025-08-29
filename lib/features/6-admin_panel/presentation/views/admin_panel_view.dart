import 'package:flutter/material.dart';
import 'package:shopak/core/widgets/custom_appbar.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/admin_panel_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(context, title: S.of(context).admin_panel),
      body: AdminPanelViewBody(),
    );
  }
}
