import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shopak/core/services/shared_prefrences_singletone.dart';
part 'lang_state.dart';

class LangCubit extends Cubit<LangState> {
  LangCubit() : super(LangInitial());
  void changeLang({required String lang}) async {
    if (lang == 'system') {
      final String systemLang =
          WidgetsBinding.instance.platformDispatcher.locale.languageCode;
      emit(LangChanged(locale: systemLang));
      await Prefs.setString('lang', 'system');
    } else {
      emit(LangChanged(locale: lang));
      await Prefs.setString('lang', lang);
    }
    // await Prefs.setString('lang', lang);
    // emit(LangState(
    //   locale: lang,
    // ),
    // );
  }
}
