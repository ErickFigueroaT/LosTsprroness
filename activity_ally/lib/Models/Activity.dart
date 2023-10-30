class Activity {
  int? id;
  String title;
  DateTime date;
  int duration;
  String? location;
  String? description;
  DateTime? finishDate; // Added finishDate attribute

  Activity({
    this.id,
    required this.title,
    required this.date,
    required this.duration,
    this.location,
    this.description,
    this.finishDate, // Added finishDate parameter in constructor
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
          : null, // Parse finish_date if it exists
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': date.toIso8601String(),
      'duration': duration,
      'location': location,
      'description': description,
      'finish_date': finishDate?.toIso8601String(), // Include finishDate in JSON if it exists
    };
  }
}