class NoteModel {
  final int? id;
  final String? subject;
  final String? content;
  final String? date;

  NoteModel({this.id, this.subject, this.content, this.date});

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      subject: json['subject'],
      content: json['content'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'content': content,
      'date': date,
    };
  }
}
