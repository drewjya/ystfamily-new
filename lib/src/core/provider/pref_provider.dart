// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'pref_provider.g.dart';

@Riverpod(keepAlive: true)
SharedPreferences pref(PrefRef ref) {
  throw UnimplementedError();
}
