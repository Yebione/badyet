import 'package:flutter/material.dart';

class RemBudget extends StatelessWidget {
  const RemBudget({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(30),
          padding: EdgeInsets.only(left: 30.0, top: 27.0),
          height: 130,
          width: 365,
         decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              const Color.fromRGBO(52, 119, 216, 1),
              const Color.fromRGBO(81, 218, 96, 1)
            ])),
                    
         child: Column(
          children: [   

           Align(
            alignment: Alignment.centerLeft,            
            child: Text(
             'REMAINING BUDGET',
             style: TextStyle(
             fontWeight: FontWeight.w300,
             color: Color.fromARGB(255, 255, 255, 255),
             fontSize: 15,
             ),
            ),
          ),

          Align(
            alignment: Alignment.centerLeft, 
            child: Text(
             'PHP 150.00',
              style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 40
             ),
            )
          )

         ],
         ),
      )
    );
  }
}