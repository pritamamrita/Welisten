// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables


import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:we_listen/SignIn.dart';
import 'package:we_listen/reusableWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List songDetails = [];
  bool flag = true ;
  List songDetailsGlobal  = [] , currPlaylist =[];
  final assetsAudioPlayer = AssetsAudioPlayer();
  


  Future<dynamic> fetch_details() async{
    if(!flag){
      return songDetailsGlobal ;
    }
    flag = false ;
    //songDetails.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref('songs');
    DataSnapshot snapshot = await ref.get() ;
    for(DataSnapshot x in snapshot.children){
      var object = {};
      object["DownloadLink"] = x.child("DownloadLink").value ;
      object["Movie"] = x.child("Movie").value ;
      object["Name"] = x.child("Name").value ;
      object["Singer"] = x.child("Singer").value ;
      String genre = "";
      for(DataSnapshot y in x.child("Genre").children){
              genre += y.key.toString()+"/" ;
      }
      object["genre"] = genre ;
      songDetailsGlobal.add(object) ;
     }
     songDetails.clear();
     print("in loop COUNT");
     songDetails.addAll(songDetailsGlobal) ;
      return songDetails ;
    
  }
  

   playMusic(object)async{
    try {
           
            // setState(() {
            //    currPlaylist.add(object);
            // });
            await assetsAudioPlayer.open(
                  showNotification: true,
                  Audio.network(
                  object["DownloadLink"],
                  metas: Metas(
                    title: object["Name"],
                    artist: object["Singer"],
                    album: object["Movie"]  
                  )),
            )
            ;
        } catch (t) {
            //mp3 unreachable
        }
      }
  
  filterSongs(String textController){
    songDetails.clear();
    //songDetailsGlobal.clear();
    for(var i=0 ; i<songDetailsGlobal.length ; i++){
       if(songDetailsGlobal[i]["Name"].contains(textController)){
            songDetails.add(songDetailsGlobal[i]) ;
           continue ;
             
       }
       if(songDetailsGlobal[i]["Movie"].contains(textController)){
              songDetails.add(songDetailsGlobal[i]) ;
             continue ;
       }
       if(songDetailsGlobal[i]["Singer"].contains(textController)){
              songDetails.add(songDetailsGlobal[i]) ;
             continue ;
       }
       if(songDetailsGlobal[i]["genre"].contains(textController)){
           songDetails.add(songDetailsGlobal[i]) ;
           continue ;
       }
    }
    setState(() {
      
    });
  }
   late Future<dynamic> temp  ;
  @override
      void initState() {
        super.initState();
        temp =  fetch_details() ;
      }
  String userName=FirebaseAuth.instance.currentUser!=null?FirebaseAuth.instance.currentUser!.displayName.toString() : "Unkown" ;
  @override
  Widget build(BuildContext context) {
    
     return SafeArea(
       child: Scaffold(
        appBar:EasySearchBar(
          showClearSearchIcon: true,
         
          backgroundColor: Colors.teal.shade400,
            title: Text(""),
            onSearch: (value) => filterSongs(value),
            searchClearIconTheme: IconThemeData(
              color: Colors.grey.shade900,
              size: 28
            ),
            searchBackgroundColor: Colors.lightBlue.shade100,
            searchBackIconTheme: IconThemeData(
               color: Colors.grey.shade900,
               size: 28 ,
            ),
        ),
          drawer: Drawer(
            width: MediaQuery.of(context).size.width*0.4,
            backgroundColor: Colors.teal.shade100,
            child: ListView(
              padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
              children: [
                // const DrawerHeader(
                //   decoration: BoxDecoration(
                //     color: Colors.blue,
                //   ),
                ////   child: Text(userName),),
                ListTile(
                  title: const Text(
                    'LOG OUT',
                    style: TextStyle(
                      fontSize: 18
                    ),
                  
                  ),
                  leading: Icon(
                    Icons.logout ,
                    size: 26,
                  ),
                  onTap: ()async{
                    await  FirebaseAuth.instance.signOut().then((value) {
                      print("signed out");
                    Navigator.pushAndRemoveUntil(context , MaterialPageRoute(builder:
                    (context) => SignInScreen()),(Route<dynamic> route) => false); 
                    });
                  }
                ),
              ]
            )
          ),
         body: Container(
          decoration: BoxDecoration(
            gradient : LinearGradient(
              colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade200,],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
              ),
          ),
          child: FutureBuilder(
            future: temp,
            builder: (BuildContext context , AsyncSnapshot snapshot){
              if(snapshot.hasData){
                print("length"+songDetails.length.toString());
                return Column(
                  children: [
                      Expanded(
                        child: ListView.builder(
                        itemCount:songDetails.length ,
                        itemBuilder: (context , index){
                        return layout(
                          Object:songDetails[index] , playMusic:playMusic)  ;
                        }
                        ),
                      ),
                     /* Container(
                        height: MediaQuery.of(context).size.height*0.2,
                        width: MediaQuery.of(context).size.width,
                         decoration: BoxDecoration(
                          gradient : LinearGradient(
                            colors: [Colors.blueGrey , Colors.grey ,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            ),
                        ),
                        child: Column(
                          children:[
                            assetsAudioPlayer.isPlaying.value==true?
                            IconButton(
                              iconSize: 50,
                              onPressed: (){
                                 assetsAudioPlayer.pause();
                              }, 
                              icon: Icon(Icons.pause)):
                            IconButton(
                              iconSize: 70,
                              onPressed: (){
                                assetsAudioPlayer.play();
                              },
                              icon: Icon(Icons.play_arrow
                              ),
                            )
                          ]
                        ),
                      )*/
                  ],
                );
              }
              else{
                return Center(child: CircularProgressIndicator(
                  color: Colors.green,
                ));
              }
            }
          ),
        ),
         ),
     );
  }
}