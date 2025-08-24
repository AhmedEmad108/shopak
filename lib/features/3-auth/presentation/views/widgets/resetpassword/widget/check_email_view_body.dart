import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/presentation/cubit/reset_password_cubit/reset_password_cubit.dart';
import 'package:shopak/generated/l10n.dart';

class CheckEmailViewBody extends StatefulWidget {
  const CheckEmailViewBody({super.key});

  @override
  State<CheckEmailViewBody> createState() => _CheckEmailViewBodyState();
}

class _CheckEmailViewBodyState extends State<CheckEmailViewBody> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Text(
            //   'Check Your Email',
            //   style: AppStyle.styleBold30(context),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            Text(
              S.of(context).please_enter_your_email,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.copyWith(height: 1.5),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              labels: S.of(context).email,
              hintText: S.of(context).enter_email,
              onSaved: (value) {
                email = value!;
              },
              validator: (value) {
                return validInput(
                  context: context,
                  val: value!,
                  type: 'email',
                  max: 30,
                  min: 10,
                );
              },
              keyboardType: TextInputType.emailAddress,
              suffixIcon: const Icon(Icons.email_outlined),
            ),
            const SizedBox(height: 33),
            CustomButton(
              title: S.of(context).check_your_email,
              buttonColor: AppColor.primaryColor,
              textStyle: AppStyle.styleBold24().copyWith(color: AppColor.white),
              onTap: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  context.read<ResetPasswordCubit>().resetPassword(
                    email: email,
                  );
                  // Navigator.of(context).pushNamed(
                  //     VerifyCodeResetPassView.routeName,
                  //     arguments: email);
                } else {
                  autoValidateMode = AutovalidateMode.always;
                  setState(() {});
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
