import 'package:activity_ally/services/Maps/Mapas.dart';
import 'package:activity_ally/services/Maps/Ubicacion.dart';
import 'package:activity_ally/services/Maps/Mapita.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPresenter{

  final Ubicacion ubicacion = Ubicacion();
  Map<String, Marker> markers = {};
  LatLng center = const LatLng (22.767603318399537, -102.56978572343877);
  Mapas? mapa;
  
  void addMarker(String id, double lat, double lng){
    markers[id] =Marker(markerId: MarkerId(id), 
    position: LatLng(lat, lng));
    if(mapa != null){
      mapa!.updateView(LatLng(lat, lng));
    }
  }

  LatLng getMarkerLocation(String id){
    if(markers[id] == null){
      return getDefaultLocation();
    }
    return markers[id]!.position;

  }
  
  LatLng getDefaultLocation(){
    return center;
  }

  Future<LatLng> getCurrentLocation() async{
    Position? poss = await ubicacion.getCurrentLocation();
    if(poss != null){
      return LatLng(poss.latitude, poss.longitude);
    }
    return center;
  }


  Future<void> updateMarkerWithCurrentLocation(String id) async {
    LatLng currentPosition = await getCurrentLocation();
    markers[id] =Marker(markerId: MarkerId(id), position: currentPosition);
    mapa!.updateView(currentPosition);
  }



  Future<LatLng?> showMap(BuildContext context)async{
    var id = await
    Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => Mapita(presenter: this)));
    if(id != null){
      LatLng position = markers[id]!.position;
      return position;
      //'${position.latitude},${position.longitude}';
    }
    return null;
  }

}