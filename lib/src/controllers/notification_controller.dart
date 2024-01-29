import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationCubit extends Cubit<bool> {
  final SharedPreferences pref;
  NotificationCubit(this.pref)
      : super(NotificationStorage(pref).getNotification());

  Future<void> setNotification(bool value) async {
    emit(value);
    await NotificationStorage(pref).setNotification(state);
  }
}

class NotificationStorage {
  final SharedPreferences pref;
  NotificationStorage(this.pref);

  Future<void> setNotification(bool value) async {
    await pref.setBool('notification', value);
  }

  bool getNotification() {
    return pref.getBool('notification') ?? false;
  }
}
