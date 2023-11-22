import 'package:activity_ally/Presenters/MapPresenter.dart';
import 'package:activity_ally/services/Maps/Mapas.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class VistaMapa extends StatefulWidget {
  final MapPresenter presenter;
  const VistaMapa({Key? key, required this.presenter}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<VistaMapa> implements Mapas{
  int currentMarkerIndex = 0;
  late GoogleMapController mapController;
  Map<String, Marker> markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  

  @override
  void initState() {
    widget.presenter.mapa = this;
    widget.presenter.getMarkers(DateTime.now()); //widget.presenter.markers;
    widget.presenter.updateMarkerWithCurrentLocation('usr');
    
    super.initState();
  }


  bool isSearchVisible = false; // Flag to control visibility

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      appBar: AppBar(
        title: const Text('Actividades'),
        backgroundColor: Colors.green[700],
      ),
      
      body: Stack(
      alignment: Alignment.center,
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.presenter.getMarkerLocation('usr'),
              zoom: 14.0,
            ),
            markers: widget.presenter.markers.values.toSet(),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
            padding: EdgeInsets.only(top: 24, right: 12),
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align children to the top
              crossAxisAlignment: CrossAxisAlignment.end, // Align children to the right
              children: [
                const SizedBox(width: 8), // Adjust spacing as needed
                calendar(),
                const SizedBox(height: 20),
                botonCambiar(),
                const SizedBox(height: 20),
                botonUbicacion(),
              ],
            ),)
            ,
          )
        ]
      ),
    );
  }
  calendar(){
    return FloatingActionButton(
      heroTag: 'dates',
      onPressed: () async {
        DateTime? fecha = await pickDate();
        if (fecha != null) {
          setState(() {
            widget.presenter.getMarkers(fecha);
          });
        }
      },
      backgroundColor: Colors.green,
      child: Icon(Icons.calendar_month),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100));

  botonCambiar(){
    return FloatingActionButton(
      heroTag: 'cambiar',
      onPressed:cambiaMarcador,
      backgroundColor: Colors.deepOrangeAccent,
      child: Icon(Icons.fast_forward),
    );
  }

  botonUbicacion(){
    return FloatingActionButton(
      heroTag: 'loc',
      onPressed: () {
        widget.presenter.updateMarkerWithCurrentLocation('usr');
      },
      backgroundColor: Colors.deepPurpleAccent,
      child: const Icon(Icons.emoji_people),
    );
  }

  cambiaMarcador(){
    if (markers.isNotEmpty) {
      List<String> markerIds = markers.keys.toList();
      if (currentMarkerIndex < markerIds.length) {
        String currentMarkerId = markerIds[currentMarkerIndex];
        Marker currentActivity = markers[currentMarkerId]!;
        LatLng position = currentActivity.position;
        mapController.animateCamera(CameraUpdate.newLatLng(position));
        currentMarkerIndex++;

        // Reset to the first marker if we reached the end of the list
        if (currentMarkerIndex == markerIds.length) {
          currentMarkerIndex = 0;
        }
      }
    }
  }



  ponMarcador(LatLng position){
    //print(position.toString());
    widget.presenter.addMarker('1', position.latitude, position.longitude);
  }

  void updateView(LatLng position) async {
    //print(position.toString());
    setState(() {
      markers = widget.presenter.markers;
      mapController.animateCamera(CameraUpdate.newLatLng(position));
    });
  }

}
