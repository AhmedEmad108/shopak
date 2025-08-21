part of 'lang_cubit.dart';

@immutable
abstract class LangState {}

class LangInitial extends LangState {}

class LangChanged extends LangState {
  final String locale;
  LangChanged({required this.locale});
}
