import 'package:activity_ally/Presenters/MapPresenter.dart';
import 'package:activity_ally/services/Maps/Buscador.dart';
import 'package:activity_ally/services/Maps/Mapas.dart';
import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Mapita extends StatefulWidget {
  final MapPresenter presenter;
  const Mapita({Key? key, required this.presenter}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Mapita> implements Mapas{
  late GoogleMapController mapController;
  Map<String, Marker> markers = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    widget.presenter.mapa = this;
    markers = widget.presenter.markers;
    super.initState();
  }


  bool isSearchVisible = false; // Flag to control visibility

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
            },
            initialCameraPosition: CameraPosition(
              target: widget.presenter.getMarkerLocation('1'),
              zoom: 14.0,
            ),
            markers: widget.presenter.markers.values.toSet(),
          ),
          Container(
            padding: EdgeInsets.only(top: 24, right: 12),
            alignment: Alignment.topRight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align children to the top
              crossAxisAlignment: CrossAxisAlignment.end, // Align children to the right
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Visibility(
                      visible: isSearchVisible,
                      child: Expanded(
                        child: Buscador(presenter: widget.presenter),
                      ),
                    ),
                    const SizedBox(width: 8), // Adjust spacing as needed
                    FloatingActionButton(
                      heroTag: 'search',
                      onPressed: () {
                        setState(() {
                          isSearchVisible = true;
                        });
                      },
                      backgroundColor: Colors.green,
                      child: Icon(Icons.search),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  heroTag: 'loc',
                  onPressed: () {
                    widget.presenter.updateMarkerWithCurrentLocation('1');
                  },
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(Icons.add_location),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  heroTag: 'paloma',
                  onPressed: () {
                    if(widget.presenter.markers.isEmpty){
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Primero agrega un marcador'),
                        backgroundColor:
                            Colors.red, // Set snackbar color to red
                      ),
                    );
                      return;}
                    else{
                      Navigator.of(context).pop('1');
                    }
                  },
                  backgroundColor: Colors.deepOrangeAccent,
                  child: Icon(Icons.done),
                ),
              ],
            ),
          )
        ]
      ),
    );
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
