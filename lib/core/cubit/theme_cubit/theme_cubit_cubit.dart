import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';

part 'theme_cubit_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitial());

  void changeTheme({required String themeMode}) async {
    if (themeMode == 'system') {
      final Brightness platformBrightness =
          WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final String theme =
          platformBrightness == Brightness.dark ? 'dark' : 'light';
      emit(ThemeChangedState(themeMode: theme));
      await Prefs.setString('themeMode', 'system');
    } else {
      emit(ThemeChangedState(themeMode: themeMode));
      await Prefs.setString('themeMode', themeMode);
    }
    // await Prefs.setString('themeMode', themeMode);
    // emit(ThemeChangedState(themeMode: themeMode));
  }
}
