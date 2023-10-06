import 'package:flutter/material.dart';
import 'RemBudget.dart';

class badyetHome extends StatelessWidget {
  const badyetHome({super.key});

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
     
      body: Center(
        
        child: Container(
          margin: EdgeInsets.only(top: 100.0), // Adjust the value as needed
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Row(
                children: <Widget>[
                  Container(                    
                    margin: EdgeInsets.only(left: 20.0, right: 20.0),
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20) ,
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
                    
                    ]
                  )
            
                  

                  
                ],
              
              ),
              
  

              

              // Other widgets in your Column
            RemBudget(),  
            ],
          ),
        ),
        
      )
      
    );

  }
}

