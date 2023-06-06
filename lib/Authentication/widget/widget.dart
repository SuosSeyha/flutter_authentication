import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showMessageError({required String title,required String message}){
  Get.snackbar(
    '', '',
    duration: const Duration(seconds: 4), // Timer
    titleText: Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.white,
        fontWeight: FontWeight.bold
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.red,
      ),
      ),
      backgroundColor: Colors.red.withOpacity(0.2)
    );
}

void showMessageSuccess({required String title,required String message}){
  Get.snackbar(
    '', '',
    duration: const Duration(seconds: 4),
    titleText: Text(
      title,
      style: const TextStyle(
        fontSize: 25,
        color: Colors.yellowAccent,
        fontWeight: FontWeight.bold
      ),
      
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        fontSize: 18,
        color: Colors.green,
      ),
      ),
      backgroundColor: Colors.green.withOpacity(0.1)
    );
}