// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:text_scroll/text_scroll.dart';
import 'package:we_listen/musicPlay.dart';

class layout extends StatelessWidget { 
  var Object  , isMyPlaylist;
  Function playMusic , addToPlaylist , deleteFromPlaylist ;
   layout({required this.Object ,
   required this.playMusic , required this.addToPlaylist , required this.isMyPlaylist,
   required this.deleteFromPlaylist
   });
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical:4.0 , horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10),
           //color: Colors.teal.shade400.withOpacity(0.3),
           color: Colors.white
        ),
        height: MediaQuery.of(context).size.height*0.13,
        
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListTile(
              onTap: ()async{
              playMusic(Object) ;
              },
              title: Text(
               Object["Name"],
               style: TextStyle(
               fontSize: 23,
               ),),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  Object["Singer"],
                  //velocity: Velocity(pixelsPerSecond: Offset(24, 0)),
                  style: TextStyle(
                  fontSize: 15,
                  ),) ,
                  Row(
                      children: [
                      Text(Object["Movie"]) ,
                      SizedBox(width: 10,) ,
                      Flexible(
                        child: TextScroll(Object["genre"],
                        velocity: Velocity(pixelsPerSecond: Offset(24, 0)),
                        style: TextStyle(
                        fontSize: 15,
                          ),),
                      ),
                    ],
                  )
                ],
              ),
              leading: Icon(Icons.audiotrack , size: 20,
              ),
              trailing: isMyPlaylist==false? IconButton(
                onPressed: (){
                  addToPlaylist(Object);
                },
                icon: Icon(Icons.post_add_rounded)
                
                ):IconButton(
                onPressed: (){
                  deleteFromPlaylist(Object["songid"]);
                },
                icon: Icon(Icons.delete)
                
                ),
            ),
          ],
        ),
      ),
      );
  }
}
