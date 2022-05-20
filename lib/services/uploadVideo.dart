import 'dart:convert';
import 'dart:io';

import 'package:app_for_specially_abled/services/constants.dart';
import 'package:http/http.dart';
import 'package:http/io_client.dart';

class UploadVideo{
  
  Future<dynamic> upload({required String? path})async{
    try{
      HttpClient client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
      var ioClient = new IOClient(client);
      var request = new MultipartRequest("POST", Uri.parse("http://$ip:3001/recognize"));
      request.files.add(await MultipartFile.fromPath(
        'video',
        path!,
      ));
      var response=await ioClient.send(request);
      String body=await response.stream.bytesToString();
      if(body!="error"){
        print(body);
        return jsonDecode(body);
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