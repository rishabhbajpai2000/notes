import 'package:contacts/firebase_services/SplashServices.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Image.asset("assets/logo.jpeg", width: 100, height: 100,),
          AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText(
                'Notes',
                cursor: "",
                textStyle: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange
                ),
                speed: const Duration(milliseconds: 250),
              ),
            ],
          isRepeatingAnimation: false,
          )
        ],
      )),
    );
  }
}
