import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/assets_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class Subscriptionpage extends StatefulWidget {
  final String coursePrice;

  const Subscriptionpage({
    Key? key,
    required this.coursePrice,
  }) : super(key: key);

  @override
  State<Subscriptionpage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Subscriptionpage> {
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // Handle the error here
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // // Convert coursePrice from String to double
    // double coursePrice = double.tryParse(widget.coursePrice) ?? 0.0;

    // // Calculate 1% of coursePrice
    // double onePercent = coursePrice * 0.01;
    // // Determine the amount to add
    // double amountToAdd = 0;
    // // onePercent > 3 ? onePercent : 3;
    // // Calculate the new price
    // double newPrice = coursePrice + amountToAdd;

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    ImageAssets
                        .vodafonecash, // Update with the correct path if needed
                    width: MediaQuery.of(context).size.width *
                        0.8, // Responsive width
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'كيفية الدفع عن طريق',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'فودافون كاش',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '(1) ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    ' اذهب الي سنترال او محل قريب منك وادفع عن طريق فودافون كاش مبلغ ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "${widget.coursePrice
                    // newPrice.toStringAsFixed(2)
                    }",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'جنيه علي رقم 01040454878',
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '(2) ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    ' قم بتصوير الايصال وابعته علي',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => _launchURL(
                            'https://www.facebook.com/share/GhxRYw5wfiscS9Bj/?mibextid=qi2Omg'), // Replace with actual URL
                        child: const Text(
                          'صفحة الفيس',
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const Text(
                        'او',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextButton(
                        onPressed: () => _launchURL(
                            'https://wa.me/201040454878'), // Replace with actual WhatsApp link
                        child: const Text(
                          'واتساب',
                          style: TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.underline,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    '(3) ',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    ' قم ايضا بارسال اسمك واسم الكورس الذى تريد الاشتراك به ورقم تليفونك وايميلك',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'الذي قمت بالتسجيل به على منصه مسطرة.',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    ' اهلا بك في مجتمع مسطرة استمتع بالكورس وكن قائد المستقبل.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'شكراً لاختيارك مسطر!',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
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
