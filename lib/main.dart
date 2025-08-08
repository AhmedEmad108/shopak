import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shopak/core/helper_functions/on_generate_routs.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
import 'package:shopak/core/theme/theme.dart';
import 'package:shopak/features/1-splash/presentation/views/splash_view.dart';
import 'package:shopak/generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();

  String? lang = Prefs.getString('lang');
  if (lang == null || lang.isEmpty) {
    Locale deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
    String deviceLang = deviceLocale.languageCode;
    Prefs.setString('lang', deviceLang);
  }

  String? theme = Prefs.getString('themeMode');
  if (theme == null || theme.isEmpty) {
    Brightness platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    String deviceTheme =
        platformBrightness == Brightness.dark ? 'dark' : 'light';
    Prefs.setString('themeMode', deviceTheme);
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String lang = Prefs.getString('lang') ?? 'en';
    final String themeMode = Prefs.getString('themeMode') ?? 'light';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: Locale(lang),
      title: 'Shopak',
      theme: themeMode == 'light' ? lightTheme : darkTheme,
      onGenerateRoute: onGenerateRoute,
      initialRoute: SplashView.routeName,
    );
  }
}
