import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/widgets/custom_no_data_widgets.dart';
import 'package:shopak/core/widgets/custom_stat_card.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/details_user_view.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/widgets/custom_manage_user_header.dart';
import 'package:shopak/features/6-admin_panel/presentation/views/widgets/manage_users/widgets/custom_user_item.dart';
import 'package:shopak/generated/l10n.dart';

class ManageUsersViewBody extends StatefulWidget {
  const ManageUsersViewBody({
    super.key,
    required this.users,
    required this.activeCount,
    required this.inactiveCount,
    this.view = true,
  });

  final List<UserEntity> users;
  final int activeCount;
  final int inactiveCount;
  final bool view;

  @override
  State<ManageUsersViewBody> createState() => _ManageUsersViewBodyState();
}

class _ManageUsersViewBodyState extends State<ManageUsersViewBody> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var itemWidth = MediaQuery.of(context).size.width - 32;

    return RefreshIndicator(
      color: AppColor.primaryColor,
      onRefresh: () => context.read<AllUsersCubit>().refresh(),

      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  newMethod(context),
                  // CustomManageUserHeader(mycontroller: searchController),
                  SizedBox(height: 10),
                  CustomStatCard(
                    activeCount: widget.activeCount,
                    inactiveCount: widget.inactiveCount,
                    activeLabel: S.of(context).active_users,
                    inactiveLabel: S.of(context).inactive_users,
                    showAddButton: false,
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          ),
          if (widget.users.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: CustomNoDataWidget(message: S.of(context).no_users_found),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
              ),
              sliver: SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: itemWidth * 1.7 / 803,
                ),
                itemCount: widget.users.length,
                itemBuilder: (context, index) {
                  return CustomUserItem(
                    user: widget.users[index],
                    view: widget.view,
                    onTapDetails: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => BlocProvider.value(
                                value: context.read<AllUsersCubit>(),
                                child: DetailsUserView(
                                  user: widget.users[index],
                                ),
                              ),
                        ),
                        // BlocProvider.value(
                        //   value: context.read<AllUsersCubit>(),
                        //   child: DetailsUserView(user: widget.users[index]),
                        // ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Row newMethod(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: searchController,
            hintText: S.of(context).search_users_by_name_or_email,
            labels: S.of(context).search_users,
            keyboardType: TextInputType.text,
            prefixIcon: Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                if (searchController.text.isNotEmpty) {
                  searchController.clear();
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
