import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pro/controller/usercontroller.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserController>(
      builder: (controller) => SizedBox(
        width: 110,
        height: 110,
        child: controller.profilePic.value == null
            ? CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                backgroundImage: const AssetImage("assets/avatar.png"),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () async {
                          final ImagePicker picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (pickedFile != null) {
                            controller.uploadProfilePic(pickedFile);
                          }
                        },
                        child: Container(
                          height: 35,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400,
                            border: Border.all(color: Colors.white, width: 3),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.camera_alt_sharp,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : CircleAvatar(
                backgroundImage: FileImage(
                  File(controller.profilePic.value!.path),
                ),
              ),
      ),
    );
  }
}
