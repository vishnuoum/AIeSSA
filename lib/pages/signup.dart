import 'package:app_for_specially_abled/services/loginService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {


  TextEditingController name=TextEditingController();
  TextEditingController mail=TextEditingController();
  TextEditingController companionName=TextEditingController();
  TextEditingController companionMail=TextEditingController();
  TextEditingController password1=TextEditingController();
  TextEditingController password2=TextEditingController();
  String deaf = "no";
  String mute = "no";
  String blind = "no";
  String other = "no";
  late SharedPreferences sharedPreferences;

  LoginService loginService = LoginService();


  showLoading(BuildContext context){
    AlertDialog alert =AlertDialog(
      content: SizedBox(
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,width: 50,child: CircularProgressIndicator(strokeWidth: 5,valueColor: AlwaysStoppedAnimation(Colors.deepPurple[400]),),),
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
  void initState() {
    super.initState();
    loadSharedPreferences();
  }

  void loadSharedPreferences()async{
    sharedPreferences=await SharedPreferences.getInstance();
  }

  Color? getColor(Set<MaterialState> states) {
    return Colors.deepPurple[400];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Theme(
        data: ThemeData(
          primaryColor: Colors.deepPurple[400],
          accentColor: Colors.deepPurple[400],
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
              children: [
                SizedBox(height: 65,),
                Align(child: Text("Signup",style: TextStyle(color: Colors.deepPurple[400],fontSize: 30,fontWeight: FontWeight.bold),),alignment: Alignment.centerLeft,),
                SizedBox(height: 40,),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]
                  ),
                  child: TextField(
                    textCapitalization: TextCapitalization.words,
                    controller: name,
                    focusNode: null,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Name'
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
                    keyboardType: TextInputType.emailAddress,
                    controller: mail,
                    // textCapitalization: TextCapitalization.sentences,
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
                    textCapitalization: TextCapitalization.words,
                    controller: companionName,
                    focusNode: null,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Companion Name'
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
                    keyboardType: TextInputType.emailAddress,
                    controller: companionMail,
                    // textCapitalization: TextCapitalization.sentences,
                    focusNode: null,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Mail ID of Companion'
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  child: Text("Please specify the disabilities"),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: deaf=="yes",
                        onChanged: (bool? value) {
                          setState(() {
                            deaf = deaf=="yes"?"no":"yes";
                            other = "no";
                          });
                        },
                      ),
                      Text("Deaf")
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: mute=="yes",
                        onChanged: (bool? value) {
                          setState(() {
                            mute = mute=="yes"?"no":"yes";
                            other = "no";
                          });
                        },
                      ),
                      Text("Mute")
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: blind=="yes",
                        onChanged: (bool? value) {
                          setState(() {
                            blind = blind=="yes"?"no":"yes";
                            other = "no";
                          });
                        },
                      ),
                      Text("Blind")
                    ],
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(getColor),
                        value: other=="yes",
                        onChanged: (bool? value) {
                          setState(() {
                            other = other=="yes"?"no":"yes";
                            mute = "no";
                            blind = "no";
                            deaf = "no";
                          });
                        },
                      ),
                      Text("Other")
                    ],
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
                    controller: password1,
                    focusNode: null,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password'
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
                    controller: password2,
                    focusNode: null,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Re-enter Password'
                    ),
                  ),
                ),
                SizedBox(height: 15,),
                TextButton(onPressed: ()async{
                  if(name.text.length!=0 && mail.text.length!=0 && password1.text.length!=0 && password2.text.length!=0 && companionName.text.length!=0 && companionMail.text.length!=0) {
                    if (password1.text == password2.text) {
                      showLoading(context);
                      var result=await loginService.signup(mail: mail.text, password: password1.text,companionName: companionName.text,companionMail: companionMail.text,blind: blind,deaf: deaf,mute: mute,name: name.text,other: other);
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
                      else{
                        Navigator.pop(context);
                        alertDialog("Something went wrong. Try again!!");
                      }
                    }
                    else{
                      alertDialog("Passwords does not match!!");
                    }
                  }
                  else{
                    alertDialog("Please complete the form!!");
                  }
                }, child: Text("Signup",style: TextStyle(fontSize: 17),),style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),backgroundColor: Colors.deepPurple[400],primary: Colors.white,padding: EdgeInsets.all(18)),),
                SizedBox(height: 20,),
                Align(
                  child: GestureDetector(
                    child: Text("Login",style: TextStyle(fontSize: 16,color: Colors.deepPurple[400],decoration: TextDecoration.underline),),
                    onTap: (){
                      Navigator.pushReplacementNamed(context, "/login");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
