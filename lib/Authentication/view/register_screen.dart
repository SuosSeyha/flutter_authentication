import 'package:flutter/material.dart';
import 'package:flutter_firebase_11_12/Authentication/service/auth_service.dart';
import 'package:flutter_firebase_11_12/Authentication/widget/widget.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final comfirmController = TextEditingController();
  bool isPassword=true;
  bool isComfirm=true;
  bool registerState=false;
  AuthService authService = AuthService();
  void clear(){
    emailController.clear();
    passwordController.clear();
    comfirmController.clear();
  }
  Future<void> register({required String email,required String password,required String comfirm}) async{
    if(formkey.currentState!.validate()){ // state in flutter
        if(password!=comfirm){
          showMessageError(
            title: 'Error Register',
            message: 'Confirm password not correct'
          );
        }else{
          setState(() {
            registerState=true;
          });
         await authService.registerAcccount(email: email, password: password).then((value){
            if(value==true){
              showMessageSuccess(
                title: 'Register',
                message: 'Register account successful'
              );
              clear();
            }else{
              // do some what you want to do.
            }
          });
          setState(() {
            registerState=false;
          });
          
        }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: registerState?const Center(
        child: CircularProgressIndicator(),
      ):SingleChildScrollView(
        child: Form(
          key: formkey,
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Create an account',
                      style: GoogleFonts.acme(
                        fontSize: 33,
                        fontWeight: FontWeight.bold
                      )
                    ),
                    Text(
                      'Sign up now and unlock exclusive access!',
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
                          icon:  Icon(isPassword?Icons.visibility_off :Icons.visibility ),
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
                    // Comfirm
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      controller: comfirmController,
                      obscureText: isComfirm,
                      decoration:  InputDecoration(
                        label: const Text('Comfirm'),
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isComfirm = ! isComfirm;
                            });
                          },
                          icon:  Icon(isComfirm?Icons.visibility_off : Icons.visibility),
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
                          return "Comfirm must be 8 charecters";
                        }
                        return null;
                    },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        register(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          comfirm: comfirmController.text.trim(),
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
                          'R E G I S T E R',
                          style: GoogleFonts.actor(
                            fontSize: 28,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
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
                            Get.back();
                          }, 
                          child: Text(
                          'Login',
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
      ),
    );
  }
}
