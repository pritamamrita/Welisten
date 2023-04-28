// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:we_listen/HomeScreeb.dart';
import 'package:we_listen/signUpscreen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController passwordTextController = TextEditingController();
   FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    //   FirebaseAuth.instance
    //     .authStateChanges()
    //     .listen((User? user) {
    //       if (user != null) {
    //         Navigator.push(context, MaterialPageRoute(builder:
    //                         (context) => HomeScreen()));
    //         print('User is currently signed in!');

    //       } 
    // });
   
    if(auth.currentUser!=null){
      return HomeScreen();
    }
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
         decoration: BoxDecoration(
          gradient : LinearGradient(
            colors: [ Colors.lightBlue.shade400 ,Colors.lightBlue.shade800 , Colors.indigo.shade900 , 
             ],
             begin: Alignment.topLeft,
             end: Alignment.bottomRight,
            ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
              20 , MediaQuery.of(context).size.height*0.2, 20.0, 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailTextController,
                  enableSuggestions: true,
                  autocorrect: true,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9) 
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon( Icons.person_2_outlined , color: Colors.white,),
                    labelText: "Enter username or mail Id" ,
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
                forgetPassword(context),
          Container(
          width: MediaQuery.of(context).size.width , 
          height: 50.0,
          margin: EdgeInsets.fromLTRB(0, 10,0,20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
          ),
          child: ElevatedButton(
            onPressed: (){
               FirebaseAuth.instance.signInWithEmailAndPassword(
                       email: _emailTextController.text,
                       password: passwordTextController.text).then((value) {
                        Navigator.push(context, MaterialPageRoute(builder:
                         (context) => HomeScreen()));
                       }).onError((error, stackTrace) {
                           print("ERROR ${error.toString()}");
                           print("HEREE IS ERROOR TOAST");
                           Fluttertoast.showToast(
                                msg: "invalid mail-ID or password",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.TOP,
                                timeInSecForIosWeb: 5,
                                backgroundColor: Colors.white.withOpacity(0.6),
                                textColor: Colors.black,
                                fontSize: 16.0
                            );
                         });
            },
            child: Text(
              "LOG IN" ,
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
                SizedBox(height: 20),
                signUpOption(),
            
                    
              ],
            ),
          
        ),
      ),
    );
  }
   Widget forgetPassword(BuildContext context){
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: Text(
          "Forgot Password",
          style: TextStyle(
            color: Colors.white70 ,
          ),
          textAlign: TextAlign.right,
        ),
        onPressed: (){
        }
      ),
    );
  }
  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Dont have account?" , 
        style: TextStyle(color: Colors.white70),),
        GestureDetector(
          onTap :(){
            print("here");
            Navigator.push(context ,
            MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          behavior: HitTestBehavior.translucent,
          child: AbsorbPointer(
            child: Text(" Sign Up" , style: TextStyle(color: Colors.white , 
                     fontWeight: FontWeight.bold),
            ),
          ),
         ),
      ],
    );
  }
}