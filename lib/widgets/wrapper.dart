import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../screens/auth_screen.dart.dart';
import '../screens/home_screen.dart';

class Wrapper extends StatelessWidget {
  static const routeName = '/wrapper';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<String>(context);
    if(user == null){
          return AuthScreen();
    }
    else{
      return HomeScreen();
    }
  }
}