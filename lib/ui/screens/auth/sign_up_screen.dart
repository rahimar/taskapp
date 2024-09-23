
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/data/models/network_response.dart';
import 'package:taskmanager/data/network_caller/network_caller.dart';
import 'package:taskmanager/ui/utility/app.colors.dart';
import 'package:taskmanager/ui/widgets/background_widget.dart';
import 'package:taskmanager/ui/widgets/snack_bar_message.dart';

import '../../../data/utilities/urls.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final TextEditingController _emailTEController  = TextEditingController();
  final TextEditingController _passETController = TextEditingController();
  final TextEditingController _firstETController = TextEditingController();
  final TextEditingController _lastETController = TextEditingController();
  final TextEditingController _mobileETController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool   _registrationInprogress = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BackgroundWidget(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Join With Us',
                       style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailTEController,
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
                      controller: _firstETController,
                      decoration: const InputDecoration(
                          hintText: 'First Name'
                      ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your first name';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastETController,
                      decoration: const InputDecoration(
                          hintText: 'Last Name'
                      ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your lst name';
                          }
                          return null;
                        }
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileETController,
                      decoration: const InputDecoration(
                          hintText: 'Mobile'
                      ),
                        validator: (String? value){
                          if(value?.trim().isEmpty ?? true){
                            return 'Enter your mobile';
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
                        onPressed: () {
                          if(_formkey.currentState!.validate()){
                             _registerUser();
                          }
                        },
                        child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                    const SizedBox(height: 36),
                    _buildBackToSignInSection(),
                  ],
                ),
              ),
            ),
          )
        ),
      ),
    );
  }

  Widget _buildBackToSignInSection(){
    return Center(
      child:  RichText(text: TextSpan(
            style: TextStyle(
              color:Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.4,
            ),
            text: "Have account? ",
            children: [
              TextSpan(
                  text: "Sign In",
                  style: const TextStyle(
                    color: AppColors.themeColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = (){
                    _onTapSignInButton();
                  }
              )
            ],
          )),

    );
  }

  Future<void> _registerUser() async {
       _registrationInprogress = true;
       if(mounted){
         setState(() {

         });
       }

    Map<String, dynamic> requestInput = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstETController.text.trim(),
      "lastName": _lastETController.text.trim(),
      "mobile": _mobileETController.text.trim(),
      "password": _passETController.text,
      "photo": "",
    };
     NetworkResponse response = await NetworkCaller.postRequest(Urls.registration, body: requestInput);
       _registrationInprogress = false;
       if(mounted){
         setState(() {

         });
       }
       print(response.statusCode);
       print(response.errorMessage);

       if(response.isSuccess){
      _clearTextField();
      if(mounted){
        showSnackBarMessage(context, 'Registration Success');
      }
    }else{
      if(mounted){
        showSnackBarMessage(context, 'Registration Failed');
      }
    }
  }

  void _clearTextField(){
    _emailTEController.clear();
    _firstETController.clear();
    _lastETController.clear();
    _mobileETController.clear();
    _passETController.clear();
  }

 void _onTapSignInButton(){
    Navigator.pop(context);
 }


  @override
  void dispose(){
    _emailTEController.dispose();
    _firstETController.dispose();
    _lastETController.dispose();
    _mobileETController.dispose();
    _passETController.dispose();
    super.dispose();
  }


}