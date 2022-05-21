import 'package:http/http.dart';
import 'package:app_for_specially_abled/constants.dart';

class LocationService{

  void addLocation({required String lat,required String long,required String? mail})async{
    try{
      Response response = await post(Uri.parse("http://$ip:3000/addLiveLocation"),
          body: {"lat":lat,"long":long,"mail":mail});
      print(response.body);
    }
    catch(e){
      print(e);
    }
  }
}