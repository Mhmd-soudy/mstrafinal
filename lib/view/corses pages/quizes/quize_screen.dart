// import 'package:flutter/material.dart';
// import 'package:mstra/models/quiz_questions_model.dart';
// import 'package:mstra/core/utilis/color_manager.dart';
// import 'package:mstra/core/utilis/gradient_background_color.dart';

// class QuizScreen extends StatefulWidget {
//   const QuizScreen({Key? key, required int quizId, required int courseId})
//       : super(key: key);

//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   List<QuizQuestions> questions = [
//     QuizQuestions(
//       id: 1,
//       questionText: "What is Flutter?",
//       options: [
//         Option(id: 1, questionId: 1, optionText: "A framework", isCorrect: 1),
//         Option(
//             id: 2,
//             questionId: 1,
//             optionText: "A programming language",
//             isCorrect: 0),
//         Option(id: 3, questionId: 1, optionText: "An IDE", isCorrect: 0),
//         Option(id: 4, questionId: 1, optionText: "A database", isCorrect: 0),
//       ],
//       quizId: 2,
//     ),
//     QuizQuestions(
//       id: 2,
//       questionText: "Which language does Flutter use?",
//       options: [
//         Option(id: 5, questionId: 2, optionText: "Java", isCorrect: 0),
//         Option(id: 6, questionId: 2, optionText: "Kotlin", isCorrect: 0),
//         Option(id: 7, questionId: 2, optionText: "Dart", isCorrect: 1),
//         Option(id: 8, questionId: 2, optionText: "Swift", isCorrect: 0),
//       ],
//       quizId: 2,
//     ),
//   ];

//   Map<int, String> userAnswers = {};

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Quiz"),
//         backgroundColor: ColorManager.primary,
//       ),
//       body: GradientBackground(
//         child: ListView.builder(
//           padding: const EdgeInsets.all(16.0),
//           itemCount: questions.length,
//           itemBuilder: (context, index) {
//             final question = questions[index];

