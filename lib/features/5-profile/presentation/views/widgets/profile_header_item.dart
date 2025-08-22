import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/widgets/custom_image_picker.dart';
import 'package:shopak/features/3-auth/domain/entities/user_entity.dart';

class ProfileHeaderItem extends StatelessWidget {
  const ProfileHeaderItem({super.key, required this.user});
  final UserEntity user;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomImagePicker(
            radius: 50,
            urlImage: user.image,
            onFileChanged: (String? value) {
              context.read<UserCubit>().editUserImage(image: value!);
            },
          ),
          const SizedBox(width: 24),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.48,
              maxHeight: 100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      user.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      user.email,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      user.role,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
