import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Mapa> {
  late GoogleMapController mapController;
  Map<String, Marker> markers = {};
  final LatLng _center = const LatLng(22.767603318399537, -102.56978572343877);
  //final Set<Marker> markers = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Coordenadas'),
        backgroundColor: Colors.green[700],
      ),
      
      body: Stack(
      alignment: Alignment.center,
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            onTap: (position){
              ponMarcador(position);
              //print(position.toString());
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 14.0,
            ),
            markers: markers.values.toSet(),
          ),
        ]
      ),
    );
  }

  ponMarcador(LatLng position){
    setState(() {
      markers.clear;
      markers['1'] =Marker(markerId: MarkerId('1'), position: position);
    });

    return;
  }
}
