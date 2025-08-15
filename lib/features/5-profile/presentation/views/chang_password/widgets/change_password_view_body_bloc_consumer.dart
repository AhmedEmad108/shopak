import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/cubit/change_password/change_password_cubit.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/loading_dialog.dart';
import 'package:shopak/core/widgets/show_snackbar.dart';
import 'package:shopak/features/5-profile/presentation/views/chang_password/widgets/change_password_view_body.dart';
import 'package:shopak/generated/l10n.dart';

class ChangePasswordViewBodyBlocConsumer extends StatelessWidget {
  const ChangePasswordViewBodyBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordLoading) {
          loadingDialog(context);
        }
        if (state is ChangePasswordSuccess) {
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(
            context,
            S.of(context).password_updated_successfully,
            AppColor.green,
          );
        }
        if (state is ChangePasswordFailure) {
          Navigator.pop(context);
          customDialog(
            context,
            title: state.error,
            image: Assets.imagesError,
          );
        }
      },
      builder: (context, state) {
        return ChangePasswordViewBody();
      },
    );
  }
}
