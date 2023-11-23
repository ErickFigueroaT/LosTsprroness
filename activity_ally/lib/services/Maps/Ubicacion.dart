
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ubicacion{
  Future<Position?> getCurrentLocation() async{
    bool serviceEnabled =  await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled)
    return null;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return null;
      }
    }
    if(permission == LocationPermission.deniedForever){
      return null;
    }
    return await Geolocator.getCurrentPosition();
  }
}