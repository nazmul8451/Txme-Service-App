import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'face_id_controller.dart';


class VerifyFaceId extends StatelessWidget {
  VerifyFaceId({super.key});

  final controller = Get.put(VerifyFaceController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(color: Colors.black),

          Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 4),
            ),
          ),

          const Positioned(
            bottom: 60,
            child: Text(
              "Verifying Face ID...",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}


