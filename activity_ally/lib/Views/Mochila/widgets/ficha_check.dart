import 'dart:io';
import 'package:activity_ally/Api/ChecklistCRUD.dart';
import 'package:flutter/material.dart';
import 'package:activity_ally/Views/Mochila/widgets/Info.dart';

class FichaC extends StatefulWidget {
  final int act_id;
  final int id;
  final String descripcion;
  final String titulo;
  final bool estado;
  final String? foto;
  const FichaC(
      {required this.act_id,
      required this.id,
      required this.titulo,
      required this.descripcion,
      required this.estado,
      required this.foto});

  @override
  State<FichaC> createState() => _FichaCState();
}

class _FichaCState extends State<FichaC> {
  

  @override
  Widget build(BuildContext context) {
    var image;
    bool checkin;
      if (widget.foto == null){
        image = new AssetImage('res/placeholder.jpg');
      }
      else{
        image = FileImage(File(widget.foto!));
      }
    return Material(
      child: InkWell(
        onTap: () {},
        splashColor: Colors.blueGrey,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 1),
          ),
          child: Row( // Wrap with Row
            children: [
              SizedBox(// Add Checkbox widget here
                child:
                FutureBuilder<bool>(
                  future: ChecklistCRUD.instance.inCheck(widget.act_id, widget.id),
                  builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // While the Future is still loading, return a loading indicator.
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // If there's an error, return an error message.
                      return Text('Error: ${snapshot.error}');
                    } else {
                      checkin = snapshot.data!;
                      return Checkbox(
                        value: checkin,
                        onChanged: (bool? newValue) async {
                          // Update the checkin value and the database
                          checkin = newValue!;
                          if (checkin) {
                            await ChecklistCRUD.instance.insertActivity_Object(widget.act_id, widget.id);
                          } else {
                            await ChecklistCRUD.instance.delete(widget.act_id, widget.id);
                          }
                          setState(() {});
                        },
                      );
                    }
                  },
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 80,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                        image: DecorationImage(
                          image: image,
                        ),
                      ),
                    ),
                    Container(
                      width: double.maxFinite,
                      decoration: const BoxDecoration(color: Colors.white54),
                      child: Text(
                        widget.titulo,
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}