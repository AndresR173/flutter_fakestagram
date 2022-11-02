import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
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
  final _textEditingController = TextEditingController();
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
    _textEditingController.dispose();
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
                  onPressed: () {},
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Consumer<NewPostChangeNotifier>(builder: (_, changeNotifier, __) {
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
                              ? Image.memory(base64Decode(changeNotifier.imageBase64!), height: 80)
                              : Image.asset(Assets.picturePlaceholder, height: 80),
                        ),
                      );
                    }
                  }),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _textEditingController,
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
        });
  }

  Future<void> pickPhoto({required BuildContext context, required void Function(String base64) onImagePicked}) async {
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
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () async {
                    await processAndDispatchImage(
                      context: context,
                      imageSource: ImageSource.camera,
                      onImagePicked: onImagePicked,
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
                    await processAndDispatchImage(context: context, imageSource: ImageSource.gallery, onImagePicked: onImagePicked);
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

  Future<void> processAndDispatchImage({
    required BuildContext context,
    required ImageSource imageSource,
    required void Function(String base64) onImagePicked,
  }) async {
    try {
      final changeNotifier = context.read<NewPostChangeNotifier>();
      changeNotifier.setPickedImageState(FutureState.wait);
      final imagePicker = ImagePicker();
      final pickedFilePath = await imagePicker
          .pickImage(
            source: imageSource,
          )
          .then((xfile) => xfile?.path);
      if (pickedFilePath == null) return;
      final base64 = await compressAndEncodeImageAsBase64(pickedFilePath);
      Navigator.pop(context);
      if (base64 == null) return;
      changeNotifier.setPickedImageState(FutureState.success);
      onImagePicked(base64);
    } catch (ex) {
      await showGenericDialog(context, ex.toString(), title: 'error');
    }
  }

  Future<String?> compressAndEncodeImageAsBase64(String filePath) async {
    var result = await FlutterImageCompress.compressWithFile(
      filePath,
      minWidth: 1300,
      minHeight: 1300,
      quality: 70,
    );

    return result != null ? base64Encode(result) : null;
  }
}
