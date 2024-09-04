class VideoModel {
  final int id;
  final String title;
  final String? url;
  final int? is_free; // Add URL if it's in the response

  VideoModel({
    required this.id,
    required this.title,
    this.url,
    this.is_free,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
        id: json['id'],
        title: json['title'],
        url: json['url'],
        is_free:
            json["is_free"] ?? 0 // Adjust according to your actual response
        );
  }
}
