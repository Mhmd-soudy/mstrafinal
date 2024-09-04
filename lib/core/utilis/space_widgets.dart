import 'package:flutter/cupertino.dart';

class HorizintalSpace extends StatelessWidget {
  const HorizintalSpace(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * value,
    );
  }
}

class VerticalSpace extends StatelessWidget {
  const VerticalSpace(this.value, {super.key});
  final double value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * value,
    );
  }
}
