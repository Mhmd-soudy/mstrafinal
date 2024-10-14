import 'package:flutter/material.dart';
import 'package:mstra/models/quizzes_results.dart';
import 'package:mstra/services/quizzes_services.dart';

class QuizResultsPage extends StatefulWidget {
  final int userId;

  const QuizResultsPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _QuizResultsPageState createState() => _QuizResultsPageState();
}

class _QuizResultsPageState extends State<QuizResultsPage> {
  late Future<List<QuizResult>> _quizResultsFuture;
  final QuizzesServices _quizzesServices = QuizzesServices();

  @override
  void initState() {
    super.initState();
    _quizResultsFuture = _quizzesServices.fetchQuizResults(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: FutureBuilder<List<QuizResult>>(
          future: _quizResultsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error fetching quiz results: ${snapshot.error}',
                  style: TextStyle(
                      color: Colors.red, fontSize: screenWidth * 0.04),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  'No quiz results available.',
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            final quizResults = snapshot.data!;

            return ListView.builder(
              itemCount: quizResults.length,
              itemBuilder: (context, index) {
                final result = quizResults[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: Card(
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result.quizName!,
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.teal,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),
                          Row(
                            children: [
                              Icon(Icons.school,
                                  color: Colors.teal, size: screenWidth * 0.05),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Text(
                                  'Course Name: ${result.courseName}',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: screenHeight * 0.008),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.teal, size: screenWidth * 0.05),
                              SizedBox(width: screenWidth * 0.015),
                              Expanded(
                                child: Text(
                                  'Mark: ${result.mark}',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.03),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
