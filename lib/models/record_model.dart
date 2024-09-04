class RecordModel {
  final int id;
  final String title;
  final int courseId;
  final String? url;

  RecordModel(
      {required this.id,
      required this.title,
      required this.courseId,
      this.url});

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      title: json['title'],
      courseId: json['course_id'],
      url: json['url'],
    );
  }
}
