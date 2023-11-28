import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/avatar.jpg'),
                ),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Today is Thursday',
                      style: TextStyle(
                          color: Colors.green[400],
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                      // Text properties here
                    ),
                    Text(
                      'September 11',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                      textAlign: TextAlign.left,
                      // Text properties here
                    ),
                  ]),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left: 20.0, right: 20.0),
            child: TextButton(
              onPressed: () {
                // Your button's action goes here
              },

              style: TextButton.styleFrom(
                primary: Colors.grey.shade300, // Text color
                padding: EdgeInsets.only(top:0.5 , bottom: 0.5, right: 16, left: 16), // Padding around the text
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto' // Set the font weight to bold
                ),
                // Text style
                backgroundColor: Colors.grey.shade700, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30), // Adjust the value to control corner radius
                ),
              ),
              child: Text("HELP"), // Text displayed on the button
            ),
          ),
        ],
      ),
    );
  }
}
