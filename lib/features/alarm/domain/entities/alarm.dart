class Alarm {
  final String id;
  final String title;
  final DateTime time;
  final bool isActive;
  final List<String> days;
  final String sound;
  final bool isRepeating;

  const Alarm({
    required this.id,
    required this.title,
    required this.time,
    required this.days,
    required this.sound,
    required this.isRepeating,
    this.isActive = true,
  });

  Alarm copyWith({
    String? id,
    String? title,
    DateTime? time,
    bool? isActive,
    List<String>? days,
    String? sound,
    bool? isRepeating,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
      sound: sound ?? this.sound,
      isRepeating: isRepeating ?? this.isRepeating,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time.toIso8601String(),
    'title': title,
    'sound': sound,
    'isRepeating': isRepeating,
    'days': days,
  };

  // Creates the object from a Map
  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
    id: json['id'] as String,
    time: DateTime.parse(json['time'] as String),
    title: json['title'] as String,
    sound: json['sound'] as String,
    isRepeating: json['isRepeating'] as bool,
    days: List<String>.from(json['days'] as List),
  );

  // Validation method used by the Save Button logic
  bool isValid() => days.isNotEmpty;
}
