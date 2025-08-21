import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/cubit/theme_cubit/theme_cubit_cubit.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_listtile.dart';
import 'package:shopak/core/widgets/custom_snack_bar.dart';
import 'package:shopak/features/5-profile/data/models/theme_class.dart';
import 'package:shopak/generated/l10n.dart';

class CustomChangeThemeItem extends StatelessWidget {
  const CustomChangeThemeItem({super.key});

  List<ThemeClass> _themeList(BuildContext context) => [
    ThemeClass(
      theme: 'system',
      name: S.of(context).device,
      name2: S.of(context).device_mode,
    ),
    ThemeClass(
      theme: 'light',
      name: S.of(context).light,
      name2: S.of(context).light_mode,
    ),
    ThemeClass(
      theme: 'dark',
      name: S.of(context).dark,
      name2: S.of(context).dark_mode,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeList = _themeList(context);
        String theme = Prefs.getString('themeMode') ?? 'system';
        return CustomListTile(
          title: S.of(context).change_theme,
          icon: Icons.dark_mode_outlined,
          trailing: DropdownButton<String>(
            value: theme,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            elevation: 0,
            items:
                themeList.map((theme) {
                  return DropdownMenuItem<String>(
                    value: theme.theme,
                    child: Text(theme.name, style: AppStyle.styleSemiBold22()),
                  );
                }).toList(),
            onChanged: (value) async {
              if (value == null) return;
              if (value == theme) return;
              context.read<ThemeCubit>().changeTheme(themeMode: value);

              customSnackBar(
                context,
                message:
                    '${S.of(context).theme_changed_to} ${themeList.firstWhere((theme) => theme.theme == value).name2}',
              );
            },
          ),
        );
      },
    );
  }
}
