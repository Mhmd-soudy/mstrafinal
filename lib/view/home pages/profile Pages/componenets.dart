// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mstra/core/utilis/color_manager.dart';
import 'package:mstra/core/utilis/space_widgets.dart';

class RowWidget extends StatelessWidget {
  RowWidget({super.key, required this.text, required this.icon, this.ontap});
  late String text;
  IconData icon;
  void Function()? ontap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(
            Icons.arrow_back,
            size: 35,
          ),
          const HorizintalSpace(0.1),
          Text(
            text,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          const HorizintalSpace(0.1),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
                color: ColorManager.profileIconsColor,
                borderRadius: BorderRadius.circular(200)),
            child: Icon(
              icon,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
