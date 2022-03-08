import 'package:flutter/material.dart';

class AlertLoading {
  BuildContext context;
  String message;
  AlertLoading({required this.context, required this.message});
  void updateMessage(String message) {
    this.message = message;
  }

  void show() {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(
                height: 10,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
