import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/models/pdf_model.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view/corses%20pages/course_details/expandable_content_list.dart';
import 'package:mstra/view/corses%20pages/pdf_viewer_screen%20.dart';
import 'package:mstra/view/corses%20pages/course_details/related_courses.dart';
import 'package:mstra/view_models/course_detail_view_model.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailScreen extends StatefulWidget {
  final String slug;

  const CourseDetailScreen({
    Key? key,
    required this.slug,
  }) : super(key: key);

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool videoiframe = false; // Set default to false initially
  late WebViewController controller;

  String? contentUrl;
  String? mediaplayer;
  String? accessToken;
  String? userrole;

  @override
  void initState() {
    super.initState();
    // disabledCapture();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    _getAccessToken();
  }

  Future<void> _getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    userrole = prefs.getString("role");
  }

// rec :e58bad8e-75bc-4251-97b0-265e203d7262
  void loadHtmlContent(
    String url,
  ) {
    final String htmlContent = '''
  <html>
  <head>
    <style>
      body { 
        margin: 0; 
        padding: 0; 
        height: 100vh; 
        position: relative;
        overflow: hidden; 
      }
      .iframe-container {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50% , -50%);
        border-radius: 28px;
        overflow: hidden; 
        width: 90%;
        height: 90%;
        border: 0;
        
        
    
        
      }
      .iframe-container iframe {
        width: 100%;
        height: 100%;
        font-size: 50px;
        border: 0;
        

      }
    </style>
  </head>
  <body>
    <div class="iframe-container">
      <iframe
        src="https://iframe.mediadelivery.net/embed/$mediaplayer/$url?autoplay=false&loop=false&muted=false&preload=true&responsive=true"
        loading="lazy"
        allow="accelerometer;gyroscope;autoplay;encrypted-media;picture-in-picture;"
        allowfullscreen="true">
      </iframe>
    </div>
  </body>
</html>
  ''';

    controller.loadHtmlString(htmlContent);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>
          CourseDetailViewModel()..fetchCourseBySlug(widget.slug),
      child: Consumer<CourseDetailViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return Scaffold(
              appBar: AppBar(title: const Text('Course Details')),
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (viewModel.error.isNotEmpty) {
            return Scaffold(
              appBar: AppBar(title: const Text('Course Details')),
              body: Center(child: Text(viewModel.error)),
            );
          }

          final course = viewModel.course;
          if (course == null) {
            return Scaffold(
              appBar: AppBar(title: const Text('Course Details')),
              body: const Center(child: Text('No course data available')),
            );
          }

          return Scaffold(
            appBar: AppBar(title: Text(course.name)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      // Background Cover Image
                      Positioned.fill(
                        child: Image.asset(
                          ImageAssets.cover,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Foreground Content
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                          ),

                          // Centered Container with Image or Video
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: MediaQuery.of(context).size.width * 0.85,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: videoiframe
                                    ? WebViewWidget(controller: controller)
                                    : Image.network(
                                        AppUrl.NetworkStorage + course.image,
                                        fit: BoxFit.cover,
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    child: userrole == "teatcher"
                        ? Text("(${course.studentsCount}) عدد طلاب الكورس",
                            style: Theme.of(context).textTheme.bodyLarge)
                        : SizedBox(),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        child: course.hasCourse
                            ? const SizedBox()
                            : ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    RoutesManager.subscriptionPage,
                                    arguments: course.price,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor:
                                      const Color.fromARGB(255, 93, 142, 92),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        12), // Rounded corners
                                  ),
                                  elevation: 5, // Text color
                                ),
                                child: const Text(
                                  "اشترك الان",
                                  style: TextStyle(
                                    fontSize: 16, // Slightly larger font size
                                    fontWeight: FontWeight
                                        .bold, // Bold text for emphasis
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.25),
                      Flexible(
                        child: Text(
                          course.user.name.toUpperCase(),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: course.user.image != null
                            ? NetworkImage(
                                AppUrl.NetworkStorage + course.user.image!)
                            : null,
                        child: course.user.image == null
                            ? const Icon(Icons.person, size: 20)
                            : null,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Text(
                      "تعرف على الكورس",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.grey),
                    ),
                  ),
                  ExpansionTile(
                    title: Text(
                      course.slug,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    children: [
                      Text(
                        course.description,
                      )
                    ],
                  ),
                  const Divider(),
                  Center(
                    child: Text(
                      "محتوى الكورس",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.grey),
                    ),
                  ),
                  // const Text('Categories:'),
                  // for (var category in course.categories)
                  //   Padding(
                  //     padding: const EdgeInsets.only(left: 8.0),
                  //     child: Text(category.name),
                  //   ),
                  const SizedBox(height: 16),
                  ExpandableContentTile(
                    course: course,
                    onVideoTap: (videoId, video_is_free) async {
                      print(
                          'Video ID tapped============================================== : ${video_is_free}');

                      // Check if accessToken is null
                      if (accessToken == null) {
                        Navigator.pushNamed(context, RoutesManager.loginPage);
                        // Show SnackBar to prompt login
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('من فضلك سجل الدخول اولا')),
                        );
                        return; // Exit early if not logged in
                      }

                      if (accessToken != null &&
                          (course.hasCourse || video_is_free == 1)) {
                        await viewModel.fetchSingleVideo(
                            videoId, course.id, context);

                        if (viewModel.video != null &&
                            viewModel.video!.url != null) {
                          setState(() {
                            videoiframe = true;
                            mediaplayer = "285026";
                            contentUrl = viewModel.video!.url!;
                            loadHtmlContent(contentUrl!);
                          });
                          // Load the video content into the WebView
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to load video.')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('انت غير مشترك فى هذا الكورس')),
                        );
                      }
                    },
                    onRecordTap: (recordId) async {
                      print('ٌRecord ID tapped: $recordId');
                      if (course.hasCourse) {
                        await viewModel.fetchSingleRecord(
                            recordId, course.id, context);

                        if (viewModel.record != null &&
                            viewModel.record!.url != null) {
                          setState(() {
                            videoiframe = true;
                            mediaplayer = "287473";
                            contentUrl = viewModel.record!.url!;
                            loadHtmlContent(contentUrl!);
                          });
                          // Load the record content into the WebView
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to load record.')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('انت غير مشترك فى هذا الكورس')),
                        );
                      }
                    },
                    onPdfTap: (pdfId) async {
                      print('PDF ID tapped: $pdfId');
                      if (course.hasCourse) {
                        await viewModel.fetchSinglePdf(
                            pdfId, course.id, context);

                        if (viewModel.pdf != null &&
                            viewModel.pdf!.url != null) {
                          final pdfUrl = Uri.parse(
                              "${AppUrl.NetworkStorage}${viewModel.pdf!.url}");
                          print(pdfUrl);

                          // Launch the URL in the external browser
                          if (await canLaunchUrl(pdfUrl)) {
                            await launchUrl(
                              pdfUrl,
                              mode: LaunchMode
                                  .externalApplication, // Ensure it opens in an external browser
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Could not launch PDF URL.')),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to load PDF.')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('انت غير مشترك فى هذا الكورس')),
                        );
                      }
                    },
                  ),
                  Center(
                    child: Text(
                      "الكورسات المشابهة",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: ColorManager.grey),
                    ),
                  ),

                  RelatedCourses(
                    categoriesId: viewModel.course!.categories.first.id,
                    courseslug: course.slug,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // disabledCapture() async {
  //   await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  // }
}
