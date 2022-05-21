import 'dart:convert';
import 'dart:io';

import 'package:app_for_specially_abled/constants.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class VoiceService{
  Future<dynamic> getUserLabels({required String? mail})async{
    try {
      Response response = await post(
          Uri.parse("http://$ip:3000/getUserLabels"), body: {"mail": mail});
      if (response.body != "error") {
        return jsonDecode(response.body);
      }
    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> uploadAudio({required String label,required String? path,required String mail})async{
    try{
      HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      var ioClient = new IOClient(client);
      var request = new MultipartRequest("POST", Uri.parse("http://$ip:3001/uploadAudio"));
      request.files.add(await MultipartFile.fromPath(
        'audio',
        path!,
      ));
      request.fields.addAll({"label":label,"mail":mail});
      var response=await ioClient.send(request);
      String body=await response.stream.bytesToString();
      if(body=="done"){
        print(body);
        return "done";
      }
      else{
        return "error";
      }

    }
    catch(e){
      print(e);
      return "error";
    }
  }

  Future<dynamic> classifyAudio({required String? path,required String? mail})async{
    try{
      HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      var ioClient = new IOClient(client);
      var request = new MultipartRequest("POST", Uri.parse("http://$ip:3001/classifyAudio"));
      request.files.add(await MultipartFile.fromPath(
        'audio',
        path!,
      ));
      request.fields.addAll({"mail":mail.toString()});
      var response=await ioClient.send(request);
      String body=await response.stream.bytesToString();
      if(body!="error"){
        print(body);
        return body;
      }
      else{
        return "error";
      }

    }
    catch(e){
      print(e);
      return "error";
    }
  }
}