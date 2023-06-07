import 'package:shared_preferences/shared_preferences.dart';
class FunctionHelper{
  static const  keyuser = "User";
  // setUserState : write to share preference
  Future<void> setUserState(bool state)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(keyuser, state);
  }
  // getUserState : write to share preference
  Future<bool?> getUserState()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(keyuser);
  }
}