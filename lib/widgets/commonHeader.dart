import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    String vary = "History";
    return Row(
      children: [
        const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          vary,
          style: const TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
