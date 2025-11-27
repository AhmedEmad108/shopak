import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/core/widgets/custom_snack_bar.dart';
import 'package:shopak/core/widgets/loading_dialog.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/5-profile/presentation/views/widgets/profile_header_item.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/generated/l10n.dart';
import 'package:intl/intl.dart';

class DetailsUserViewBody extends StatelessWidget {
  const DetailsUserViewBody({super.key, required this.user});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AllUsersCubit, AllUsersState>(
      listener: (context, state) {
        if (state is EditUsersLoading) {
          loadingDialog(context);
        } else if (state is EditUsersSuccess) {
          customSnackBar(context, message: 'Updated Successfully');
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is EditUsersFailed) {
          customSnackBar(context, message: state.error);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is DeleteUsersLoading) {
          loadingDialog(context);
        } else if (state is DeleteUsersSuccess) {
          customSnackBar(context, message: 'Deleted Successfully');
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is DeleteUsersFailed) {
          customSnackBar(context, message: state.error);
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is UpdateUsersStatusLoading) {
          loadingDialog(context);
        } else if (state is UpdateUsersStatusSuccess) {
          customSnackBar(context, message: 'Updated Successfully');
          Navigator.pop(context);
          Navigator.pop(context);
        } else if (state is UpdateUsersStatusFailed) {
          customSnackBar(context, message: state.error);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Column(
            children: [
              ProfileHeaderItem(user: user, show: false),
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  // side: BorderSide(color: AppColor.grey, width: 1),
                ),
                color: Theme.of(context).colorScheme.tertiary,
                child: Table(
                  // border: TableBorder.all(color: AppColor.grey, width: 1),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder(
                    horizontalInside: BorderSide(
                      color: AppColor.grey,
                      width: 1,
                    ),
                    verticalInside: BorderSide(color: AppColor.grey, width: 1),
                  ),
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    // buildRow(S.of(context).user_name, user.name),
                    // buildRow(S.of(context).email, user.email),
                    buildRow(S.of(context).phone, user.phone),
                    buildRow(S.of(context).role, user.role),
                    buildRow(
                      S.of(context).status,
                      user.isActive
                          ? S.of(context).active
                          : S.of(context).inactive,
                    ),
                    buildRow(
                      S.of(context).email_verification_status,
                      user.isEmailVerified
                          ? S.of(context).email_verified
                          : S.of(context).email_not_verified,
                    ),
                    buildRow(
                      S.of(context).created_at,
                      DateFormatter.formatLocalizedDate(
                        context,
                        user.createdAt,
                        pattern: 'yMMMMd',
                      ),
                    ),
                    buildRow(
                      S.of(context).updated_at,
                      DateFormatter.formatLocalizedDate(
                        context,
                        user.updatedAt,
                        pattern: 'yMMMMd',
                      ),
                    ),
                    buildRow(
                      S.of(context).last_login,
                      DateFormatter.formatLocalizedDate(
                        context,
                        user.lastLogin,
                        pattern: 'yMMMMd',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (user.address != null && user.address!.isNotEmpty) ...[
                UserAddressesSection(user: user),
                SizedBox(height: 20),
              ],
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  // side: BorderSide(color: AppColor.grey, width: 1),
                ),
                color: Theme.of(context).colorScheme.tertiary,
                child: ListTile(
                  leading: Icon(
                    Icons.swap_horiz_outlined,
                    color: AppColor.primaryColor,
                  ),
                  title: Text(
                    S.of(context).change_role,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: DropdownButton<String>(
                    value: user.role,
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(8),
                    elevation: 0,
                    items:
                        roleList(context: context).map((lang) {
                          return DropdownMenuItem<String>(
                            value: lang.value,
                            child: Text(
                              lang.name,
                              style: AppStyle.styleSemiBold22(),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) async {
                      if (value == null) return;
                      await context.read<AllUsersCubit>().editUserData(
                        userEntity: user.copyWith(role: value),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () {
                        context.read<AllUsersCubit>().updateUserStatus(
                          uId: user.uId,
                          status: !user.isActive,
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.swap_horiz_outlined,
                            color: AppColor.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            S.of(context).change_status,
                            style: AppStyle.styleBold24().copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CustomButton(
                      onTap: () {},
                      buttonColor: AppColor.red,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: AppColor.white,
                          ),
                          SizedBox(width: 8),
                          Text(
                            S.of(context).delete_user,
                            style: AppStyle.styleBold24().copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  TableRow buildRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value, style: const TextStyle(fontSize: 16)),
        ),
      ],
    );
  }
}

class DateFormatter {
  /// Format عادي باستخدام pattern
  static String formatDate(DateTime date, {String pattern = 'dd/MM/yyyy'}) {
    return DateFormat(pattern).format(date.toLocal());
  }

  /// Format حسب لغة التطبيق الحالية (من الـ BuildContext)
  static String formatLocalizedDate(
    BuildContext context,
    DateTime date, {
    String pattern = 'yMMMMd',
  }) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat(pattern, locale).format(date.toLocal());
  }
}

class UserAddressesSection extends StatelessWidget {
  final UserEntity user;
  const UserAddressesSection({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final addresses = List<String>.from(user.address ?? []);
    if (addresses.isEmpty) return const SizedBox.shrink();

    // حدد العنوان الأساسي
    final int primaryIndex =
        (user.primaryIndex != null &&
                user.primaryIndex! >= 0 &&
                user.primaryIndex! < addresses.length)
            ? user.primaryIndex!
            : 0;

    final primaryAddress = addresses[primaryIndex];

    // باقي العناوين (من غير الأساسي)
    final remaining = List<String>.from(addresses)..removeAt(primaryIndex);
    final hasMore = remaining.isNotEmpty;

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: const BorderSide(color: AppColor.grey, width: 1),
      ),
      color: Theme.of(context).colorScheme.tertiary,
      child: ExpansionTile(
        initiallyExpanded: false,
        maintainState: true,
        title: Column(
          children: [
            Text(
              S.of(context).addresses,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.home, color: AppColor.primaryColor),
              title: Expanded(
                child: Text(
                  primaryAddress,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
        trailing: hasMore ? null : const SizedBox.shrink(),
        children: [
          for (var i = 0; i < remaining.length; i++) ...[
            const Divider(height: 1, color: AppColor.grey),
            ListTile(
              leading: const Icon(
                Icons.location_on,
                color: AppColor.lightPrimaryColor,
              ),
              title: Text(remaining[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class RoleClass {
  final String name;
  final String value;
  RoleClass({required this.value, required this.name});
}

List<RoleClass> roleList({required BuildContext context}) => [
  RoleClass(value: 'user', name: S.of(context).user),
  RoleClass(value: 'seller', name: S.of(context).seller),
  RoleClass(value: 'admin', name: S.of(context).admin),
];
