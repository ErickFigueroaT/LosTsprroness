import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class Mapa extends StatefulWidget {
  const Mapa({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Mapa> {
   TextEditingController textController = TextEditingController();
  late GoogleMapController mapController;
  Map<String, Marker> markers = {};
  final LatLng _center = const LatLng(22.767603318399537, -102.56978572343877);
  //final Set<Marker> markers = {};
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
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
              target: _center,
              zoom: 14.0,
            ),
            markers: markers.values.toSet(),
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
                        child: placesAutoCompleteTextField(),
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
                  heroTag: 'hi',
                  onPressed: () {
                    updateMarkerWithCurrentLocation();
                  },
                  backgroundColor: Colors.deepPurpleAccent,
                  child: const Icon(Icons.add_location),
                ),
                const SizedBox(height: 20),
                FloatingActionButton(
                  heroTag: 'paloma',
                  onPressed: () {
                    Navigator.of(context).pop(true);
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

  Future<void> updateMarkerWithCurrentLocation() async {
    LatLng currentPosition = await getCurrentLocation();
    ponMarcador(currentPosition);
  }

  ponMarcador(LatLng position){
    //print(position.toString());
    setState(() {
      markers['1'] =Marker(markerId: MarkerId('1'), position: position);
      mapController.animateCamera(CameraUpdate.newLatLng(position));
    });

    return;
  }
  
  placesAutoCompleteTextField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: textController,
        googleAPIKey: "AIzaSyAg9zP-8A9y-byDa9SuzzFexkr8226omI0",
        boxDecoration: 
         BoxDecoration(
          color: Colors.white, // Set your desired background color
          borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2), // Adjust the shadow offset as needed
            ),
          ],
        ),
        inputDecoration: InputDecoration(
          hintText: "Escribe aqui",
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
        ),
        debounceTime: 400,
        countries: ["mx"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          print("placeDetails" + prediction.lat.toString());
          ponMarcador(
              LatLng(double.parse(prediction.lat!), double.parse(prediction.lng!))
            );//helpme to make a latLng with lat antd lng from 
        },

        itemClick: (Prediction prediction) {
          textController.text = prediction.description ?? "";
          textController.selection = TextSelection.fromPosition(
              TextPosition(offset: prediction.description?.length ?? 0));
          //helpme to make a latLng with lat antd lng from prediction
        },

        seperatedBuilder: Divider(),
        // OPTIONAL// If you want to customize list view item builder
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(
                  width: 7,
                ),
                Expanded(child: Text("${prediction.description??""}"))
              ],
            ),
          );
        },

        isCrossBtnShown: true,

        // default 600 ms ,
      ),
    );
  }


  Future<LatLng> getCurrentLocation() async{
    bool serviceEnabled =  await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled)
    return _center;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        return _center;
      }
    }
    if(permission == LocationPermission.deniedForever){
      return _center;
    }
    Position poss = await Geolocator.getCurrentPosition();
    return await LatLng(poss.latitude, poss.longitude);

  }
}
