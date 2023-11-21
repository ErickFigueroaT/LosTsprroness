import 'package:activity_ally/Presenters/MapPresenter.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class Buscador extends StatefulWidget {
  final MapPresenter presenter;
  const Buscador({super.key, required this.presenter});


  @override
  State<Buscador> createState() => _BuscadorState();
}

class _BuscadorState extends State<Buscador> {
   TextEditingController textController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
  }
  //eso tilin
  @override
  Widget build(BuildContext context) {
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
          //print("placeDetails" + prediction.lat.toString());
          widget.presenter.addMarker('1',double.parse(prediction.lat!), double.parse(prediction.lng!));//helpme to make a latLng with lat antd lng from 
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
}