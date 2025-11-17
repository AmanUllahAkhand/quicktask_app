class Reminder {
  int? id;
  String title;
  String icon;
  DateTime? date;

  Reminder({this.id, required this.title, required this.icon, this.date});

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'icon': icon,
    'date': date?.toIso8601String(),
  };

  static Reminder fromMap(Map<String, dynamic> map) => Reminder(
    id: map['id'],
    title: map['title'],
    icon: map['icon'],
    date: map['date'] != null ? DateTime.parse(map['date']) : null,
  );
}