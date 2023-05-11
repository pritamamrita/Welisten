// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_listen/HomeScreeb.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController NameTextController = TextEditingController();
   FirebaseAuth auth = FirebaseAuth.instance ;
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 24.0 , fontWeight: FontWeight.bold
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient : LinearGradient(
            colors: [Colors.lightBlue.shade400 ,Colors.lightBlue.shade800 , Colors.indigo.shade900 ,
             ],
             begin: Alignment.topCenter,
             end: Alignment.bottomCenter,
            ),
        ),
        child: SingleChildScrollView(
          
           padding: EdgeInsets.fromLTRB(
              20 , MediaQuery.of(context).size.height*0.19, 20.0, 100.0),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 30.0),
                TextField(
                    controller: NameTextController,
                    enableSuggestions: true,
                    autocorrect: true,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9) 
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon( Icons.person_2_outlined , color: Colors.white,),
                      labelText: "Enter name " ,
                       labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.9)
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(width:0 ,style:BorderStyle.none)
                    )
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  TextField(
                    enableSuggestions: true,
                    controller: _emailTextController,
                    autocorrect: true,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9) 
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon( Icons.person_2_outlined , color: Colors.white,),
                      labelText: "Enter mail Id" ,
                       labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.9)
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(width:0 ,style:BorderStyle.none)
                    )
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  TextField(
                    controller: passwordTextController,
                    enableSuggestions: false,
                    obscureText: true,
                    autocorrect: false,
                    cursorColor: Colors.white,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9) 
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon( Icons.person_2_outlined , color: Colors.white,),
                      labelText: "Enter password" ,
                       labelStyle: TextStyle(
                      color: Colors.white.withOpacity(0.9)
                    ),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(width:0 ,style:BorderStyle.none)
                    )
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  Container(
                  width: MediaQuery.of(context).size.width , 
                  height: 50.0,
                  margin: EdgeInsets.fromLTRB(0, 10,0,20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  child: ElevatedButton(
                    onPressed: () async{
                      if(NameTextController.text== ""){
                           Fluttertoast.showToast(
                                      msg: "username or Name cannot be empty",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.CENTER,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Colors.white.withOpacity(0.6),
                                      textColor: Colors.black,
                                      fontSize: 16.0
                                  );
                      }
                      else{
                                await auth.createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: passwordTextController.text).then((value){
                                Navigator.push(context,
                                MaterialPageRoute(builder: (context) => HomeScreen()));
                                }).onError((error, stackTrace) {
                                  print("ERROR ${error.toString()}");
                                  print("HEREE IS ERROOR TOAST");
                                  Fluttertoast.showToast(
                                        msg: "Password should be of minimum 6 characters or invalid mail format",
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 5,
                                        backgroundColor: Colors.white.withOpacity(0.6),
                                        textColor: Colors.black,
                                        fontSize: 16.0
                                    );
                                });
                                  String userId = auth.currentUser!.uid.toString();
                                  DatabaseReference username = FirebaseDatabase.instance.ref('user_auth/$userId') ;
                                  final snapshot = await username.get();
                                
                                 username.set({
                                  
                                  "email_id" : _emailTextController.text ,
                                  "name" : NameTextController.text,
                             });
                            
                          }
                          
                        
                  
                    },
                    child: Text(
                      "SIGN UP" ,
                      style: TextStyle(
                        color:Colors.white70 , fontWeight: FontWeight.bold
                        ,fontSize: 16
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith((states){
                        if(states.contains(MaterialState.pressed)){
                          return Colors.black87;
                        }
                        return Colors.white.withOpacity(0.3) ;
                      }),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)))
                    ),
                  ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}