import 'package:flutter/material.dart';

void showAlert(BuildContext context, var message){
  showDialog(context: context, builder: (context){
    return AlertDialog(
      title: Center(child: Text('Given message is  \n \n  $message \n \n ',style: const TextStyle(fontSize: 21,fontFamily: 'serif',color: Colors.black),)),
      icon: const Icon(Icons.info,size: 51,),
      iconColor: Colors.lightBlue,
    );
  },);
}