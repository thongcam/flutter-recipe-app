import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RecipeInformationWidget extends StatelessWidget {
  final String label;
  final Widget icon;

  RecipeInformationWidget({super.key, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(children: [
        SizedBox(width: 16, height: 16, child: icon),
        const SizedBox(
          width: 8,
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.black54),
        )
      ]),
    );
  }
}
