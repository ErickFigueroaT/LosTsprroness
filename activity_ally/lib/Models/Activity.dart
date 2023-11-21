import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Import the LatLng class

class Activity {
  int id;
  String title;
  DateTime date;
  int duration;
  String? location;
  String? description;
  DateTime? finishDate;
  DateTime? startDate;
  int? duration_r;
  bool notify; // Added notify attribute
  LatLng? coords; // Added coords attribute

  Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    this.location,
    this.description,
    this.finishDate,
    this.startDate,
    this.duration_r,
    this.notify = false, // Added notify parameter in constructor
    this.coords, // Added coords parameter in constructor
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      date: DateTime.parse(json['date']),
      duration: json['duration'],
      location: json['location'],
      description: json['description'],
      finishDate: json['finish_date'] != null
          ? DateTime.parse(json['finish_date'])
          : null,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'])
          : null,
      duration_r: json['duration_r'],
      notify: json['notify'] != "0", // Parse notify if it exists
      coords: json['latitude'] != null
          ? LatLng(
              json['latitude'],
              json['longitude'],
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    print(coords);
    return {
      'title': title,
      'date': date.toIso8601String(),
      'duration': duration,
      'location': location,
      'description': description,
      'finish_date': finishDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(),
      'duration_r': duration_r,
      'notify': notify, // Include notify in JSON
      'latitude': coords != null ? coords!.latitude : null,
      'longitude': coords != null ? coords!.longitude: null,
           
    };
  }
}
