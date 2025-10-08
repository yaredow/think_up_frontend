class Activity {
  final String activity;
  final double availability;
  final String type;
  final int participants;
  final double price;
  final String accessibility;
  final String duration;
  final bool kidFriendly;
  final String link;
  final String key;

  const Activity({
    required this.activity,
    required this.availability,
    required this.type,
    required this.participants,
    required this.price,
    required this.accessibility,
    required this.duration,
    required this.kidFriendly,
    required this.link,
    required this.key,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'activity': String activity,
        'availability': double availability,
        'type': String type,
        'participants': int participants,
        'price': double price,
        'accessibility': String accessibility,
        'duration': String duration,
        'kidFriendly': bool kidFriendly,
        'link': String link,
        'key': String key,
      } =>
        Activity(
          activity: activity,
          availability: availability,
          type: type,
          participants: participants,
          price: price,
          accessibility: accessibility,
          duration: duration,
          kidFriendly: kidFriendly,
          link: link,
          key: key,
        ),
      _ => throw const FormatException('Failed to load activity.'),
    };
  }
}
