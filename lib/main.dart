import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase_11_12/Authentication/helper/function_help.dart';
import 'package:flutter_firebase_11_12/Authentication/view/home_page.dart';
import 'package:get/get.dart';
import 'Authentication/view/login_screen.dart';
import 'Authentication/view/register_screen.dart';
import 'CloudFireStore/view/student_view.dart';
import 'FirebaseStorage/home_storage.dart';
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // bool userState=false;
  // FunctionHelper functionHelper = FunctionHelper();
  // @override
  // void initState() {
  //   super.initState();
  //   functionHelper.getUserState().then((value){
  //     setState(() {
  //       userState=value!;
  //     });
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ), 
      debugShowCheckedModeBanner: false,
      //home:  userState? HomePage():const LoginScreen(),
      home: const HomeStorage()
    );
  }
}
