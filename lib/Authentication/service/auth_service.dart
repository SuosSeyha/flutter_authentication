import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase_11_12/Authentication/helper/function_help.dart';
import 'package:flutter_firebase_11_12/Authentication/widget/widget.dart';

class AuthService{
   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   FunctionHelper functionHelper = FunctionHelper();
  // registerAcccount
  Future<bool?> registerAcccount({required String email,required String password})async{
    try{
        User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
        if(user!=null){
          return true; 
        }else{
          return false;
        }
    }on FirebaseAuthException catch (e){
        showMessageError(
          title: 'Error Register',
          message: e.toString()
        );
    }
  }
  // loginAccount
  Future<bool?> loginAcccount({required String email,required String password})async{
    try{
        User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
        if(user!=null){
          return true; 
        }else{
          return false;
        }
    }on FirebaseAuthException catch (e){
        showMessageError(
          title: 'Error Login',
          message: e.toString()
        );
    }
  }
  // logoutAccount
  Future <void> logoutAccount()async{
    await functionHelper.setUserState(false);
    await FirebaseAuth.instance.signOut();
  }
}