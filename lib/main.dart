import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopak/core/cubit/lang_cubit/lang_cubit.dart';
import 'package:shopak/core/cubit/theme_cubit/theme_cubit_cubit.dart';
import 'package:shopak/core/cubit/user/user_cubit.dart';
import 'package:shopak/core/helper_functions/on_generate_routs.dart';
import 'package:shopak/core/services/custom_bloc_observer.dart';
import 'package:shopak/core/services/get_it.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/theme/theme.dart';
import 'package:shopak/features/1-splash/presentation/views/splash_view.dart';
import 'package:shopak/features/3-auth/domain/repos/auth_repo.dart';
import 'package:shopak/firebase_options.dart';
import 'package:shopak/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = CustomBlocObserver();
  // await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Prefs.init();

  String? lang = Prefs.getString('lang');
  if (lang == null || lang.isEmpty) {
    // Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    // String deviceLang = deviceLocale.languageCode;
    Prefs.setString('lang', 'system');
  }

  String? theme = Prefs.getString('themeMode');
  if (theme == null || theme.isEmpty) {
    // Brightness platformBrightness =
    //     WidgetsBinding.instance.platformDispatcher.platformBrightness;
    // String deviceTheme =
    //     platformBrightness == Brightness.dark ? 'dark' : 'light';
    Prefs.setString('themeMode', 'system');
  }
  setupGetIt();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LangCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => UserCubit(getIt<AuthRepo>())),
      ],
      child: BlocBuilder<ThemeCubit, ThemeState>(
        builder: (context, state) {
          return BlocBuilder<LangCubit, LangState>(
            builder: (context, state) {
              final String lang = Prefs.getString('lang') ?? 'system';
              final String themeMode = Prefs.getString('themeMode') ?? 'system';

              Locale? appLocale;
              if (lang == 'system') {
                appLocale = WidgetsBinding.instance.platformDispatcher.locale;
              } else {
                appLocale = Locale(lang);
              }

              ThemeData? themeData;
              if (themeMode == 'system') {
                final Brightness platformBrightness =
                    WidgetsBinding
                        .instance
                        .platformDispatcher
                        .platformBrightness;
                themeData =
                    platformBrightness == Brightness.light
                        ? lightTheme
                        : darkTheme;
              } else {
                themeData = themeMode == 'dark' ? darkTheme : lightTheme;
              }
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                locale: appLocale,
                title: 'Shopak',
                theme: themeData,
                onGenerateRoute: onGenerateRoute,
                initialRoute: SplashView.routeName,
              );
            },
          );
        },
      ),
    );
  }
}
