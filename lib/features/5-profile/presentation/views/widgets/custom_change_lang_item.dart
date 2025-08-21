import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopak/core/cubit/lang_cubit/lang_cubit.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/utils/app_style.dart';
import 'package:shopak/core/widgets/custom_listtile.dart';
import 'package:shopak/core/widgets/custom_snack_bar.dart';
import 'package:shopak/features/5-profile/data/models/lang_class.dart';
import 'package:shopak/generated/l10n.dart';

class CustomChangeLangItem extends StatefulWidget {
  const CustomChangeLangItem({super.key});

  @override
  State<CustomChangeLangItem> createState() => _CustomChangeLangItemState();
}

class _CustomChangeLangItemState extends State<CustomChangeLangItem> {
  List<LangClass> get langList => [
    LangClass(
      locale: 'system',
      name: S.of(context).device,
      name2: S.of(context).device_language,
    ),
    LangClass(
      locale: 'en',
      name: S.of(context).english,
      name2: S.of(context).english_language,
    ),
    LangClass(
      locale: 'ar',
      name: S.of(context).arabic,
      name2: S.of(context).arabic_language,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangCubit, LangState>(
      builder: (context, state) {
        String sharLang = Prefs.getString('lang') ?? 'system';
        return CustomListTile(
          title: S.of(context).change_language,
          icon: Icons.language_outlined,
          trailing: DropdownButton<String>(
            value: sharLang,
            underline: const SizedBox(),
            borderRadius: BorderRadius.circular(8),
            elevation: 0,
            items:
                langList.map((lang) {
                  return DropdownMenuItem<String>(
                    value: lang.locale,
                    child: Text(lang.name, style: AppStyle.styleSemiBold22()),
                  );
                }).toList(),
            onChanged: (value) async {
              if (value == null) return;
              if (value == sharLang) return;
              context.read<LangCubit>().changeLang(lang: value);
              final locale =
                  value == 'system'
                      ? WidgetsBinding.instance.platformDispatcher.locale
                      : Locale(value);
              final newLang = await S.delegate.load(locale);
              customSnackBar(
                context,
                message:
                    '${newLang.language_changed_to} ${langList.firstWhere((lang) => lang.locale == value).name2}',
              );
            },
          ),
        );
      },
    );
  }
}
