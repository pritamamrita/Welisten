// ignore_for_file: prefer_const_constructors, camel_case_types

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:we_listen/musicPlay.dart';

class layout extends StatelessWidget { 
  var Object ;
  Function playMusic , addToPlaylist ;
   layout({required this.Object ,
   required this.playMusic , required this.addToPlaylist
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
                  style: TextStyle(
                  fontSize: 15,
                  ),) ,
                  Row(
                      children: [
                      Text(Object["Movie"]) ,
                      SizedBox(width: 10,) ,
                      Text(Object["genre"],
                      style: TextStyle(
                      fontSize: 15,
                        ),),
                    ],
                  )
                ],
              ),
              leading: Icon(Icons.audiotrack , size: 20,
              ),
              trailing: IconButton(
                onPressed: (){
                  addToPlaylist(Object);
                },
                icon: Icon(Icons.post_add_rounded)
                
                ),
            ),
          ],
        ),
      ),
      );
  }
}
