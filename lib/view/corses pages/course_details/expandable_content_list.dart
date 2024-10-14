import 'package:flutter/material.dart';
import 'package:mstra/models/course_model.dart';
import 'package:mstra/models/quiz_questions_model.dart';
import 'package:mstra/view/corses%20pages/course_details/audidownloadbutton.dart';
import 'package:mstra/view/corses%20pages/quizes/quiz_results_for_teacher.dart';
import 'package:mstra/view/corses%20pages/quizes/quize_screen.dart';
import 'package:mstra/view/corses%20pages/test.dart';
import 'package:mstra/view/corses%20pages/quizes/quizzes_results.dart';
import 'package:mstra/view_models/AudioViewModel.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpandableContentTile extends StatefulWidget {
  final CourseModel course;
  final Function(int, int) onVideoTap; // Add the onVideoTap callback
  final Function(int) onRecordTap;
  final Function(int) onPdfTap;
  // final Function(int) onQuizTap;
  final int? videoIs_free;
  const ExpandableContentTile({
    Key? key,
    required this.course,
    required this.onVideoTap, // Initialize the callback
    required this.onRecordTap,
    required this.onPdfTap,
    this.videoIs_free,
    // required this.onQuizTap
  }) : super(key: key);

  @override
  State<ExpandableContentTile> createState() => _ExpandableContentTileState();
}

class _ExpandableContentTileState extends State<ExpandableContentTile> {
  String? userRole;
  int? userId;

  @override
  void initState() {
    super.initState();
    _getUserRole();
  }

  Future<void> _getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role');
      userId = prefs.getInt("id"); // Fetch user role from SharedPreferences
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaViewModel = Provider.of<MediaViewModel>(context);

    return Column(
      children: [
        // Videos Tile
        ExpansionTile(
          title: Text(
            'الفيديوهات',
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
                      child: Center(
                        child: Text(video.title),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     // Text("12:00"),
                        //     // Placeholder for video duration
                        //     Text(video.title),
                        //   ],
                        // ),
                      ),
                    ),
                  );
                }).toList()
              : [
                  ListTile(
                    title: Text('لا يوجد فيديوهات متاحة'),
                  ),
                ],
        ),
        Divider(),

        // Records Tile
        ExpansionTile(
          title: Text(
            'الريكوردات',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: widget.course.records.isNotEmpty
              ? widget.course.records.map((record) {
                  return Row(
                    children: [
                      Expanded(
                        // Use Expanded to make the GestureDetector fill available space
                        child: GestureDetector(
                          onTap: () {
                            // Handle record tap, e.g., navigate to record player or details screen
                            // Implement your logic here
                            widget.onRecordTap(record.id);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.course.hasCourse
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            padding: const EdgeInsets.all(16),
                            margin: EdgeInsets.all(8),
                            child: Center(
                              child: Text(record.title),
                            ),
                          ),
                        ),
                      ),
                      // Only show the AudioDownloadButton if the URL exists
                      record.record_url != null && widget.course.hasCourse
                          ? Expanded(
                              child: AudioDownloadButton(
                                audioUrl: record.record_url!,
                                filename:
                                    "${widget.course.name} >>> ${record.title}",
                              ),
                            )
                          : SizedBox
                              .shrink(), // Use SizedBox.shrink() for better readability
                    ],
                  );
                }).toList()
              : [
                  ListTile(
                    title: Text('لا يوجد ريكوردات متاحة'),
                  ),
                ],
        ),
        Divider(),

        // PDFs Tile
        ExpansionTile(
          title: Text(
            'الملفات',
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
                          color: widget.course.hasCourse
                              ? Colors.green[200]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        padding: const EdgeInsets.all(16),
                        margin: EdgeInsets.all(8),
                        child: Center(
                          child: Text(pdf.title),
                          //  Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //         "12:00"), // Placeholder for PDF details, if needed
                          //     Text(pdf.title),
                          //   ],
                          // ),
                        ),
                      ));
                }).toList()
              : [
                  ListTile(
                    title: Text('لا يوجد ملفات متاحة'),
                  ),
                ],
        ),
        // ElevatedButton(
        //     onPressed: () {
        //       Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //               builder: (context) => QuizScreen(
        //                     quizId: 1,
        //                     courseId: widget.course.id,
        //                   )
        //               // TestPage()
        //               ));
        //     },
        //     child: Text("quiz 1")),
        ExpansionTile(
          title: Text(
            'الاختبارات',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          children: widget.course.quizzes.isNotEmpty
              ? widget.course.quizzes.map((quiz) {
                  return Row(
                    children: [
                      // Conditionally render the first widget
                      (userRole == "teacher" &&
                                  userId == widget.course.user.id) ||
                              userRole == "admin"
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          QuizResultsPageForTeachers(
                                        courseId: widget.course.id,
                                        quizId: quiz.id,
                                        quizName: quiz.title,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: widget.course.hasCourse
                                        ? Colors.green[200]
                                        : Colors.grey[200],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(16)),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Center(
                                    child: Text(
                                      "نتائج الاختبار",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox
                              .shrink(), // Display nothing if the condition is false

                      // Space between the two widgets
                      SizedBox(width: 8), // Adjust space as needed

                      // Second widget which should take the remaining space if the first widget is not visible
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to the Quiz Screen
                            if (widget.course.hasCourse) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    quizId: quiz.id, // Pass the quiz id
                                    courseId:
                                        widget.course.id, // Pass the course id
                                  ),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('انت غير مشترك فى الكورس'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.course.hasCourse
                                  ? Colors.green[200]
                                  : Colors.grey[200],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                quiz.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList()
              : [
                  ListTile(
                    title: Text('لا يوجد اختبارات متاحة'),
                  ),
                ],
        ),
      ],
    );
  }
}
