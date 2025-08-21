import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/widgets/custom_floating_button.dart';
import 'package:shopak/core/widgets/custom_image_picker.dart';
import 'package:shopak/core/widgets/custom_text_field.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';
import 'package:shopak/generated/l10n.dart';

class EditProfileViewBody extends StatefulWidget {
  const EditProfileViewBody({super.key});

  @override
  State<EditProfileViewBody> createState() => _EditProfileViewBodyState();
}

class _EditProfileViewBodyState extends State<EditProfileViewBody> {
  UserEntity user2 = getUser();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  TextEditingController userName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController address = TextEditingController();

  // late String email, password, confirmPassword, userName, phone;
  String? urlImage;

  @override
  void initState() {
    userName.text = user2.name;
    phone.text = user2.phone;
    urlImage = user2.image;
    // address.text = user2.address;

    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    phone.dispose();
    address.dispose();
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
                CustomImagePicker(
                  radius: 70,
                  urlImage: urlImage,
                  onFileChanged: (String? value) {
                    urlImage = value;
                  },
                ),
                const SizedBox(height: 40),
                CustomTextField(
                  hintText: S.of(context).enter_name,
                  labels: S.of(context).name,
                  controller: userName,
                  onSaved: (value) {
                    userName.text = value!;
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
                  hintText: S.of(context).enter_phone,
                  labels: S.of(context).phone,
                  controller: phone,
                  onSaved: (value) {
                    phone.text = value!;
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
                CustomTextField(
                  hintText: S.of(context).enter_address,
                  labels: S.of(context).address,
                  controller: address,
                  onSaved: (value) {
                    address.text = value!;
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
                  keyboardType: TextInputType.streetAddress,
                  suffixIcon: const Icon(Icons.location_on_outlined),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomFloatingButton(
        title: S.of(context).edit_profile,
        onTap: () async {
          if (formKey.currentState!.validate()) {
            formKey.currentState!.save();
            UserEntity user = UserEntity(
              uId: user2.uId,
              email: user2.email,
              name: userName.text,
              phone: phone.text,
              image: urlImage!,
            );
            context.read<UserCubit>().editUser(user: user);
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
