import 'package:activity_ally/services/Maps/Mapas.dart';
import 'package:activity_ally/services/Maps/Ubicacion.dart';
import 'package:activity_ally/services/Maps/Mapita.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPresenter{

  final Ubicacion ubicacion = Ubicacion();
  final LatLng center = const LatLng (22.767603318399537, -102.56978572343877);
  late Mapas mapa;
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


  Future<void> updateMarkerWithCurrentLocation() async {
    LatLng currentPosition = await getCurrentLocation();
    mapa.ponMarcador(currentPosition);
  }

  Future<void> changeMarker(double lat, double lng) async {
    mapa.ponMarcador(LatLng(lat, lng));
  }

}