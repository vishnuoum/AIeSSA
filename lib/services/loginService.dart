
import 'package:http/http.dart';
import 'package:app_for_specially_abled/constants.dart';

class LoginService{


  Future<dynamic> login({required String mail,required String password})async{
    print(mail);
    print(password);
    try {
      Response response = await post(Uri.parse("http://$ip:3000/validate"),
          body: {"mail": mail, "password": password});
      if (response.body == "done") {
        return "done";
      }
      else {
        return "error";
      }
    }
    catch(e){
      print("Login exception: $e");
      return "netError";
    }
  }



  Future<dynamic> signup({required String name,required String mail,required String companionName,required String companionMail,required String password,required String deaf,required String mute,required String blind,required String other})async{
    print(mail);
    print(password);
    try {
      Response response = await post(Uri.parse("http://$ip:3000/register"),
          body: {"username":name,"mail": mail,"companionName":companionName,"companionMail":companionMail,"password": password,"deaf":deaf,"blind":blind,"mute":mute,"other":other});
      if (response.body == "done") {
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("Signup exception: $e");
      return "netError";
    }
  }



  Future<dynamic> updatePassword({required String password,required String otp,required String? phone})async{
    try{
      Response response = await post(Uri.parse("http://$ip:3000/editPassword"),
          body: {"password":password,"phone": phone, "otp":otp});
      if(response.body=="done"){
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("Update password exception: $e");
      return "error";
    }
  }

  Future<dynamic> authenticate({required String id})async{

    try {
      Response response = await post(Uri.parse("http://$ip:3000/authenticate"),
          body: {"id": id});
      if (response.body == "done") {
        return "done";
      }
      else{
        return "error";
      }
    }
    catch(e){
      print("authenticate exception: $e");
      return "error";
    }
  }
}