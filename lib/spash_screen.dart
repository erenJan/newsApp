import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/login_page.dart';
import 'package:news/animation/FadeAnimation.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value)=>Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> LoginPage())));
  }


  @override
  Widget build(BuildContext context) {
    return Container(
       child:Scaffold(
         backgroundColor: Color.fromRGBO(170, 80, 80, 1),
         body: SafeArea(
          child: Center(
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                FadeAnimation(1.3, Image.network('https://images-na.ssl-images-amazon.com/images/I/515cl%2B02yjL.png',width: MediaQuery.of(context).size.width/1.7,height: MediaQuery.of(context).size.height/5),),
                SizedBox(height:20),
                FadeAnimation(2.3,Text('NEWS APP',style: GoogleFonts.abrilFatface(fontSize: 36,color: Colors.white),),               )
               ],
             ),
          ),
         ),
       ),
    );
  }
}