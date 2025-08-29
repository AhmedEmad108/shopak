import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/generated/l10n.dart';

class CustomManageUserHeader extends StatelessWidget {
  const CustomManageUserHeader({super.key, required this.mycontroller});
  final TextEditingController mycontroller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: mycontroller,
            hintText: S.of(context).search_users_by_name_or_email,
            labels: S.of(context).search_users,
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                if (mycontroller.text.isNotEmpty) {
                  mycontroller.clear();
                  context.read<AllUsersCubit>().searchUsers('');
                }
              },
            ),
            onChanged: (value) {
              context.read<AllUsersCubit>().searchUsers(value);
            },
          ),
        ),

        const SizedBox(width: 8),
        PopupMenuButton<String>(
          icon: const Icon(Icons.filter_list, size: 34),
          onSelected: (value) {
            switch (value) {
              case 'all':
                context.read<AllUsersCubit>().getAllUsers();
                break;
              case 'active':
                context.read<AllUsersCubit>().getActiveUsers();
                break;
              case 'inactive':
                context.read<AllUsersCubit>().getInactiveUsers();
                break;
            }
          },
          itemBuilder:
              (context) => [
                PopupMenuItem(
                  value: 'all',
                  child: Text(S.of(context).all_users),
                ),
                PopupMenuItem(
                  value: 'active',
                  child: Text(S.of(context).active_users),
                ),
                PopupMenuItem(
                  value: 'inactive',
                  child: Text(S.of(context).inactive_users),
                ),
              ],
        ),
      ],
    );
  }
}
