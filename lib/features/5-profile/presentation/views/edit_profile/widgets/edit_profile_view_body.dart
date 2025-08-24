import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/contants.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/helper_functions/get_user.dart';
import 'package:shopak/core/helper_functions/valid_input.dart';
import 'package:shopak/core/utils/app_color.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_button.dart';
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
  String? urlImage;
  List<TextEditingController> addressControllers = [];
  int? primaryIndex;

  @override
  void initState() {
    userName.text = user2.name;
    phone.text = user2.phone;
    urlImage = user2.image;
    if (user2.address != null) {
      for (var addr in user2.address!) {
        addressControllers.add(TextEditingController(text: addr));
      }
    } else {
      addressControllers.add(TextEditingController());
    }
    primaryIndex = user2.primaryIndex ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    phone.dispose();
    for (var controller in addressControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void addAddress() {
    setState(() {
      addressControllers.add(TextEditingController());
    });
  }

  void removeAddress(int index) {
    setState(() {
      addressControllers.removeAt(index);
      if (primaryIndex! >= addressControllers.length) {
        primaryIndex = 0;
      }
    });
  }

  void showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: StatefulBuilder(
              builder: (context, setSheetState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      S.of(context).address,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: addressControllers.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: S.of(context).enter_address,
                                labels: "${S.of(context).address} ${index + 1}",
                                controller: addressControllers[index],
                                // color:
                                //     index == primaryIndex!
                                //         ? AppColor.background2Color
                                //         : null,
                                isPrimary: index == primaryIndex ? true : null,
                                validator:
                                    (value) => validInput(
                                      context: context,
                                      val: value!,
                                      type: 'text',
                                      max: 50,
                                      min: 3,
                                    ),
                                keyboardType: TextInputType.streetAddress,
                                prefixIcon: Tooltip(
                                  message: S.of(context).select_primary_address,
                                  child: Radio<int>(
                                    value: index,
                                    groupValue: primaryIndex,
                                    onChanged: (value) {
                                      setSheetState(() {
                                        primaryIndex = value!;
                                      });
                                      setState(() {
                                        primaryIndex = value!;
                                      });
                                    },
                                    activeColor: Theme.of(context).primaryColor,
                                  ),
                                ),
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.location_on_outlined),
                                    IconButton(
                                      tooltip: S.of(context).remove_address,
                                      onPressed: () {
                                        setSheetState(
                                          () => removeAddress(index),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outlined,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder:
                          (context, index) => const SizedBox(height: 16),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      onTap: () {
                        setSheetState(() => addAddress());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.add_location_alt_outlined,
                            color: AppColor.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            S.of(context).add_address,
                            style: AppStyle.styleBold24().copyWith(
                              color: AppColor.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
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
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: S.of(context).enter_address,
                        labels: S.of(context).address,
                        controller:
                            primaryIndex != null &&
                                    primaryIndex! < addressControllers.length
                                ? addressControllers[primaryIndex!]
                                : TextEditingController(),
                        validator:
                            (value) => validInput(
                              context: context,
                              val: value!,
                              type: 'text',
                              max: 50,
                              min: 3,
                            ),
                        keyboardType: TextInputType.streetAddress,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_outlined),
                            IconButton(
                              onPressed: () => showAddressBottomSheet(context),
                              icon: const Icon(
                                Icons.edit_location_alt_outlined,
                                color: AppColor.primaryColor,
                              ),
                              tooltip: S.of(context).edit_address,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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

            final addresses =
                addressControllers
                    .map((e) => e.text)
                    .where((e) => e.isNotEmpty)
                    .toList();
            UserEntity user = user2.copyWith(
              name: userName.text,
              phone: phone.text,
              image: urlImage!,
              address: addresses,
              primaryIndex: primaryIndex,
              updatedAt: DateTime.now(),
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
