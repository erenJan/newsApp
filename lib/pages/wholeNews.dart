import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news/data/news_response.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:news/pages/detailed_new.dart';

class WholeNews extends StatefulWidget {
  WholeNews({Key key}) : super(key: key);

  @override
  _WholeNewsState createState() => _WholeNewsState();
}

class _WholeNewsState extends State<WholeNews> {
  Future<News> getData() async{
    final response = await http.get('http://newsapi.org/v2/top-headlines?country=tr&apiKey=22f686490ffd47b1a102503a6fe2f104');
    return newsFromJson(response.body);
  }
  @override
  void initState(){
    super.initState();
    getData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<News>(
          future:getData(),
          builder: (context,snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height:250,
                      ),
                      CircularProgressIndicator(),
                    ],
                  ),
                );
                break;
                default:
                  if(snapshot.hasError)
                    return Center(
                      child: Text('Hata: ${snapshot.hasError}'),
                    );
                  else
                  
                  return ListView.builder(
                    itemCount:19,//just a max length 
                    itemBuilder: (context,index){
                      List<Article> response = snapshot.data.articles;
                      Article item = response[index];
                      if(item.urlToImage != null){

                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedNew(url: item.urlToImage,content:   item.title,description:item.description,time:item.publishedAt.toString().substring(0,16), name : item.source.name,source:item.url.toString())));
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0,left:10.0,bottom:5.0),
                              child: Container(
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.0),
                                  color: Colors.black.withOpacity(0.03)
                                ),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius:BorderRadius.circular(8.0),
                                      child: Image.network(item.urlToImage,height: 100,width: 150,fit: BoxFit.fitWidth,)
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(top:5.0,left:5.0,right: 5.0),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              width: 230,
                                              height: 56,
                                              child: Text(item.title,style: GoogleFonts.sourceSansPro(fontSize: 14),),
                                            ),
                                            Container(
                                              padding: EdgeInsets.only(top:0.0,right:5.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.end,
                                                children: <Widget>[
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(6.0),
                                                      color: Color.fromRGBO(31, 45, 65, 1)
                                                    ),
                                                    child: Padding(
                                                      padding: EdgeInsets.symmetric(horizontal:2.0,vertical:4.0),
                                                      child: Text(item.publishedAt.toString().substring(0,16),style: GoogleFonts.aldrich(color: Colors.white,fontSize: 10,decoration: TextDecoration.none),),
                                                    )
                                                  ),
                                                ],
                                              )
                                            )
                                          ],
                                        ),
                                      )
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }else{
                        return null;
                      }
                    }
                  );
            }
          }
        )
      ),
    );
  }
}