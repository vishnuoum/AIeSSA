import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Init extends StatefulWidget {
  const Init({Key? key}) : super(key: key);

  @override
  State<Init> createState() => _InitState();
}

class _InitState extends State<Init> {

  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    loadSharedPreference();
    super.initState();
  }

  void loadSharedPreference()async{
    sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey("mail")){
      Navigator.pushReplacementNamed(context, "/home");
    }
    else{
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
