import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_images.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/core/widgets/custom_password_text_field.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/presentation/views/sign_up_view.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_in/have_or_dont_have_accont.dart';
import 'package:shopak/generated/l10n.dart';
import 'package:svg_flutter/svg.dart';

class SignInViewBody extends StatefulWidget {
  const SignInViewBody({super.key});

  @override
  State<SignInViewBody> createState() => _SignInViewBodyState();
}

class _SignInViewBodyState extends State<SignInViewBody> {
  final formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  // late String email, password;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(Assets.imagesAppIconSvg, height: 200),
            ),
            const SizedBox(height: 33),
            Text(
              S.of(context).welcome_back,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              hintText: S.of(context).enter_email,
              labels: S.of(context).email,
              controller: emailController,
              onSaved: (value) {
                emailController.text = value!;
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
            const SizedBox(height: 16),
            CustomPasswordTextField(
              label: S.of(context).password,
              controller: passwordController,
              onSaved: (value) {
                passwordController.text = value!;
              },
              hintText: S.of(context).enter_your_password,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, CheckEmailView.routeName);
                  },
                  child: Text(
                    S.of(context).forget_password,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColor.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            CustomButton(
              title: S.of(context).signin,
              buttonColor: AppColor.primaryColor,
              textStyle: AppStyle.styleBold24().copyWith(color: AppColor.white),
              onTap: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  // context.read<SignInCubit>().signInWithEmailAndPassword(
                  //   email: emailController.text,
                  //   password: passwordController.text,
                  // );
                } else {
                  autoValidateMode = AutovalidateMode.always;
                  setState(() {});
                }
              },
            ),
            const SizedBox(height: 20),
            HaveOrDontHaveAccont(
              text: S.of(context).do_not_have_an_account,
              text2: S.of(context).signup,
              onTap: () {
                Navigator.of(context).pushNamed(SignUpView.routeName);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
