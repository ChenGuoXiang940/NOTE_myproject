import 'package:flutter/material.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  static void showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.black87,  
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(  
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}