class RecordModel {
  final int id;
  final String title;
  final int courseId;
  final String? url;
  final String? record_url;

  RecordModel(
      {required this.id,
      required this.title,
      required this.courseId,
      this.url,
      this.record_url});

  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      id: json['id'],
      title: json['title'],
      courseId: json['course_id'],
      url: json['url'],
      record_url: json["record_url"],
    );
  }
}
