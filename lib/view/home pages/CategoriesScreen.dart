import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/view/corses%20pages/single_category_courses.dart';
import 'package:mstra/view_models/categories_view_model.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MainCategoryViewModel>(context, listen: false)
        .fetchMainCategories();
  }

  Future<void> _refreshCategories() async {
    await Provider.of<MainCategoryViewModel>(context, listen: false)
        .fetchMainCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MainCategoryViewModel>(
        builder: (context, viewModel, child) {
          return RefreshIndicator(
            onRefresh: _refreshCategories,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              itemCount: viewModel.mainCategories.length,
              itemBuilder: (context, index) {
                final mainCategory = viewModel.mainCategories[index];
                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4), // Shadow position
                      ),
                    ],
                  ),
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    title: Text(
                      mainCategory.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black87,
                      ),
                    ),
                    children: mainCategory.subCategories.map((subCategory) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SubCategoryCoursesScreen(
                                subCategoryId: subCategory.id,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey.shade100,
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            leading: Icon(
                              Icons.subdirectory_arrow_right,
                              color: ColorManager.primary,
                              size: 22.0,
                            ),
                            title: Text(
                              subCategory.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.0,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                              size: 20.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onExpansionChanged: (expanded) {
                      if (expanded && mainCategory.subCategories.isEmpty) {
                        viewModel.fetchSubCategories(mainCategory.id);
                      }
                    },
                    iconColor: Colors.black87,
                    collapsedIconColor: Colors.grey,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
