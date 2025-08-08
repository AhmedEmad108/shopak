import 'package:flutter/material.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/widgets/custom_password_text_field.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/terms_and_condition.dart';
import 'package:shopak/generated/l10n.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _SignUpViewBodyState();
}

class _SignUpViewBodyState extends State<SignUpViewBody> {
  late bool isTermsAccepted = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  late String email, password, confirmPassword, userName, phone;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
        child: Form(
          key: formKey,
          autovalidateMode: autoValidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              CustomTextField(
                hintText: S.of(context).enter_name,
                labels: S.of(context).name,
                onSaved: (value) {
                  userName = value!;
                },
                validator: (value) {
                  return validInput(
                    context: context,
                    val: value!,
                    type: 'name',
                    max: 20,
                    min: 3,
                  );
                },
                keyboardType: TextInputType.name,
                suffixIcon: const Icon(Icons.person_outline),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: S.of(context).enter_email,
                labels: S.of(context).email,
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
              const SizedBox(height: 16),
              CustomTextField(
                hintText: S.of(context).enter_phone,
                labels: S.of(context).phone,
                onSaved: (value) {
                  phone = value!;
                },
                validator: (value) {
                  return validInput(
                    context: context,
                    val: value!,
                    type: 'phone',
                    max: 30,
                    min: 12,
                  );
                },
                keyboardType: TextInputType.phone,
                suffixIcon: const Icon(Icons.phone_android_outlined),
              ),
              const SizedBox(height: 16),
              CustomPasswordTextField(
                hintText: S.of(context).enter_your_password,
                label: S.of(context).password,
                onSaved: (value) {
                  password = value!;
                },
              ),
              const SizedBox(height: 16),
              CustomPasswordTextField(
                hintText: S.of(context).enter_confirm_your_password,
                label: S.of(context).confirm_password,
                onSaved: (value) {
                  confirmPassword = value!;
                },
              ),
              const SizedBox(height: 16),
              CustomTermsAndCondition(
                onChanged: (value) {
                  isTermsAccepted = value;
                  setState(() {});
                },
                isAccepted: isTermsAccepted,
              ),
              const SizedBox(height: 33),
            ],
          ),
        ),
      ),
    );
  }
}
