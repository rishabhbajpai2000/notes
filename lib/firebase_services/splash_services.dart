
import 'dart:async';


import 'package:flutter/material.dart';

import '../UI/auth/LoginScreen.dart';


class SplashServices{
  void isLogin(BuildContext context){
    Timer(const Duration(seconds: 3), 
    ()=>Navigator.push(context, MaterialPageRoute(builder:(context)=>LoginScreen())));
  }
}