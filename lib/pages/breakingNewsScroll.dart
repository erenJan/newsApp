import 'package:flutter/material.dart';
import 'dart:math';
import 'package:news/data/news_response.dart';
import 'package:http/http.dart' as http;

var cardAspectRatio = 1.3;
var widgetAspectRatio = cardAspectRatio * 1.1 ;

class BreakingNewsScroll extends StatefulWidget {
  var currentPage;
  BreakingNewsScroll(this.currentPage);

  @override
  _BreakingNewsScrollState createState() => _BreakingNewsScrollState();
}

class _BreakingNewsScrollState extends State<BreakingNewsScroll> {
  var padding = 10.0;

  var verticalInsets = 20.0;
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
    return Container(
      child: FutureBuilder<News>(
        future: getData(),
        builder: (context,snapshot){
          switch(snapshot.connectionState){
            case null:
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
                return new AspectRatio(
                  aspectRatio: widgetAspectRatio,
                    child: LayoutBuilder(
                      builder: (context , contraints,){
                        
                        var safeWidth = (contraints.maxWidth) - 0 * padding;
                        var safeHeight = (contraints.maxHeight) - 1 * padding;
                        //primary card
                        var heightOfPrimaryCard = safeHeight;
                        var widthOfPrimarycard = heightOfPrimaryCard * cardAspectRatio;
                        var primaryCardLeft = safeWidth - widthOfPrimarycard;
                        var horizontalInset  = primaryCardLeft / 2;
                        List<Widget> cardList = new List();
                        for(var i = 0 ; i<5; i++){
                          List<Article> response = snapshot.data.articles;
                          Article item = response[i];
                          var delta =  i - widget.currentPage;
                          bool isOnRight = delta > 0 ;
                          var start = padding + max(primaryCardLeft - horizontalInset * -delta *(
                            isOnRight ? 15 : 1),0.0);
                          var cardItem = Positioned.directional(
                            top: padding + verticalInsets * max(-delta, 0.0),
                            bottom: padding + verticalInsets * max(-delta, 0.0),
                            start: start,
                            textDirection: TextDirection.rtl,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(19.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10.0,
                                      spreadRadius: 4
                                    )
                                  ],
                                ),
                                child: AspectRatio(
                                  aspectRatio: cardAspectRatio,
                                  child: Stack(
                                    overflow: Overflow.visible,
                                    fit: StackFit.expand,
                                    children: <Widget>[
                                      Image.network(item.urlToImage,fit: BoxFit.cover),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: InkWell(
                                            onTap: (){print('dsjfhkfjhdsk');},
                                            child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                color: Colors.black.withOpacity(0.5),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 16.0 , vertical: 8.0),
                                                    child: Text(item.title,style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14.0,
                                                      fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ),
                              ),
                            )
                          );
                          cardList.add(cardItem);
                        }
                        return Stack(
                          children: cardList,
                        );
                      } 
                    ),
                  );
                }
        }
      )
    );
  }
}