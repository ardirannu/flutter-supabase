class Note {
  final int id;
  final int userId;
  final String title;
  final String desc;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.userId,
    required this.title,
    required this.desc,
    required this.createdAt,
  });

  // Factory method to create a Note from JSON
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      desc: json['desc'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  // Method to convert a Note object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'desc': desc,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
