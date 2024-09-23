import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/login_model.dart';
import 'package:taskmanager/ui/controller/auth_controller.dart';
import 'package:taskmanager/ui/screens/auth/email_verify_screen.dart';
import 'package:taskmanager/ui/screens/auth/sign_up_screen.dart';
import 'package:taskmanager/ui/screens/main_bottom_nav_screen.dart';
import 'package:taskmanager/ui/utility/app.colors.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';

import '../../../data/models/network_response.dart';
import '../../../data/network_caller/network_caller.dart';
import '../../../data/utilities/urls.dart';
import '../../widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final TextEditingController _emailTEController  = TextEditingController();
  final TextEditingController _passETController = TextEditingController();
  bool _signUpInprogress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Get Started With',
                       style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'Email'
                      ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your email';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                        obscureText: true,
                      controller: _passETController,
                      decoration: const InputDecoration(
                          hintText: 'Password'
                      ),

                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your password';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                        onPressed: _onTapMainNextButton,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                    const SizedBox(height: 36),
                    Center(
                      child: Column(
                        children: [
                          TextButton(onPressed: _onTapForgotButton,
                              child: const Text('Forgot Password?'),),
                          RichText(text: TextSpan(
                            style: TextStyle(
                              color:Colors.black.withOpacity(0.8),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: const TextStyle(
                                  color: AppColors.themeColor,
                                ),
                                recognizer: TapGestureRecognizer()..onTap = (){
                                  _onTapSignUpButton();
                                }
                              )
                            ],
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

  void _onTapMainNextButton(){
    if(_formKey.currentState!.validate()){
      _signUpUser();
    }

  }

  Future<void> _signUpUser() async {
    _signUpInprogress = true;
    if(mounted){
      setState(() {

      });
    }

    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "password": _passETController.text,
    };
    NetworkResponse response = await NetworkCaller.postRequest(Urls.login, body: requestInput);
    _signUpInprogress = false;
    if(mounted){
      setState(() {

      });
    }
    print(response.statusCode);
    print(response.errorMessage);

    if(response.isSuccess){
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveUserAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userModel!);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainBottomNavScreen())
      );
    }else{
      if(mounted){
        showSnackBarMessage(context, 'Login Failed');
      }
    }
  }

  void _onTapSignUpButton(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const SignUpScreen())
    );
  }
  void _onTapForgotButton(){
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const EmailVerifyScreen())
    );
  }

  @override
  void dispose(){
    _emailTEController.dispose();
    _passETController.dispose();
    super.dispose();
  }


}


