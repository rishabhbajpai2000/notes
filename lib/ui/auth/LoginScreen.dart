

import 'package:contacts/services/session.dart';
import 'package:contacts/ui/auth/signUpScreen.dart';
import 'package:contacts/widgets/RoundButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/Utils.dart';
import '../FirebaseDatabase/contacts_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;
  void login() {
    setState(() {
      loading = true;
    });

    try {
      _auth
          .signInWithEmailAndPassword(
              email: emailController.text,
              password: passwordController.text.toString())
          .then((value) {
        SessionController().userId = value.user!.uid.toString();
        Utils().toastMessage(value.user!.email.toString());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ContactsScreen()));
        setState(() {
          loading = false;
        });
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      });
    } catch (e) {
      Utils().toastMessage(e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Login"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: "Email",
                          prefixIcon: Icon(Icons.alternate_email)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter Email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Enter Password",
                          prefixIcon: Icon(Icons.lock_open)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter password";
                        }
                        return null;
                      },
                    ),
                  ],
                )),
                SizedBox(
                  height: 50,
                ),
                RoundButton(
                    title: "Login",
                    onTap: () {
                      login();
                    }),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Dont have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Text("SignUp"))
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
