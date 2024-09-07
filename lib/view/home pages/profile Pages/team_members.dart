import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';

class TeamMembers extends StatelessWidget {
  const TeamMembers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Our Team'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 105, 190, 100), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 80.0),
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Meet our amazing team members',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 25.0),
                  TeamMemberCard(
                    name: 'د. محمد جمال',
                    title: 'مؤسس ومدير تنفيذي',
                    subtitle: 'Founder and CEO',
                    imageUrl: ImageAssets.mohamedGamal,
                  ),
                  SizedBox(height: 16.0),
                  TeamMemberCard(
                    name: 'د. محمد سعودي',
                    title: 'مؤسس مشارك ومدير مالي',
                    subtitle: 'Co-founder and CFO',
                    imageUrl: ImageAssets.soudy,
                  ),
                  SizedBox(height: 16.0),
                  TeamMemberCard(
                    name: 'د. حسين إبراهيم',
                    title: 'مؤسس مشارك',
                    subtitle: 'Co-founder',
                    imageUrl: ImageAssets.hussein,
                  ),
                  SizedBox(height: 16.0),
                  TeamMemberCard(
                    name: 'د. عمر برديسى',
                    title: 'مؤسس مشارك ورئيس قسم التسويق',
                    subtitle: 'Co-founder and Head of Marketing Department',
                    imageUrl: ImageAssets.bardessy,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String title;
  final String subtitle;
  final String imageUrl;

  TeamMemberCard({
    required this.name,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      shadowColor: Colors.blueAccent.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imageUrl),
              backgroundColor: Colors.grey.shade200,
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: const Color.fromARGB(255, 21, 161, 107),
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
