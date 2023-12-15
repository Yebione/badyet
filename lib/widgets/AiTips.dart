import 'package:flutter/material.dart';

class AiTips extends StatelessWidget {
  const AiTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 100,
          width: 230,
          margin: const EdgeInsets.only(left: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Container(
              color: Colors.transparent,
              alignment: Alignment.center, // To center the content
              child: Container(
                height: 100,
                width: 230,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: Colors.green, width: 4), // Green border
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  """You can make money""",
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(right: 30),
          height: 100,
          width: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(81, 218, 96, 1),
          ),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
  
            children: [
              
              Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
              Text(
                "You're In Budget!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14, ),
              )
            ],
          ),
        )
      ],
    );
  }
}
