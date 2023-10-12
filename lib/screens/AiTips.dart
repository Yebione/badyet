import 'package:flutter/material.dart';

class AiTips extends StatelessWidget {
  const AiTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 230,
      margin: EdgeInsets.only(left: 30),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center, // To center the content
          child: Container(            
            height: 100,
            width: 230,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green, width: 2), // Green border
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text (  
              """You can make money""",
              textAlign: TextAlign.center,
            ) ,
          ),
        ),
      ),
    );
  }
}
