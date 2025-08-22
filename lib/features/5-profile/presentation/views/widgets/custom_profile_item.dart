import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/5-profile/presentation/views/become_seller/become_seller_view.dart';
import 'package:shopak/features/5-profile/presentation/views/chang_password/change_password_view.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_email/change_email_view.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_profile/edit_profile_view.dart';
import 'package:shopak/generated/l10n.dart';
import 'package:shopak/core/widgets/custom_listtile.dart';
import 'package:shopak/features/5-profile/presentation/views/logout/custom_log_out.dart';
import 'package:shopak/features/5-profile/presentation/views/widgets/custom_change_lang_item.dart';
import 'package:shopak/features/5-profile/presentation/views/widgets/custom_change_theme_item.dart';

class CustomProfileItem extends StatefulWidget {
  const CustomProfileItem({super.key});

  @override
  State<CustomProfileItem> createState() => _CustomProfileItemState();
}

class _CustomProfileItemState extends State<CustomProfileItem> {
  UserEntity? user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is GetUserSuccess) {
          user = state.user;
        } else if (state is GetUserLoading) {
          user = getUser();
        } else if (state is GetUserFailed) {
          return Center(child: Text(state.errMessage));
        }

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              CustomListTile(
                title: S.of(context).edit_profile,
                icon: Icons.edit_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed(EditProfileView.routeName);
                },
              ),
              CustomListTile(
                title: S.of(context).change_email,
                icon: Icons.email_outlined,
                onTap: () {
                  Navigator.of(context).pushNamed(ChangeEmailView.routeName);
                },
              ),
              CustomListTile(
                title: S.of(context).change_password,
                icon: Icons.lock_outline,
                onTap: () {
                  Navigator.of(context).pushNamed(ChangePasswordView.routeName);
                },
              ),

              // Visibility(
              //   visible: user!.role == 'admin',
              //   child: CustomListTile(
              //     title: S.of(context).sellers_requests,
              //     icon: Icons.store_outlined,
              //     onTap: () {
              //       // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
              //     },
              //   ),
              // ),
              // Visibility(
              //   visible: user!.role == 'admin',
              //   child: CustomListTile(
              //     title: S.of(context).manage_users,
              //     icon: Icons.admin_panel_settings_outlined,
              //     onTap: () {
              //       // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
              //     },
              //   ),
              // ),
              // Visibility(
              //   visible: user!.role == 'admin',
              //   child: CustomListTile(
              //     title: S.of(context).manage_sellers,
              //     icon: Icons.admin_panel_settings_outlined,
              //     onTap: () {
              //       // Navigator.of(context).pushNamed(BecomeSellerView.routeName);
              //     },
              //   ),
              // ),
              Visibility(
                visible: user!.role == 'user',
                child: CustomListTile(
                  title: S.of(context).become_seller,
                  icon: Icons.store_outlined,
                  onTap: () {
                    Navigator.of(context).pushNamed(BecomeSellerView.routeName);
                  },
                ),
              ),

              const CustomChangeThemeItem(),
              const CustomChangeLangItem(),
              const CustomLogOut(),
            ],
          ),
        );
      },
    );
  }
}
