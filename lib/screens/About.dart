import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text('About'),
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          centerTitle: false,
          leading: BackButton(),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Container(
            margin: EdgeInsets.only(top: 80.0, left: 10, right: 10),
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        'Mashakyja Solutions is a dedicated group of students specializing in the design and development of innovative apps. With a commitment to excellence, they consistently push the boundaries of app development, delivering cutting-edge solutions that reflect both user-centric design and robust functionality.\n\nMeet the team:\n',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),

                //Kyle
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/kyle.png',
                        height: 60, width: 60),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '   Kyle E. Billones\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                          TextSpan(
                            text: '    Project Manager',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(width: 35),

                //Matt
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/matt.png',
                        height: 60, width: 60),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '   Matthew Ariel A. Enarle\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                          TextSpan(
                            text: '    Analyst',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(width: 35),

                //Lecx
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/lecx.png',
                        height: 60, width: 60),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '   Alecxander Jamille Andaya\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                          TextSpan(
                            text: '    Software Developer',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(width: 35),

                //Sheyn
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/sheyn.png',
                        height: 60, width: 60),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '   Shayne B. Yanson\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                          TextSpan(
                            text: '    UI/UX Designer',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                SizedBox(width: 35),

                //Jas
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/jas.png', height: 60, width: 60),
                    RichText(
                      textAlign: TextAlign.left,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: '   Jasper M. Nillos\n',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                          TextSpan(
                            text: '    QA Specialist',
                            style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(0, 0, 0, 0)),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