//             return Card(
//               elevation: 5,
//               margin: const EdgeInsets.only(bottom: 16.0),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       question.questionText,
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black87,
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     ...question.options.map((option) {
//                       return RadioListTile<String>(
//                         contentPadding: EdgeInsets.all(0),
//                         title: Text(option.optionText),
//                         value: option.optionText,
//                         groupValue: userAnswers[index],
//                         onChanged: (value) {
//                           setState(() {
//                             userAnswers[index] = value!;
//                           });
//                         },
//                         tileColor: Colors.grey[50],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         selectedTileColor: Colors.teal[50],
//                       );
//                     }).toList(),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ElevatedButton(
//           onPressed: () {
//             if (userAnswers.length == questions.length) {
//               int score = calculateScore(questions, userAnswers);

//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => QuizResultScreen(
//                     score: score,
//                     questions: questions,
//                     userAnswers: userAnswers,
//                   ),
//                 ),
//               );
//             } else {
//               showDialog(
//                 context: context,
//                 builder: (context) => AlertDialog(
//                   title: Text('Incomplete'),
//                   content:
//                       Text('Please answer all questions before submitting.'),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text('OK'),
//                     ),
//                   ],
//                 ),
//               );
//             }
//           },
//           child: Text("Submit All"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: ColorManager.buttonsColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             padding: EdgeInsets.symmetric(vertical: 16.0),
//             textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//     );
//   }

//   // Score Calculation Function
//   int calculateScore(List<QuizQuestions> questions, Map<int, String> answers) {
//     int score = 0;
//     for (var i = 0; i < questions.length; i++) {
//       final selectedOption = answers[i];
//       final correctOption = questions[i].options.firstWhere(
//             (option) => option.optionText == selectedOption,
//             orElse: () =>
//                 Option(id: 0, questionId: 0, optionText: '', isCorrect: 0),
//           );
//       if (correctOption.isCorrect == 1) {
//         score++;
//       }
//     }
//     return score;
//   }
// }

// class QuizResultScreen extends StatelessWidget {
//   final int score; // Receive score from the previous screen
//   final List<QuizQuestions> questions; // Receive questions and answers
//   final Map<int, String> userAnswers; // Receive user's answers

//   const QuizResultScreen({
//     Key? key,
//     required this.score,
//     required this.questions,
//     required this.userAnswers,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Quiz Results"),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Your Score: $score/${questions.length}",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//             ),
//             SizedBox(height: 20),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: questions.length,
//                 itemBuilder: (context, index) {
//                   final question = questions[index];
//                   final userAnswer = userAnswers[index];
//                   final correctOption = question.options.firstWhere(
//                     (option) => option.isCorrect == 1,
//                   );

//                   bool isCorrect = userAnswer == correctOption.optionText;

//                   return Card(
//                     elevation: 5,
//                     margin: const EdgeInsets.only(bottom: 16.0),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Q${index + 1}: ${question.questionText}",
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.black87,
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             "Your Answer: $userAnswer",
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: isCorrect ? Colors.green : Colors.red,
//                             ),
//                           ),
//                           SizedBox(height: 5),
//                           if (!isCorrect)
//                             Text(
//                               "Correct Answer: ${correctOption.optionText}",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 color: Colors.green,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mstra/models/quiz_questions_model.dart';
import 'package:mstra/view_models/quiz_view_model.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/gradient_background_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizScreen extends StatefulWidget {
  final int quizId; // Pass quizId
  final int courseId; // Pass courseId

  const QuizScreen({
    Key? key,
    required this.quizId,
    required this.courseId,
  }) : super(key: key);

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? userId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch quiz questions with the quizId and courseId
      Provider.of<QuizViewModel>(context, listen: false)
          .fetchQuizQuestions(widget.quizId, widget.courseId, context);

      // Fetch userId from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userId = prefs.getInt('id');
      }); // Assuming userId is stored as an int
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Quiz"),
              shadowColor: ColorManager.grey,
              elevation: 2,
              backgroundColor: ColorManager.primary,
            ),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text("Quiz: ${viewModel.quiz!.title}"),
            shadowColor: ColorManager.grey,
            elevation: 2,
            backgroundColor: ColorManager.primary,
          ),
          body: GradientBackground(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: viewModel.quiz!.questions.length,
              itemBuilder: (context, index) {
                final question = viewModel.quiz!.questions[index];

                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.questionText,
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02),
                        ...question.options.map((option) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  contentPadding: EdgeInsets.all(0),
                                  title: Text(
                                    option.optionText,
                                    style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                  ),
                                  value: option.optionText,
                                  groupValue: viewModel.answers[index],
                                  onChanged: (value) {
                                    setState(() {
                                      viewModel.answers[index] = value!;
                                    });
                                  },
                                  tileColor: Colors.grey[50],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  selectedTileColor: Colors.teal[50],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                print('Answers: ${viewModel.answers}');
                print('All answered: ${viewModel.allAnswered}');

                if (viewModel.allAnswered) {
                  int score = calculateScore(
                      viewModel.quiz!.questions, viewModel.answers);

                  // Submit the score with quizId and courseId
                  viewModel.submitUserScore(
                      context, userId!, widget.quizId, score);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuizResultScreen(
                        score: score,
                        questions: viewModel.quiz!.questions,
                        userAnswers: viewModel.answers,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Incomplete'),
                      content: Text(
                          'Please answer all questions before submitting.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text("Submit All"),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.buttonsColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  // Score Calculation Function
  int calculateScore(List<QuizQuestions> questions, Map<int, String> answers) {
    int score = 0;
    for (var i = 0; i < questions.length; i++) {
      final selectedOption = answers[i];
      final correctOption = questions[i].options.firstWhere(
            (option) => option.optionText == selectedOption,
            orElse: () =>
                Option(id: 0, questionId: 0, optionText: '', isCorrect: 0),
          );
      if (correctOption.isCorrect == 1) {
        score++;
      }
    }
    return score < 0 ? 0 : score;
  }
}

class QuizResultScreen extends StatelessWidget {
  final int score;
  final List<QuizQuestions> questions;
  final Map<int, String> userAnswers;

  const QuizResultScreen({
    Key? key,
    required this.score,
    required this.questions,
    required this.userAnswers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz Results"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Score: $score/${questions.length}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  final userAnswer = userAnswers[index];
                  final correctOption = question.options.firstWhere(
                    (option) => option.isCorrect == 1,
                  );

                  bool isCorrect = userAnswer == correctOption.optionText;

                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Q${index + 1}: ${question.questionText}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Your Answer: $userAnswer",
                            style: TextStyle(
                              fontSize: 16,
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          SizedBox(height: 5),
                          if (!isCorrect)
                            Text(
                              "Correct Answer: ${correctOption.optionText}",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
