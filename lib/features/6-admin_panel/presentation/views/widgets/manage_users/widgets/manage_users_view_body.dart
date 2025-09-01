import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/widgets/custom_no_data_widgets.dart';
import 'package:shopak/core/widgets/custom_stat_card.dart';
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
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    searchController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  Future<void> handleRefresh() async {
    await context.read<AllUsersCubit>().refresh();
    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    var itemWidth = MediaQuery.of(context).size.width - 32;

    return RefreshIndicator(
      color: AppColor.primaryColor,
      onRefresh: handleRefresh,
      child: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: kHorizontalPadding,
              ),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  CustomManageUserHeader(searchController: searchController),
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
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: itemWidth * 1.7 / 803,
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final user = widget.users[index];
                  return CustomUserItem(
                    user: user,
                    view: widget.view,
                    onTapDetails: () {
                      Navigator.pushNamed(
                        context,
                        DetailsUserView.routeName,
                        arguments: user,
                      );
                    },
                  );
                }, childCount: widget.users.length),
              ),
            ),
        ],
      ),
    );
  }
}
