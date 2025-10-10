class Alarm {
  final int id;
  final String title;
  final DateTime time;
  final bool isActive;
  final Duration? duration;

  const Alarm({
    required this.id,
    required this.title,
    required this.time,
    this.isActive = true,
    this.duration,
  });

  Alarm copyWith({
    int? id,
    String? title,
    DateTime? time,
    bool? isActive,
    Duration? duration,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      duration: duration ?? this.duration,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Alarm &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          time == other.time &&
          isActive == other.isActive &&
          duration == other.duration;

  @override
  int get hashCode =>
      id.hashCode ^
      title.hashCode ^
      time.hashCode ^
      isActive.hashCode ^
      duration.hashCode;
}
