// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, unused_local_variable, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables


import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:marquee/marquee.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:we_listen/SignIn.dart';
import 'package:we_listen/reusableWidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List songDetails = [] , myPlaylist=[] , songid=[];
  bool flag = true , playerStarted=false;
  List songDetailsGlobal  = [] ;
  List<Audio> currPlaylist =[];
  final assetsAudioPlayer = AssetsAudioPlayer();
  Duration progress = Duration() , total =Duration() ;
  FirebaseAuth auth = FirebaseAuth.instance ;


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
      object["songid"] = x.key.toString();
      songDetailsGlobal.add(object) ;
      print(object.toString());
     }
     songDetails.clear();
     print("in loop COUNT");
    
     songDetails.addAll(songDetailsGlobal) ;
      
    
    return songDetails ;
    
  }



  showPlaylist()async{
          myPlaylist.clear();
          songid.clear();
           print('00::::::::::::::::::::::::::::::');
           String userId = auth.currentUser!.uid.toString();
           DatabaseReference ref = FirebaseDatabase.instance.ref('user_auth/$userId') ;
            Stream<DatabaseEvent> stream = ref.onValue ;
            await stream.listen((event) {
              print('11::::::::::::::::::::::::::::::');
              DataSnapshot snapshot = event.snapshot ;
              for(DataSnapshot y in snapshot.child("playlist").children){
                songid.add(y.key.toString()) ;
              }
            });
            DatabaseReference songRef = FirebaseDatabase.instance.ref('songs');
            Stream<DatabaseEvent> streamSong = songRef.onValue ;
            await streamSong.listen((songsevent) {
              print('22::::::::::::::::::::::::::::::');
              DataSnapshot songs = songsevent.snapshot ;
             //print(songs.value);
              for(int i=0 ; i<songid.length ; i++){
                final x = songs.child(songid[i]);
                var object ={};
                object["DownloadLink"] = x.child("DownloadLink").value ;
                object["Movie"] = x.child("Movie").value ;
                object["Name"] = x.child("Name").value ;
                object["Singer"] = x.child("Singer").value ;
                String genre = "";
                for(DataSnapshot y in x.child("Genre").children){
                        genre += y.key.toString()+"/" ;
                }
                object["genre"] = genre ;
                object["songid"] = x.key.toString();
                myPlaylist.add(object);
                          
              }
              songDetails.clear();
              songDetails.addAll(myPlaylist);
              print(songDetails.length) ;
              print(myPlaylist.length);
              setState(() {
                
              });
           });
    }

   

  showAllSong(){
    songDetails.clear() ;
    songDetails.addAll(songDetailsGlobal);
    setState(() {
      
    });
  }


   playMusic(object)async{
    try {
            //currPlaylist.clear();
            currPlaylist.insert(0,Audio.network(
                  object["DownloadLink"],
                  metas: Metas(
                    title: object["Name"],
                    artist: object["Singer"],
                    album: object["Movie"]  
                  )),);
                  print(currPlaylist.toString());                                     
                  print("-------------------");
             await assetsAudioPlayer.open(
                  Playlist(
                     audios:currPlaylist 
                  ),
                  showNotification: true,
                  // Audio.network(
                  // object["DownloadLink"],
                  // metas: Metas(
                  //   title: object["Name"],
                  //   artist: object["Singer"],
                  //   album: object["Movie"]  
                  // )),
            ).then((value){
              
              print("---- PLAYING");
            });
            //assetsAudioPlayer.playlistAudioFinished(){}
            // print(assetsAudioPlayer.currentPosition.value.toString());
            // print(assetsAudioPlayer.current.value.toString());
            //print(assetsAudioPlayer.current.value!.audio.duration.toString());
            //print('-----------------------------');
            setState(() {
                
                playerStarted = true ;
                
              });
            }catch (t) {
              print("in PLAYER----------------------------------------------------------");
              print(t);
                //mp3 unreachable
            }
      }

    addToPlaylist(object) async{
        //  currPlaylist.add(Audio.network(
        //           object["DownloadLink"],
        //           metas: Metas(
        //             title: object["Name"],
        //             artist: object["Singer"],
        //             album: object["Movie"]  
        //           )),);
        String userId = auth.currentUser!.uid.toString();
        String songid = object["songid"];
         DatabaseReference userdetail = FirebaseDatabase.instance.ref('user_auth/$userId/playlist') ;
            final snapshot = await userdetail.get();
            userdetail.update({
            object["songid"] :true
        });
        setState(() {
        
        });
        //assetsAudioPlayer.readingPlaylist;
        // print(currPlaylist.toString());
        print("-------------------");
        print(object["songid"]);
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
 // String userName=FirebaseAuth.instance.currentUser!=null?FirebaseAuth.instance.currentUser!.displayName.toString() : "Unkown" ;
  @override
  Widget build(BuildContext context) {
    
     return SafeArea(
       child: Scaffold(
        appBar:EasySearchBar(
          showClearSearchIcon: true,
            backgroundColor:  Colors.cyan.shade100,
            title: Text(""),
            onSearch: (value) => filterSongs(value),
            searchClearIconTheme: IconThemeData(
              color: Colors.grey.shade900,
              size: 28
            ),
            searchBackgroundColor: Colors.lightBlue.shade50,
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
          color: Colors.cyan.shade50 ,
          child: FutureBuilder(
            future: temp,
            builder: (BuildContext context , AsyncSnapshot snapshot){
              if(snapshot.hasData){
                // currPlaylist.add(
                //   Audio.network(
                //   songDetails[0]["DownloadLink"],
                //   metas: Metas(
                //     title:  songDetails[0]["Name"],
                //     artist: songDetails[0]["Singer"],
                //     album: songDetails[0]["Movie"]  
                //   )),
                // );
                print("length"+songDetails.length.toString());
                return Column(
                  children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                          TextButton(
                            onPressed: (){
                              print('here it goesssssssssssssssssssssss');
                                 showPlaylist();
                            },
                             child: Text(
                                "My Playlist",
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                    // decoration: TextDecoration.underline,
                                    // decorationStyle: TextDecorationStyle.wavy
                                   ),
                             )
                             ),
                             SizedBox(width: 20,),
                             TextButton(
                              onPressed: (){
                                showAllSong();
                              },
                              child: Text(
                                  "All Songs",
                                 style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal,
                                   ),
                              )
                             )
                         ],
                      ),
                      Expanded(
                        child: ListView.builder(
                        itemCount:songDetails.length ,
                        itemBuilder: (context , index){
                        return layout(
                          Object:songDetails[index] , playMusic:playMusic ,
                          addToPlaylist : addToPlaylist)  ;
                        }
                        ),
                      ),
                      playerStarted==true?
                      Container(
                        height: MediaQuery.of(context).size.height*0.19,
                        width: MediaQuery.of(context).size.width,
                         decoration: BoxDecoration(
                          boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: const Offset(
                                    5.0,
                                    5.0,
                                  ),
                                  blurRadius: 10.0,
                                  spreadRadius: 2.0,
                                ), //BoxShadow
                                 //BoxShadow
                              ],
                          borderRadius: BorderRadius.circular(20),
                          gradient : LinearGradient(
                            colors: [ Colors.teal.shade100,Colors.cyan.shade100 , Colors.lightBlueAccent.shade100,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            ),
                        ),
                        
                        child: 
                        Column(
                          children:[
                            Row(
                               children: [
                                  // child: Text(
                                  //   assetsAudioPlayer.getCurrentAudioTitle.toString(),
                                  //   style: TextStyle(
                                  //     fontSize: 20,
                                  //   ),
                                  // ),
                                  
                                  Flexible(
                                        flex: 1,
                                        fit: FlexFit.loose,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 2 , vertical: MediaQuery.of(context).size.height*0.02
                                          ),
                                          child: TextScroll(
                                                                              
                                          assetsAudioPlayer.getCurrentAudioTitle+"  |  "+assetsAudioPlayer.getCurrentAudioArtist+"  |  " +
                                          assetsAudioPlayer.getCurrentAudioAlbum + "  |  ",
                                          velocity: Velocity(pixelsPerSecond: Offset(50, 0)),
                                          delayBefore: Duration(milliseconds: 500),
                                          
                                          pauseBetween: Duration(milliseconds: 50),
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context).size.height*0.026,
                                            letterSpacing: 0.8,
                                            wordSpacing: 1,
                                            ),
                                          textAlign: TextAlign.right,
                                          selectable: true,
                                                                            ),
                                        ),
                                  )
                                
                               ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  IconButton(
                                    onPressed:()async{
                                      await assetsAudioPlayer.previous();
                                      setState(() {
                                        
                                      });
                                    }, 
                                    icon: Icon(Icons.skip_previous),
                                    iconSize: 40,
                                  ),
                                  SizedBox(width: 30,),
                                
                                  assetsAudioPlayer.isPlaying.value==true?
                                  IconButton(
                                    iconSize: 40,
                                    onPressed: ()async{
                                      await assetsAudioPlayer.pause();
                                      setState(() {
                                        
                                      });
                                      print("in pause");
                                    }, 
                                    icon: Icon(Icons.pause)
                                  ):
                                  IconButton(
                                    iconSize: 40,
                                    onPressed: ()async{
                                      print("in play");
                                      await assetsAudioPlayer.play();
                                      setState(() {
                                        
                                      });
                                    },
                                    icon: Icon(Icons.play_arrow
                                    ),
                                  ),
                                  SizedBox(width: 30,),
                                  IconButton(
                                    onPressed:()async{
                                      await assetsAudioPlayer.next();
                                      //assetsAudioPlayer.playlistFinished ,
                                      setState(() {
                                        
                                      });
                                    }, 
                                    icon: Icon(Icons.skip_next),
                                    iconSize: 40,
                                  )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 0 , horizontal: 10 ),
                              child: StreamBuilder(
                              stream: assetsAudioPlayer.currentPosition,
                              builder: (context , asyncSnapshot) {
                                return ProgressBar(
                                   progress: asyncSnapshot.data==null?Duration(seconds: 0):asyncSnapshot.data as Duration,
                                   total: assetsAudioPlayer.current.value==null?Duration(seconds: 0):assetsAudioPlayer.current.value!.audio.duration,
                                   progressBarColor: Colors.black,
                                   thumbColor: Colors.black,
                                   onSeek: (duration) {
                                    assetsAudioPlayer.seek(duration);
                                  },
                                );
                              }
                              ),
                            )
                          ]
                        ),
                      ):SizedBox()
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