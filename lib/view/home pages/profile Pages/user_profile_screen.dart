import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mstra/core/widgets/validators.dart';
import 'package:mstra/models/user_model_auth.dart';
import 'package:mstra/res/app_url.dart';
import 'package:mstra/view_models/user_profile_View_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({Key? key}) : super(key: key);

  Future<User?> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final phone = prefs.getString('phone');
    final id = prefs.getInt('id');
    final userImage = prefs.getString("user_image");

    if (name != null && email != null && phone != null || userImage != null) {
      return User(
          id: id, // Assuming you may get user ID from other sources or need to handle it
          name: name!,
          email: email!,
          phone: phone!,
          image: userImage);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _loadUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(
              child: Text('Error loading data'),
            ),
          );
        }

        final user = snapshot.data;

        if (user == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: const Center(
              child: Text('No user data available'),
            ),
          );
        }

        return ChangeNotifierProvider(
          create: (context) => UserProfileViewModel(),
          child: Consumer<UserProfileViewModel>(
            builder: (context, viewModel, child) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Profile'),
                ),
                body: UserProfileForm(user: user),
              );
            },
          ),
        );
      },
    );
  }
}

class UserProfileForm extends StatefulWidget {
  final User user;

  const UserProfileForm({required this.user});

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneNumberController;
  File? _imageFile;
  // Add a field to hold the image file
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneNumberController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<UserProfileViewModel>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage, // Call _pickImage on tap
                child: Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      width: MediaQuery.of(context).size.height * 0.15,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent,
                            Colors.lightBlueAccent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: _imageFile != null
                            ? Image.file(
                                _imageFile!,
                                fit: BoxFit.cover,
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width:
                                    MediaQuery.of(context).size.height * 0.15,
                              )
                            : widget.user.image != null
                                ? Image.network(
                                    AppUrl.NetworkStorage + widget.user.image!,
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.15,
                                    width: MediaQuery.of(context).size.height *
                                        0.15,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.person,
                                        size:
                                            MediaQuery.of(context).size.height *
                                                0.10,
                                        color: Colors.white,
                                      );
                                    },
                                  )
                                : Icon(
                                    Icons.person,
                                    size: MediaQuery.of(context).size.height *
                                        0.10,
                                    color: Colors.white,
                                  ),
                      ),
                    ),
                    // Add a Positioned widget to place the camera icon at the bottom-right corner
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // Background color for the icon
                        ),
                        padding: const EdgeInsets.all(
                            4), // Padding for better icon appearance
                        child: Icon(
                          Icons.camera_alt,
                          color: const Color.fromARGB(255, 82, 174, 88),
                          size: MediaQuery.of(context).size.width *
                              0.1, // Adjust size as per your preference
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        validator: validateUpdateName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: validateUpdateEmail,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validateUpdatePhoneNumber,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final updatedUser = User(
                              id: widget.user.id,
                              name: _nameController.text.isNotEmpty
                                  ? _nameController.text
                                  : widget.user.name,
                              email: _emailController.text.isNotEmpty
                                  ? _emailController.text
                                  : widget.user.email,
                              phone: _phoneNumberController.text.isNotEmpty
                                  ? _phoneNumberController.text
                                  : widget.user.phone,
                              image: widget.user
                                  .image, // Keep the existing image if no new one
                            );

                            // Pass the image file to the updateUser method
                            await viewModel.updateUser(context, updatedUser,
                                imageFile: _imageFile);

                            if (viewModel.errorMessage != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(viewModel.errorMessage!)),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Profile updated successfully!')),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 93, 142, 92),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text('Update Profile'),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Center(
                        child: Text(
                          "لو محتاج تغير كلمة المرور كلمنا على",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => _launchURL(
                            'https://www.facebook.com/share/GhxRYw5wfiscS9Bj/?mibextid=qi2Omg'), // Replace with actual URL
                        child: const Text(
                          'صفحة الفيسبوك',
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Map<String, String?>> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('name');
    final image = prefs.getString("image");
    return {'name': name, "image": image};
  }
}




// class UserProfileScreen extends StatelessWidget {
//   UserProfileScreen({Key? key}) : super(key: key);

//   Future<User?> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final name = prefs.getString('name');
//     final email = prefs.getString('email');
//     final phone = prefs.getString('phone');
//     final id = prefs.getInt('id');
//     final userImage = prefs.getString("user_image");

//     if (name != null && email != null && phone != null || userImage != null) {
//       return User(
//           id: id, // Assuming you may get user ID from other sources or need to handle it
//           name: name!,
//           email: email!,
//           phone: phone!,
//           image: userImage);
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<User?>(
//       future: _loadUserData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Profile'),
//             ),
//             body: const Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         }

//         if (snapshot.hasError) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Profile'),
//             ),
//             body: const Center(
//               child: Text('Error loading data'),
//             ),
//           );
//         }

//         final user = snapshot.data;

//         if (user == null) {
//           return Scaffold(
//             appBar: AppBar(
//               title: const Text('Profile'),
//             ),
//             body: const Center(
//               child: Text('No user data available'),
//             ),
//           );
//         }

//         return ChangeNotifierProvider(
//           create: (context) => UserProfileViewModel(),
//           child: Consumer<UserProfileViewModel>(
//             builder: (context, viewModel, child) {
//               return Scaffold(
//                 appBar: AppBar(
//                   title: const Text('Profile'),
//                 ),
//                 body: UserProfileForm(user: user),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
// }

// class UserProfileForm extends StatefulWidget {
//   final User user;

//   const UserProfileForm({required this.user});

//   @override
//   _UserProfileFormState createState() => _UserProfileFormState();
// }

// class _UserProfileFormState extends State<UserProfileForm> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _emailController;
//   late TextEditingController _phoneNumberController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.user.name);
//     _emailController = TextEditingController(text: widget.user.email);
//     _phoneNumberController = TextEditingController(text: widget.user.phone);
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _phoneNumberController.dispose();

//     super.dispose();
//   }

//   Future<void> _launchURL(String url) async {
//     final Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri);
//     } else {
//       // Handle the error here
//       print('Could not launch $url');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final viewModel = Provider.of<UserProfileViewModel>(context);

//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Center(
//               child: Container(
//                 height: MediaQuery.of(context).size.height * 0.15,
//                 width: MediaQuery.of(context).size.height *
//                     0.15, // Square container
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [
//                       Colors.blueAccent,
//                       Colors.lightBlueAccent,
//                     ],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       spreadRadius: 2,
//                       blurRadius: 5,
//                       offset: Offset(0, 3), // Shadow position
//                     ),
//                   ],
//                 ),
//                 child: GestureDetector(onTap: (){},
//                   child: ClipOval(
//                     child: widget.user.image != null
//                         ? Image.network(
//                             AppUrl.NetworkStorage + widget.user.image!,
//                             fit: BoxFit.cover,
//                             height: MediaQuery.of(context).size.height * 0.15,
//                             width: MediaQuery.of(context).size.height * 0.15,
//                             errorBuilder: (context, error, stackTrace) {
//                               // Display a fallback icon if the image fails to load
//                               return Icon(
//                                 Icons.person,
//                                 size: MediaQuery.of(context).size.height * 0.10,
//                                 color: Colors.white,
//                               );
//                             },
//                           )
//                         : Icon(
//                             Icons.person,
//                             size: MediaQuery.of(context).size.height * 0.10,
//                             color: Colors.white,
//                           ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 15,
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 10,
//                     offset: const Offset(0, 4), // Shadow position
//                   ),
//                 ],
//               ),
//               child: Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       TextFormField(
//                         controller: _nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 10),
//                         ),
//                         validator: validateUpdateName,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'Email',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 10),
//                         ),
//                         keyboardType: TextInputType.emailAddress,
//                         validator: validateUpdateEmail,
//                       ),
//                       const SizedBox(height: 16),
//                       TextFormField(
//                         controller: _phoneNumberController,
//                         decoration: const InputDecoration(
//                           labelText: 'Phone Number',
//                           border: OutlineInputBorder(),
//                           contentPadding: EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 10),
//                         ),
//                         keyboardType: TextInputType.phone,
//                         validator: validateUpdatePhoneNumber,
//                       ),
//                       const SizedBox(height: 32),
//                       ElevatedButton(
//                         onPressed: () async {
//                           if (_formKey.currentState!.validate()) {
//                             final updatedUser = User(
//                               id: widget.user.id,
//                               name: _nameController.text.isNotEmpty
//                                   ? _nameController.text
//                                   : widget.user.name,
//                               email: _emailController.text.isNotEmpty
//                                   ? _emailController.text
//                                   : widget.user.email,
//                               phone: _phoneNumberController.text.isNotEmpty
//                                   ? _phoneNumberController.text
//                                   : widget.user.phone,
//                             );

//                             await viewModel.updateUser(context, updatedUser);

//                             if (viewModel.errorMessage != null) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(
//                                     content: Text(viewModel.errorMessage!)),
//                               );
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content:
//                                         Text('Profile updated successfully!')),
//                               );
//                             }
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                               const Color.fromARGB(255, 93, 142, 92),
//                           padding: EdgeInsets.symmetric(
//                               horizontal: 24, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 5,
//                         ),
//                         child: const Text('Update Profile'),
//                       ),
//                       SizedBox(
//                         height: MediaQuery.of(context).size.height * 0.03,
//                       ),
//                       Center(
//                         child: Text(
//                           "لو محتاج تغير كلمة المرور كلمنا على",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16.0,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () => _launchURL(
//                             'https://www.facebook.com/share/GhxRYw5wfiscS9Bj/?mibextid=qi2Omg'), // Replace with actual URL
//                         child: const Text(
//                           'صفحة الفيسبوك',
//                           style: TextStyle(
//                             fontSize: 18,
//                             decoration: TextDecoration.underline,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<Map<String, String?>> _loadUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final name = prefs.getString('name');
//     final image = prefs.getString("image");
//     return {'name': name, "image": image};
//   }
// }
