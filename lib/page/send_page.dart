import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reach_me/models/u/user.dart';
import 'package:reach_me/widgets/loadng.dart';
import 'package:image/image.dart' as Img;
import 'package:uuid/uuid.dart';

class SendPage extends StatefulWidget {
  final User currentUser;
  const SendPage({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SendPageState createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
  File? imageFile;
  //File file = File(imageFile!.path);
  bool isUploading = false;
  final ImagePicker picker = ImagePicker();
  String postId = Uuid().v4();

  pickFromCamera() async {
    Navigator.pop(context);
    final XFile? fromCamera = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 678,
      maxWidth: 960,
    );
    setState(() {
      imageFile = File(fromCamera!.path);
    });
  }

  pickFromGallery() async {
    Navigator.pop(context);
    final XFile? fromGallery =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(fromGallery!.path);
    });
  }

  pickImage() {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'Select an Image From:',
        ),
        children: [
          SimpleDialogOption(
            onPressed: pickFromCamera,
            child: Text('Camera'),
          ),
          SimpleDialogOption(
            onPressed: pickFromGallery,
            child: Text('Gallery'),
          )
        ],
      ),
    );
  }

  handleSending() async {
    setState(() {
      isUploading = true;
    });
    await compressImage();
    await uploadImage(imageFile);
  }

  uploadImage(image) {}

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    Img.Image? uncompressedImage =
        Img.decodeImage(imageFile!.readAsBytesSync());
    final compressedImage = File('$tempPath/img_$postId.jpg')
      ..writeAsBytesSync(Img.encodeJpg(uncompressedImage!, quality: 85));

    setState(() {
      imageFile = compressedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? buildSplashScreen(context) : buildSendContent();
  }

  buildSendContent() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            setState(() {
              imageFile = null;
            });
          },
        ),
        title: Text('Post Content'),
        actions: [
          TextButton(
            onPressed: isUploading ? null : () => handleSending(),
            child: Text(
              'Post',
              style: TextStyle(color: Colors.blue.shade100),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          isUploading ? linearLoading() : Container(),
          Container(
            height: 220,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    image: DecorationImage(
                      image: FileImage(imageFile!),
                      // image: FileImage(File(imageFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  CachedNetworkImageProvider(widget.currentUser.photoUrl),
            ),
            title: TextField(
              decoration: InputDecoration(
                  hintText: 'Write down a caption ', border: InputBorder.none),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            leading: Icon(
              Icons.pin_drop,
              color: Colors.green.shade400,
            ),
            title: TextField(
              decoration: InputDecoration(
                  hintText: 'Where was this photo taken?',
                  border: InputBorder.none),
            ),
          ),
          Container(
            width: 200,
            height: 100,
            alignment: Alignment.center,
            //decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.my_location),
                label: Text('Use current location')),
          )
        ],
      ),
    );
  }

  Container buildSplashScreen(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/upload.svg',
            height: 240,
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            height: 50,
            width: 190,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              shape: BoxShape.rectangle,
              color: Colors.brown.shade500,
            ),
            child: TextButton(
                child: Text(
                  'Upload',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: pickImage),
          ),
        ],
      ),
    );
  }
}
