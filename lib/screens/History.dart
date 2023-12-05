import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key});

  @override
    Widget build(BuildContext context) {
    
       return Scaffold(

        
  //1
  body: CustomScrollView(
    slivers: <Widget>[
      //2
      SliverAppBar(
        leading: Row(
          mainAxisSize: MainAxisSize.min, // keep the row size minimal
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            SizedBox(width: 10), // add some space between icon and title
            Text('Goa', textScaleFactor: 1),
          ],
        ),
        
        expandedHeight: 250.0,
        flexibleSpace: FlexibleSpaceBar(
          title: Text('Goa', textScaleFactor: 1),
          background: Container(
          decoration: BoxDecoration(
                color: Colors.green,
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [
                    const Color.fromRGBO(52, 119, 216, 1),
                    const Color.fromRGBO(81, 218, 96, 1),
                  ],
                ),
              ),
    ),
        ),
        
      ),
      //3
      
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            return ListTile(
              leading: Container(
                  padding: EdgeInsets.all(8),
                  width: 100,
                  child: Placeholder()),
              title: Text('Place ${index + 1}', textScaleFactor: 2),
            );
          },
          childCount: 20,
        ),
      ),
    ],
  ),
  );
    }
}
