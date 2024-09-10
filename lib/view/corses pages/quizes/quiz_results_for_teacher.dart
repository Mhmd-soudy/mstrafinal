import 'package:flutter/material.dart';
import 'package:mstra/view_models/quiz_view_model.dart';
import 'package:provider/provider.dart';
import 'package:mstra/models/quizzes_results.dart';

class QuizResultsPageForTeachers extends StatelessWidget {
  final int courseId;
  final int quizId;
  final String quizName;

  const QuizResultsPageForTeachers(
      {Key? key,
      required this.courseId,
      required this.quizId,
      required this.quizName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizViewModel()
        ..fetchQuizResultsByCourseAndQuiz(context, courseId, quizId),
      child: Consumer<QuizViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Scaffold(
              appBar: AppBar(title: Text("quiz Results")),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.errorMessage != null) {
            return Scaffold(
              appBar: AppBar(title: Text("quiz Results")),
              body: Center(child: Text(viewModel.errorMessage!)),
            );
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(quizName),
              backgroundColor: Colors.teal,
            ),
            body: Padding(
              padding: EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Adjust the number of columns based on the screen width
                  int columns = constraints.maxWidth > 600 ? 3 : 2;

                  return ListView(
                    children: [
                      // Header
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        color: Colors.teal[50],
                        child: Text(
                          'Quiz Results',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      // Data Cards
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio:
                              constraints.maxWidth > 600 ? 2 : 1.5,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: viewModel.quizResults.length,
                        itemBuilder: (context, index) {
                          final result = viewModel.quizResults[index];

                          return Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    result.userName ?? 'Unknown User',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Mark: ${result.mark}',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
