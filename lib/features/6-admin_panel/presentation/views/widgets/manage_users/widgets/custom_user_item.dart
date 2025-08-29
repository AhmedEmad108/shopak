import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/widgets/custom_button_container.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/custom_image_picker.dart';
import 'package:shopak/core/widgets/show_snackbar.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/6-admin_panel/presentation/cubit/all_users/all_users_cubit.dart';
import 'package:shopak/generated/l10n.dart';

class CustomUserItem extends StatefulWidget {
  const CustomUserItem({
    super.key,
    required this.view,
    required this.user,
    required this.onTapDetails,
  });
  final bool view;
  final UserEntity user;
  final void Function() onTapDetails;

  @override
  State<CustomUserItem> createState() => _CustomUserItemState();
}

class _CustomUserItemState extends State<CustomUserItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: AppColor.primaryColor),
      ),
      color: Theme.of(context).colorScheme.tertiary,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 15),
              CustomImagePicker(
                onFileChanged: (image) {},
                radius: 50,
                urlImage: widget.user.image,
                show: false,
              ),
              ListTile(
                contentPadding: const EdgeInsets.only(top: 8),
                minVerticalPadding: 0,
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.user.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Icon(
                            widget.user.isEmailVerified
                                ? Icons.mark_email_read_outlined
                                : Icons.cancel_presentation_outlined,
                            color:
                                widget.user.isEmailVerified
                                    ? AppColor.green
                                    : AppColor.red,
                          ),
                        ],
                      ),
                      Text(
                        widget.user.email,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          height: 1.2,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 5),
                    ],
                  ),
                ),
                subtitle: Visibility(
                  visible: widget.view,
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomButtonContainer(
                          onTap: widget.onTapDetails,
                          text: S.of(context).details,
                          icon: Icons.info_outlined,
                          color: AppColor.green,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Directionality.of(context) == TextDirection.ltr
                                    ? const Radius.circular(8)
                                    : const Radius.circular(0),
                            bottomRight:
                                Directionality.of(context) == TextDirection.ltr
                                    ? const Radius.circular(0)
                                    : const Radius.circular(8),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomButtonContainer(
                          onTap: () {
                            _showDeleteConfirmationDialog(
                              context: context,
                              userId: widget.user.uId,
                            );
                          },
                          text: S.of(context).delete,
                          icon: Icons.delete_outline_rounded,
                          color: AppColor.red,
                          borderRadius: BorderRadius.only(
                            bottomLeft:
                                Directionality.of(context) == TextDirection.ltr
                                    ? const Radius.circular(0)
                                    : const Radius.circular(8),
                            bottomRight:
                                Directionality.of(context) == TextDirection.ltr
                                    ? const Radius.circular(8)
                                    : const Radius.circular(0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Visibility(
            visible: widget.view,
            child: Positioned(
              top: -10,
              left: -5,
              child: Switch(
                value: widget.user.isActive,
                onChanged: (value) {
                  context.read<AllUsersCubit>().updateUserStatus(
                    userId: widget.user.uId,
                    newStatus: value,
                  );
                },
                activeColor: AppColor.primaryColor, // لون الزر عند التفعيل
                activeTrackColor:
                    AppColor.lightPrimaryColor, // لون المسار عند التفعيل
                inactiveThumbColor: AppColor.grey, // لون الزر عند عدم التفعيل
                inactiveTrackColor:
                    AppColor.grey400, // لون المسار عند عدم التفعيل
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog({
    required BuildContext context,
    required String userId,
  }) {
    customDialog(
      context,
      title: S.of(context).confirm_delete_title,
      content: S.of(context).confirm_delete_message_user,
      onPressed: () {
        context.read<AllUsersCubit>().deleteUser(id: userId);
        setState(() {});
        Navigator.pop(context);
        showSnackBar(
          context,
          S.of(context).user_deleted_successfully,
          AppColor.green,
        );
      },
    );
  }
}
