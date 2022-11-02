import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../data/repository.dart';
import '../../utils/assets.dart';
import '../change_notifiers/future_state.dart';
import '../change_notifiers/new_post_change_notifier.dart';
import '../dialog/bottom_sheet.dart';
import '../dialog/general_dialog.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({super.key});

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _postTextController = TextEditingController();
  late NewPostChangeNotifier _changeNotifier;

  @override
  void initState() {
    super.initState();
    _changeNotifier = NewPostChangeNotifier(
      context.read<FakestagramRepository>(),
    );
  }

  @override
  void dispose() {
    _postTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext oldContext) {
    return ChangeNotifierProvider(
      create: (_) => _changeNotifier,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.primaryColor,
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            centerTitle: false,
            title: const Text('New Post'),
            actions: [
              IconButton(
                icon: const Icon(Icons.check, color: Colors.cyan),
                onPressed: () {
                  _changeNotifier.setPostText(_postTextController.text);
                  _changeNotifier.makePost(
                    onPostSuccess: () => Navigator.of(context).pop(),
                    onPostFailure: (error) => showGenericDialog(
                      context,
                      'error: ${error.toString()}',
                      title: 'Error',
                    ),
                  );
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer<NewPostChangeNotifier>(
                    builder: (_, changeNotifier, __) {
                  if (changeNotifier.pickedImageState == FutureState.wait) {
                    return const CircularProgressIndicator();
                  } else {
                    return GestureDetector(
                      onTap: () => pickPhoto(
                          context: context,
                          onImagePicked: (base64) {
                            changeNotifier.setBase64(base64);
                          }),
                      child: ColoredBox(
                        color: Colors.white,
                        child: changeNotifier.imageBase64 != null
                            ? Image.memory(
                                base64Decode(changeNotifier.imageBase64!),
                                height: 80)
                            : Image.asset(Assets.picturePlaceholder,
                                height: 80),
                      ),
                    );
                  }
                }),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    controller: _postTextController,
                    decoration: const InputDecoration(
                      hintText: 'Write a caption...',
                      hintStyle: TextStyle(color: Colors.white),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> askForCameraPermission() async {
    final permissionStatus = await Permission.camera.status;
    if (permissionStatus.isGranted) {
      return true;
    } else {
      final result = await Permission.camera.request();
      return result == PermissionStatus.granted;
    }
  }

  Future<bool> askForImageGalleryPermission() async {
    final permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      return true;
    } else {
      final result = await Permission.photos.request();
      return result == PermissionStatus.granted;
    }
  }

  Future<void> pickPhoto({
    required BuildContext context,
    required void Function(String? base64) onImagePicked,
  }) async {
    final changeNotifier = context.read<NewPostChangeNotifier>();
    await showGenericBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 3,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(100)),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      final permissionWasGranted = await askForCameraPermission();
                      if (!permissionWasGranted) return;
                    }
                    await changeNotifier.captureImageAndProcess(
                      imageSource: ImageSource.camera,
                      onSuccess: (imageBase64) {
                        Navigator.pop(context);
                        onImagePicked(imageBase64);
                      },
                      onFailure: (error) {
                        Navigator.pop(context);
                        showGenericDialog(
                          context,
                          'error: ${error.toString()}',
                          title: 'Error',
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Camera',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                MaterialButton(
                  onPressed: () async {
                    if (Platform.isIOS) {
                      final permissionWasGranted = await askForImageGalleryPermission();
                      if (!permissionWasGranted) return;
                    }
                    await changeNotifier.captureImageAndProcess(
                      imageSource: ImageSource.gallery,
                      onSuccess: (imageBase64) {
                        Navigator.pop(context);
                        onImagePicked(imageBase64);
                      },
                      onFailure: (error) {
                        Navigator.pop(context);
                        showGenericDialog(
                          context,
                          'error: ${error.toString()}',
                          title: 'Error',
                        );
                      },
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.photo_library,
                        color: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Gallery',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
