import 'package:flutter/material.dart';
import 'package:mstra/models/course_model.dart';

class ExpandableContentTile extends StatefulWidget {
  final CourseModel course;
  final Function(int, int) onVideoTap; // Add the onVideoTap callback
  final Function(int) onRecordTap;
  final Function(int) onPdfTap;
  final int? videoIs_free;
  const ExpandableContentTile(
      {Key? key,
      required this.course,
      required this.onVideoTap, // Initialize the callback
      required this.onRecordTap,
      required this.onPdfTap,
      this.videoIs_free})
      : super(key: key);

  @override
  State<ExpandableContentTile> createState() => _ExpandableContentTileState();
}

class _ExpandableContentTileState extends State<ExpandableContentTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Videos Tile
        ExpansionTile(
          title: Text(
            'Videos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: widget.course.videos.isNotEmpty
              ? widget.course.videos.map((video) {
                  return GestureDetector(
                    onTap: () {
                      // Pass both video.id and video.is_free to the onVideoTap callback
                      widget.onVideoTap(video.id, video.is_free!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: video.is_free == 1 || widget.course.hasCourse
                            ? Colors.green[200]
                            : Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("12:00"), // Placeholder for video duration
                          Text(video.title),
                        ],
                      ),
                    ),
                  );
                }).toList()
              : [
                  ListTile(
                    title: Text('No videos available'),
                  ),
                ],
        ),
        Divider(),

        // Records Tile
        ExpansionTile(
          title: Text(
            'Records',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: widget.course.records.isNotEmpty
              ? widget.course.records.map((record) {
                  return GestureDetector(
                    onTap: () {
                      // Handle record tap, e.g., navigate to record player or details screen
                      // Implement your logic here
                      widget.onRecordTap(record.id);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("12:00"), // Placeholder for record duration
                          Text(record.title),
                        ],
                      ),
                    ),
                  );
                }).toList()
              : [
                  ListTile(
                    title: Text('No records available'),
                  ),
                ],
        ),
        Divider(),

        // PDFs Tile
        ExpansionTile(
          title: Text(
            'PDFs',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: widget.course.pdfs.isNotEmpty
              ? widget.course.pdfs.map((pdf) {
                  return GestureDetector(
                    onTap: () {
                      widget.onPdfTap(pdf.id);
                      // Handle PDF tap, e.g., open PDF viewer or download
                      // Implement your logic here
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      padding: const EdgeInsets.all(16),
                      margin: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "12:00"), // Placeholder for PDF details, if needed
                          Text(pdf.title),
                        ],
                      ),
                    ),
                  );
                }).toList()
              : [
                  ListTile(
                    title: Text('No PDFs available'),
                  ),
                ],
        ),
      ],
    );
  }
}
