class RingtoneOption {
  final String id;
  final String name;
  final String assetPath;

  const RingtoneOption({
    required this.id,
    required this.name,
    required this.assetPath,
  });
}

const List<RingtoneOption> kAvailableRingtones = [
  RingtoneOption(
    id: 'alert_alarm',
    name: 'Alert Alarm',
    assetPath: 'assets/ringtones/alert-alarm-1005.wav',
  ),
  RingtoneOption(
    id: 'classic_alarm',
    name: 'Classic Alarm',
    assetPath: 'assets/ringtones/classic-alarm-995.wav',
  ),
  RingtoneOption(
    id: 'digital_clock_buzzer',
    name: 'Digital Clock Buzzer',
    assetPath: 'assets/ringtones/digital-clock-digital-alarm-buzzer-992.wav',
  ),
  RingtoneOption(
    id: 'emergency_alert_alarm',
    name: 'Emergency Alert Alarm',
    assetPath: 'assets/ringtones/emergency-alert-alarm-1007.wav',
  ),
  RingtoneOption(
    id: 'facility_alarm_sound',
    name: 'Facility Alarm Sound',
    assetPath: 'assets/ringtones/facility-alarm-sound-999.wav',
  ),
  RingtoneOption(
    id: 'game_notification_wave',
    name: 'Game Notification Wave',
    assetPath: 'assets/ringtones/game-notification-wave-alarm-987.wav',
  ),
  RingtoneOption(
    id: 'interface_hint_notification',
    name: 'Interface Hint Notification',
    assetPath: 'assets/ringtones/interface-hint-notification-911.wav',
  ),
  RingtoneOption(
    id: 'retro_game_emergency_alarm',
    name: 'Retro Game Emergency Alarm',
    assetPath: 'assets/ringtones/retro-game-emergency-alarm-1000.wav',
  ),
  RingtoneOption(
    id: 'rooster_crowing_in_the_morning',
    name: 'Rooster Crowing in the Morning',
    assetPath: 'assets/ringtones/rooster-crowing-in-the-morning-2462.wav',
  ),
  RingtoneOption(
    id: 'slot_machine_payout_alarm',
    name: 'Slot Machine Payout Alarm',
    assetPath: 'assets/ringtones/slot-machine-payout-alarm-1996.wav',
  ),
  RingtoneOption(
    id: 'sound_alert_in_hall',
    name: 'Sound Alert in Hall',
    assetPath: 'assets/ringtones/sound-alert-in-hall-1006.wav',
  ),
  RingtoneOption(
    id: 'vintage_warning_alarm',
    name: 'Vintage Warning Alarm',
    assetPath: 'assets/ringtones/vintage-warning-alarm-990.wav',
  ),
];
