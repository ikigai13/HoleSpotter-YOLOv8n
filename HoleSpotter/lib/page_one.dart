import 'package:flutter/material.dart';
import 'package:HoleSpotter/page_two.dart';
import 'package:HoleSpotter/view.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'HoleSpotter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.grey[700],
        centerTitle: true,
      ),

      //child : can only have 1 widget only
      //children : can have more than 1 widget
      backgroundColor: Colors.grey[500],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/pothole.png',
            height: 250,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Center(
              child: Text(
                'HoleSpotter',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
//          Container(
//            padding: EdgeInsets.all(10),
//            child: Center(
//              child: MaterialButton(
//                onPressed: () {
//                  // to assign it to the next page
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => PageTwo()));
//                },
//                child: Text(
//                  'About Pothole',
//                  style: TextStyle(color: Colors.white),
//                ),
//                color: Colors.purple,
//              ),
//            ),
//          ),

//          Container(
//            padding: EdgeInsets.all(10),
//            child: Center(
//              child: MaterialButton(
//                onPressed: () {
//                  // to assign it to the next page
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => CameraApp()));
//                },
//                child: Text(
//                  'Real Time Detection',
//                  style: TextStyle(color: Colors.white),
//                ),
//                color: Colors.purple,
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
