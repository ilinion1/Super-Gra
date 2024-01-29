import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoneyCubit extends Cubit<int> {
  final SharedPreferences pref;
  MoneyCubit(this.pref) : super(MoneyStorage(pref).getMoney());

  Future<void> setMoney(int value) async {
    emit(state + value);
    await MoneyStorage(pref).setMoney(state);
  }
}

class MoneyStorage {
  final SharedPreferences pref;
  MoneyStorage(this.pref);

  Future<void> setMoney(int value) async {
    await pref.setInt('money', value);
  }

  int getMoney() {
    return pref.getInt('money') ?? 10000;
  }
}
