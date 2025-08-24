import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/custom_image_picker.dart';
import 'package:shopak/core/widgets/custom_password_text_field.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/presentation/cubit/signup_cubit/sign_up_cubit.dart';
import 'package:shopak/features/3-auth/presentation/views/widgets/sign_up/dont_have_account_widget.dart';
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
  String? imageUrl;
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
              CustomImagePicker(
                onFileChanged: (url) => imageUrl = url,
                auth: true,
                radius: 70,
              ),
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
                    type: 'text',
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
                    min: 9,
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
              CustomButton(
                title: S.of(context).signup,
                buttonColor: AppColor.primaryColor,
                textStyle: AppStyle.styleBold24().copyWith(
                  color: AppColor.white,
                ),
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    if (password == confirmPassword) {
                      // final bytes = imageUrl!.readAsBytesSync();
                      // String base64Image = base64Encode(bytes);
                      if (isTermsAccepted) {
                        context
                            .read<SignUpCubit>()
                            .createUserWithEmailAndPassword(
                              email: email,
                              password: password,
                              name: userName,
                              phone: phone,
                              image:
                                  imageUrl == null ? imageProfile : imageUrl!,
                            );
                      } else {
                        customDialog(
                          context,
                          title:
                              S.of(context).please_accept_terms_and_conditions,
                        );
                      }
                    } else {
                      customDialog(
                        context,
                        title:
                            S
                                .of(context)
                                .password_and_confirm_password_not_match,
                      );
                    }
                  } else {
                    autoValidateMode = AutovalidateMode.always;
                    setState(() {});
                  }
                },
              ),
              const SizedBox(height: 33),
              HaveOrDontHaveAccountWidget(
                text: S.of(context).already_have_an_account,
                text2: S.of(context).signin,
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 33),
            ],
          ),
        ),
      ),
    );
  }
}
