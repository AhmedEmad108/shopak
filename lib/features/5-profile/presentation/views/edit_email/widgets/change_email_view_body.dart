import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/widgets/custom_dialog.dart';
import 'package:shopak/core/widgets/custom_floating_button.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/features/5-profile/presentation/views/edit_email/cubit/edit_email_cubit.dart';
import 'package:shopak/generated/l10n.dart';

class ChangeEmailViewBody extends StatefulWidget {
  const ChangeEmailViewBody({super.key});

  @override
  State<ChangeEmailViewBody> createState() => _ChangeEmailViewBodyState();
}

class _ChangeEmailViewBodyState extends State<ChangeEmailViewBody> {
  UserEntity user2 = getUser();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    emailController.text = user2.email;
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Form(
            key: formKey,
            autovalidateMode: autoValidateMode,
            child: Column(
              children: [
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
                      min: 5,
                    );
                  },
                  keyboardType: TextInputType.emailAddress,
                  suffixIcon: const Icon(Icons.email_outlined),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomFloatingButton(
        title: S.of(context).change_email,
        onTap: () {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            customDialog(
              context,
              title: S.of(context).change_email,
              textOk: S.of(context).change_email,
              content: S.of(context).edit_email_message,
              onPressed: () {
                context.read<EditEmailCubit>().updateEmail(
                  newEmail: emailController.text,
                );
              },
            );
          } else {
            setState(() {
              autoValidateMode = AutovalidateMode.always;
            });
          }
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
