class PdfModel {
  final int id;
  final String title;
  final int courseId;
  final String? url;

  PdfModel(
      {required this.id,
      required this.title,
      required this.courseId,
      this.url});

  factory PdfModel.fromJson(Map<String, dynamic> json) {
    return PdfModel(
      id: json['id'],
      title: json['title'],
      courseId: json['course_id'],
      url: json["url"],
    );
  }
}
