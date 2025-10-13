class Alarm {
  final int id;
  final String title;
  final DateTime time;
  final bool isActive;
  final Set<String> days;
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
    int? id,
    String? title,
    DateTime? time,
    bool? isActive,
    Set<String>? days,
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
}
