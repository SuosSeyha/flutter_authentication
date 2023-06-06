import 'package:flutter/material.dart';
import 'package:flutter_firebase_11_12/Authentication/service/auth_service.dart';
import 'package:flutter_firebase_11_12/Authentication/view/home_page.dart';
import 'package:flutter_firebase_11_12/Authentication/view/register_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isPassword=true;
  bool isLoginState=false;
  AuthService authService = AuthService();
  void clear(){
    emailController.clear();
    passwordController.clear();
  }
  Future<void> sigin({required String email,required String password})async{
    if(formkey.currentState!.validate()){
      setState(() {
        isLoginState=true;
      });
      await authService.loginAcccount(email: email, password: password).then((value){
        if(value==true){
          Get.to(const HomePage());
          clear();
        }
      });
      setState(() {
        isLoginState=false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoginState?const Center(
        child: CircularProgressIndicator(),
      ) : Form(
        key: formkey,
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    'Login your email',
                    style: GoogleFonts.acme(
                      fontSize: 33,
                      fontWeight: FontWeight.bold
                    )
                  ),
                  Text(
                    'Sign in now and unlock exclusive access!',
                    style: GoogleFonts.acme(
                      fontSize: 20,
                      color: Colors.grey
                    )
                  ),
                  // Email
                  const SizedBox(
                    height: 50,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration:  InputDecoration(
                      label: const Text('Email'),
                      prefixIcon: const Icon(Icons.email),
                      
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.red
                        )
                      ),
                    ),
                    validator: (val) {
                    return RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val!)
                        ? null
                        : "Please enter a valid email";
                  },
                  ),
                  // Password
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: isPassword,
                    decoration:  InputDecoration(
                      label: const Text('Password'),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isPassword = ! isPassword;
                          });
                        },
                        icon:  Icon(isPassword?Icons.visibility_off:Icons.visibility),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20
                        )
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                        borderSide: const BorderSide(
                          width: 2,
                          color: Colors.red
                        )
                      ),
                    ),
                    validator: (val) {
                      if(val!.length<8){
                        return "Password must be 8 charecters";
                      }
                      return null;
                  },
                  ),
                  
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      sigin(
                        email: emailController.text.trim(), 
                        password: passwordController.text.trim()
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height*0.06,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(
                          20
                        )
                      ),
                      child: Text(
                        'L O G I N',
                        style: GoogleFonts.actor(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You have no account yet?',
                        style: GoogleFonts.acme(
                          fontSize: 18,
                          color: Colors.grey
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.to(RegisterScreen());
                        }, 
                        child: Text(
                        'Register',
                        style: GoogleFonts.acme(
                          fontSize: 18,
                          color: Colors.blueGrey
                        ),
                      ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}