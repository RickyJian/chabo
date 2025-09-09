abstract class AlarmRingtone {
  final String name;
  final String uri;

  const AlarmRingtone({required this.name, required this.uri});

  Map<String, dynamic> toJson();
}

class SystemAlarmRingtone extends AlarmRingtone {
  SystemAlarmRingtone({required super.name, required super.uri});

  factory SystemAlarmRingtone.fromJson(Map<String, dynamic> json) {
    return SystemAlarmRingtone(name: json['name'], uri: json['uri']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {'name': name, 'uri': uri};
  }
}
