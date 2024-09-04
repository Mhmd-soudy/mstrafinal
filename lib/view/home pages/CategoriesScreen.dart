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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: ColorManager.primary,
        elevation: 0,
        centerTitle: true,
      ),
      body: Consumer<MainCategoryViewModel>(
        builder: (context, viewModel, child) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            itemCount: viewModel.mainCategories.length,
            itemBuilder: (context, index) {
              final mainCategory = viewModel.mainCategories[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: Offset(0, 4), // Shadow position
                    ),
                  ],
                ),
                child: ExpansionTile(
                  tilePadding: EdgeInsets.symmetric(horizontal: 16.0),
                  title: Text(
                    mainCategory.name,
                    style: TextStyle(
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
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey.shade100,
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          leading: Icon(
                            Icons.subdirectory_arrow_right,
                            color: ColorManager.primary,
                            size: 22.0,
                          ),
                          title: Text(
                            subCategory.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Icon(
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
          );
        },
      ),
    );
  }
}
