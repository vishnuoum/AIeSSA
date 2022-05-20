import 'package:app_for_specially_abled/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  LoginService loginService=LoginService();

  TextEditingController mail=TextEditingController();
  TextEditingController password=TextEditingController();
  late SharedPreferences sharedPreferences;
  bool error=false;
  TextEditingController phoneController=TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  void loadSharedPreferences()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }


  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.blue),),),
            SizedBox(height: 10,),
            Text("Loading")
          ],
        ),
      ),
    );

    showDialog(context: context,builder:(BuildContext context){
      return WillPopScope(onWillPop: ()async => false,child: alert);
    });
  }


  Future<void> alertDialog(var text) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(text),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
            children: [
              SizedBox(height: 65,),
              Align(child: Text("Login",style: TextStyle(color: Colors.deepPurple[400],fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
              SizedBox(height: 40,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  controller: mail,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Mail ID'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200]
                ),
                child: TextField(
                  obscureText: true,
                  controller: password,
                  focusNode: null,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Password'
                  ),
                ),
              ),
              SizedBox(height: 15,),
              TextButton(onPressed: ()async{
                showLoading(context);
                if(mail.text.length!=0 && password.text.length!=0){
                  var result=await loginService.login(mail: mail.text, password: password.text);
                  if(result=="done"){
                    await sharedPreferences.setString("mail", mail.text);
                    OneSignal.shared.setExternalUserId(mail.text).then((results) {
                      print(results.toString());
                    }).catchError((error) {
                      print(error.toString());
                    });
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, "/home");
                  }
                  else if(result=="netError"){
                    Navigator.pop(context);
                    alertDialog("Something went wrong. Please check your network connection and try again!!");
                  }
                  else{
                    Navigator.pop(context);
                    alertDialog("Wrong Mail ID or Password");
                    setState(() {
                      error=true;
                    });
                  }
                }
                else{
                  Navigator.pop(context);
                  alertDialog("Please complete the form");
                }
              }, child: Text("Login",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.deepPurple[400],primary: Colors.white,padding: EdgeInsets.all(18)),),
              SizedBox(height: 20,),
              Align(
                child: GestureDetector(
                  child: Text("Signup",style: TextStyle(fontSize: 16,color: Colors.deepPurple[400],decoration: TextDecoration.underline),),
                  onTap: (){
                    Navigator.pushReplacementNamed(context, "/signup");
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
