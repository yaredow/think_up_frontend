enum PuzzleCategory { math, sequence, tile }

enum PuzzleDifficulty { easy, medium, hard }

class Alarm {
  final int id;
  final String title;
  final DateTime time;
  final bool isActive;
  final List<String> days;
  final String sound;
  final bool isRepeating;
  final PuzzleCategory puzzleCategory;
  final PuzzleDifficulty puzzleDifficulty;

  const Alarm({
    required this.id,
    required this.title,
    required this.time,
    required this.days,
    required this.sound,
    required this.isRepeating,
    this.isActive = true,
    this.puzzleCategory = PuzzleCategory.math,
    this.puzzleDifficulty = PuzzleDifficulty.easy,
  });

  Alarm copyWith({
    int? id,
    String? title,
    DateTime? time,
    bool? isActive,
    List<String>? days,
    String? sound,
    bool? isRepeating,
    PuzzleCategory? puzzleCategory,
    PuzzleDifficulty? puzzleDifficulty,
  }) {
    return Alarm(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
      sound: sound ?? this.sound,
      isRepeating: isRepeating ?? this.isRepeating,
      puzzleCategory: puzzleCategory ?? this.puzzleCategory,
      puzzleDifficulty: puzzleDifficulty ?? this.puzzleDifficulty,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'time': time.toIso8601String(),
    'title': title,
    'sound': sound,
    'isRepeating': isRepeating,
    'days': days,
    'puzzleType': puzzleCategory.name,
    'puzzleDifficulty': puzzleDifficulty.name,
  };

  factory Alarm.fromJson(Map<String, dynamic> json) {
    final puzzleTypeStr = (json['puzzleType'] as String?) ?? 'math';
    final puzzleDifficultyStr = (json['puzzleDifficulty'] as String?) ?? 'easy';

    final puzzleCategory = PuzzleCategory.values.firstWhere(
      (e) => e.name == puzzleTypeStr,
      orElse: () => PuzzleCategory.math,
    );

    final puzzleDifficulty = PuzzleDifficulty.values.firstWhere(
      (e) => e.name == puzzleDifficultyStr,
      orElse: () => PuzzleDifficulty.easy,
    );

    return Alarm(
      id: json['id'] is int
          ? json['id'] as int
          : int.parse(json['id'].toString()),
      time: DateTime.parse(json['time'] as String),
      title: json['title'] as String,
      sound: json['sound'] as String,
      isRepeating: json['isRepeating'] as bool,
      days: List<String>.from(json['days'] as List),
      puzzleCategory: puzzleCategory,
      puzzleDifficulty: puzzleDifficulty,
    );
  }

  bool isValid() => days.isNotEmpty;
}
