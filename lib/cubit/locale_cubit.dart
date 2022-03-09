import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(locale) : super(locale);

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('languageCode', locale.languageCode);
    emit(locale);
  }
}
