import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/animation/FadeAnimation.dart';
import 'dart:math';
import 'package:news/pages/wholeNews.dart';
import 'package:news/pages/breakingNewsScroll.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news/login_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  TextEditingController searchQuery;
  String query;
  bool _isSearching = false;

  void initState(){
    super.initState();
    searchQuery = new TextEditingController();
  }
  void startSearch(){
    ModalRoute.of(context).addLocalHistoryEntry(new LocalHistoryEntry(onRemove: stopSearching));
    setState(() {
      _isSearching = true;
    });
  }
  void stopSearching(){
    clearSearchQuery();
    setState(() {
      _isSearching = true;
    });
  }
  void clearSearchQuery(){
    setState(() {
      searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }
  Widget _buildSearchField(){
    return TextField(
      controller: searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
      hintText: 'Search...',
      border: InputBorder.none,
      hintStyle: const TextStyle(
        color:Colors.white
        ),
      ),
        style: const TextStyle(color:Colors.white,fontSize:16.0),
        onChanged: updateSearchQuery,
    );
  }
  void updateSearchQuery(String newQuery){
    setState(() {
      query = newQuery;
    });
  }
  List<Widget> _search(){
    if(_isSearching){
      return <Widget>[
        new IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            if(searchQuery == null  || searchQuery.text.isEmpty){
              _isSearching = ! _isSearching;
            }
            clearSearchQuery();
          },
        )
      ];
    }
    return <Widget>[
      new IconButton(icon: Icon(Icons.search), onPressed: startSearch),
    ];
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        leading: ! _isSearching ? FadeAnimation(1.2, IconButton(icon: Icon(Icons.menu,size: 32,), onPressed: ()=> _scaffoldKey.currentState.openDrawer())):null,
        title: ! _isSearching ? FadeAnimation(1.2, Text('NEWS',style: GoogleFonts.abrilFatface(fontSize: 36),)) : _buildSearchField(),
        actions: _search()
      ),
      drawer: MainDrawer(),
      body: News(),
    );
  }
}
bool ColorSelected = true;
final FirebaseAuth _auth = FirebaseAuth.instance;
class MainDrawer extends StatefulWidget {
  
  const MainDrawer({Key key}) : super(key: key);

  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  @override
  Widget build(BuildContext context) {
    
    return Drawer(
      
      child: Column(
        
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            
            width: double.infinity,
            height: MediaQuery.of(context).size.height/3.8,
            color: Colors.red,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(image:NetworkImage('https://i.pinimg.com/originals/59/ba/8b/59ba8b33595db9bcc18ee5eb3e55c575.jpg'),fit: BoxFit.fill)         
                  ),
                ),
                Positioned(
                  bottom:10,
                  left: 10,
                  child: Text( _auth.currentUser.email ,style: GoogleFonts.sourceSansPro(fontSize: 18,color: Colors.white))
                )
              ],
            )
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Row(
              
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: (){
                    showAboutDialog(
                      context: context,
                      applicationIcon: LogoIcon(),
                      applicationName: 'News App',
                      applicationVersion: '0.0.1',
                      applicationLegalese: 'Delveloped by Erencan EREL'

                    );
                  },
                  child: Container(
                    color: ColorSelected ? Colors.white : Colors.black,
                    child: Row(
                      children: [
                        Icon(Icons.info,size: 22,),
                        SizedBox(width:10),
                        Text('Hakkında',style: GoogleFonts.sourceSansPro(fontSize: 16))
                      ],
                    )
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _auth.signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Icon(Icons.logout,size: 22),
                        SizedBox(width:10),
                        Text('Çıkış Yap',style: GoogleFonts.sourceSansPro(fontSize: 16,color: ColorSelected ? Colors.black : Colors.white))
                      ],
                    ),
                  ),
                )
                
              ],
            ),
          )
        ],
      )
    );
  }
}
//main widget
class News extends StatefulWidget {
  News({Key key}) : super(key: key);

  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: SingleChildScrollView(
         child: Column(
           children: <Widget>[
             FadeAnimation(2.3, BreakingNews()),
             FadeAnimation(2.5, Container(
               height: MediaQuery.of(context).size.height/1.18,
               child: WholeNews(),
             ),)
           ],
         ),
       )
    );
  }
}

//Breaking News
class BreakingNews extends StatefulWidget {
  BreakingNews({Key key}) : super(key: key);

  @override
  _BreakingNewsState createState() => _BreakingNewsState();
}
class _BreakingNewsState extends State<BreakingNews> {
  var currentPage = 5 - 1.0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 5 - 1);
    controller.addListener(() {
      setState(() {
        currentPage = controller.page;
      });
    });
    return Container(
      padding: EdgeInsets.only(left:10.0,top:10.0),
       child: Column(
         children: <Widget>[
           Container(
             padding: EdgeInsets.only(left:3.0),
             alignment: Alignment.centerLeft,
             child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.contain,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Colors.red
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal:10.0,vertical:6.0),
                  child: Text('SON DAKİKA',style: GoogleFonts.aldrich(color: Colors.white,fontSize: 12),),
                )
              )
            ),
           ),
           Stack(
             children: <Widget>[
               BreakingNewsScroll(currentPage),
               Positioned.fill(
                 child: PageView.builder(
                   itemCount: 5,
                   controller: controller,
                   reverse : true,
                   itemBuilder: (context , index){
                     return Container();
                   },
                 )
              )
             ],
           )
         ],
       ),
    );
  }
}