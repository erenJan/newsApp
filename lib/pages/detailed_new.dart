import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedNew extends StatelessWidget {
  final String url;
  final String content;
  final String time;
  final String description;
  final String source;
  final String name;
  const DetailedNew({Key key, @required this.content , @required this.url , @required this.source , @required this.time , @required this.description, @required this.name}) : super(key: key);
  
  
  
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      
      slivers: <Widget>[
        
        SliverAppBar(
          snap: true,
          floating: true,
          expandedHeight: 300,
          backgroundColor: Colors.transparent,
          flexibleSpace: Stack(
            children: [
              Positioned(
                child: Image.network(url,fit:BoxFit.cover),
                top: 0,
                bottom:0,
                left:0,
                right:0
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          child:Container(
            color: Color.fromRGBO(31, 45, 65, 1),
            child:Positioned(
              child: Padding(
                padding: EdgeInsets.only(top:10.0),
                child: Padding(
                  padding: EdgeInsets.only(left:10.0,right:10.0),
                  child: Padding(
                    padding: EdgeInsets.only(top:24.0),
                    child:ReadNew(content:content,url:url,time:time,description: description,source: source, name: name,))
                )
              ),
            )
          )
        )
      ],
    );
  }
}
//read news
class ReadNew extends StatelessWidget {
  final String content;
  final String url;
  final String time;
  final String description;
  final String source;
  final String name;
  const ReadNew({Key key, @required this.content , @required this.url , @required this.source , @required this.time , @required this.description , @required this.name}) : super(key: key);

  _launchURL(source) async{
    String urlR = source.toString();
    if(await canLaunch(urlR)){
      await launch(urlR);
    }else{
      print('Could not launch $urlR');
    }

  }

  @override
  Widget build(BuildContext context) {
    
        return Container(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20.0)
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 0.2
                      )
                    )
                  ),
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/1.4,
                            
                            child : Text(content,textAlign: TextAlign.left,style: GoogleFonts.noticiaText(fontSize: 24,color: Colors.black,decoration: TextDecoration.none)),
                          ),
                          Container(
                            padding: EdgeInsets.only(right:10.0),
                            child: GestureDetector(
                              child: Icon(Icons.share),
                              onTap: (){
                                Share.share(url);
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top:20.0,right:5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                color: Color.fromRGBO(31, 45, 65, 1)
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal:6.0,vertical:5.0),
                                child: Text(time,style: GoogleFonts.aldrich(color: Colors.white,fontSize: 12,decoration: TextDecoration.none),),
                          )
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    child: Text(description,style: GoogleFonts.noticiaText(color: Colors.black,fontSize: 16,decoration: TextDecoration.none),),
                  ),
                  GestureDetector(
                    onTap: (){
                      _launchURL(source);
                    },
                    child: Container(
                      padding: EdgeInsets.only(top:20.0,right:5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Color.fromRGBO(31, 45, 65, 1)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal:6.0,vertical:5.0),
                              child: Text(name,style: GoogleFonts.aldrich(color: Colors.white,fontSize: 12,decoration: TextDecoration.none),),
                            )
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6.0),
                              color: Color.fromRGBO(31, 45, 65, 1)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal:6.0,vertical:5.0),
                              child: Text('Haberin Kaynagı >>>',style: GoogleFonts.aldrich(color: Colors.white,fontSize: 12,decoration: TextDecoration.none),),
                            )
                          ),
                        ],
                      ),
                    ),
                  )
                ],
                
              ),
            )
          ],
        ),
      ),
    );
  }
}