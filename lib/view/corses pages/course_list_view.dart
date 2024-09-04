import 'package:flutter/material.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/routes/routes_manager.dart';
import 'package:mstra/view_models/course_view_model.dart';
import 'package:provider/provider.dart';

class CourseListView extends StatefulWidget {
  @override
  State<CourseListView> createState() => _CourseListViewState();
}

class _CourseListViewState extends State<CourseListView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = Provider.of<CoursesViewModel>(context, listen: false);
      if (viewModel.courses.isEmpty && !viewModel.isLoading) {
        viewModel.fetchCourses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CoursesViewModel>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await viewModel.fetchCourses();
      },
      child: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : viewModel.error.isNotEmpty
              ? Center(child: Text(viewModel.error))
              : GridView.builder(
                  padding: const EdgeInsets.all(12.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: viewModel.courses.length,
                  itemBuilder: (context, index) {
                    final course = viewModel.courses[index];
                    return GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RoutesManager.courseDetailScreen,
                            arguments: course.slug,
                          );
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 255, 255, 255),
                                  Color.fromARGB(255, 255, 255, 255)
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Image Container
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.16,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            AppUrl.NetworkStorage +
                                                course.image),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.003,
                                  ),
                                  // Course Name
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Text(
                                      course.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            const Color.fromARGB(255, 0, 0, 0),
                                      ),
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.003,
                                  ),
                                  // User Information Row
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            course.user.name.toUpperCase(),
                                            textAlign: TextAlign.end,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.035,
                                              color: const Color.fromARGB(
                                                  179, 0, 0, 0),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.02,
                                        ),
                                        CircleAvatar(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          backgroundImage:
                                              course.user.image != null
                                                  ? NetworkImage(
                                                      AppUrl.NetworkStorage +
                                                          course.user.image!)
                                                  : null,
                                          child: course.user.image == null
                                              ? Icon(
                                                  Icons.person,
                                                  size: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.03,
                                                  color: Colors.white,
                                                )
                                              : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.005,
                                  ),
                                  // Price Text
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Text(
                                        "${course.price} جنيه",
                                        style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.03,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));

                    //       Card(
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(20.0),
                    //     ),
                    //     elevation: 6,
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //         borderRadius: BorderRadius.circular(20),
                    //         gradient: LinearGradient(
                    //           colors: [
                    //             const Color.fromARGB(255, 78, 137, 238),
                    //             const Color.fromARGB(255, 46, 150, 58)
                    //           ],
                    //           begin: Alignment.topLeft,
                    //           end: Alignment.bottomRight,
                    //         ),
                    //       ),
                    //       child: Padding(
                    //         padding: const EdgeInsets.all(10.0),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.center,
                    //           children: [
                    //             // Image Container
                    //             Container(
                    //               height:
                    //                   MediaQuery.of(context).size.height * 0.10,
                    //               decoration: BoxDecoration(
                    //                 borderRadius: BorderRadius.circular(16),
                    //                 image: DecorationImage(
                    //                   image: NetworkImage(
                    //                       AppUrl.NetworkStorage + course.image),
                    //                   fit: BoxFit.cover,
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(height: 10.0),
                    //             // Course Name
                    //             Text(
                    //               course.name,
                    //               maxLines: 1,
                    //               overflow: TextOverflow.ellipsis,
                    //               style: TextStyle(
                    //                 fontSize:
                    //                     MediaQuery.of(context).size.width *
                    //                         0.045,
                    //                 fontWeight: FontWeight.bold,
                    //                 color: Colors.white,
                    //               ),
                    //               textAlign: TextAlign.center,
                    //             ),
                    //             SizedBox(height: 8.0),
                    //             // User Information Row
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Expanded(
                    //                   child: Text(
                    //                     course.user.name.toUpperCase(),
                    //                     textAlign: TextAlign.start,
                    //                     maxLines: 1,
                    //                     overflow: TextOverflow.ellipsis,
                    //                     style: TextStyle(
                    //                       fontSize: MediaQuery.of(context)
                    //                               .size
                    //                               .width *
                    //                           0.035,
                    //                       color: Colors.white70,
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 SizedBox(width: 8.0),
                    //                 CircleAvatar(
                    //                   radius:
                    //                       MediaQuery.of(context).size.width *
                    //                           0.04,
                    //                   backgroundImage: course.user.image != null
                    //                       ? NetworkImage(AppUrl.NetworkStorage +
                    //                           course.user.image!)
                    //                       : null,
                    //                   child: course.user.image == null
                    //                       ? Icon(
                    //                           Icons.person,
                    //                           size: MediaQuery.of(context)
                    //                                   .size
                    //                                   .width *
                    //                               0.04,
                    //                           color: Colors.white,
                    //                         )
                    //                       : null,
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(height: 8.0),
                    //             // Price Text
                    //             Align(
                    //               alignment: Alignment.bottomLeft,
                    //               child: Text(
                    //                 "${course.price} جنيه",
                    //                 style: TextStyle(
                    //                   fontSize:
                    //                       MediaQuery.of(context).size.width *
                    //                           0.04,
                    //                   color: Colors.white,
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // );
                  },
                ),
    );
  }
}
