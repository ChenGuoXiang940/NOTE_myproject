import 'package:flutter/material.dart';

class MessageService {
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
  
  static void showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,  
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(  
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
  
  static void showErrorMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,  
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(  
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// 保持舊的 MessagePage 類別以向後相容
class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  static void showMessage(BuildContext context, String message) {
    MessageService.showMessage(context, message);
  }
}
