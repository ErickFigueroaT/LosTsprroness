class Activity {
  int id;
  String title;
  DateTime date;
  int duration;
  String? location;
  String? description;
  DateTime? finishDate;
  DateTime? startDate; // Added startDate attribute
  int? duration_r; // Added duration_r attribute

  Activity({
    required this.id,
    required this.title,
    required this.date,
    required this.duration,
    this.location,
    this.description,
    this.finishDate,
    this.startDate, // Added startDate parameter in constructor
    this.duration_r, // Added duration_r parameter in constructor
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
          : null, // Parse start_date if it exists
      duration_r: json['duration_r'], // Parse duration_r if it exists
    );
  }

  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'duration': duration,
      'location': location,
      'description': description,
      'finish_date': finishDate?.toIso8601String(),
      'start_date': startDate?.toIso8601String(), // Include startDate in JSON if it exists
      'duration_r': duration_r, // Include duration_r in JSON if it exists
    };
  }
}