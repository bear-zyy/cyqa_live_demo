import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'tools/NetworkManager.dart';

class uploadImagePage extends StatefulWidget {

  @override
  _uploadImagePageState createState() => new _uploadImagePageState();
}

class _uploadImagePageState extends State<uploadImagePage>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  File _image;

  Future getImage() async {

    var image = await ImagePicker.pickImage(source: ImageSource.gallery , imageQuality:10);

    List<int> imageBytes = await image.readAsBytes();

    String fileByte = base64Encode(imageBytes);

    setState(() {
      _image = image;
    });

    netWorkRequest(fileByte);

  }

  netWorkRequest(String fileByte) async{

    var response = await NetworkManager().postRequest("uplodaResourceMore",
        '''"fileList":[{"fileByte":"${fileByte}" , "fileAllName":"photo.jpg"}]''');

    if(response["err_code"] == "200"){

      print("请求成功  ${response["data"]}");
    }
    else{
      print("请求失败");
    }

  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(child: Center(
              child: _image == null ? Text("") : Image.file(_image)
          ),),
          IconButton(
            icon: Icon(Icons.backspace , color: Colors.grey,),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
        tooltip: 'pick image',
      ),

    );
  }


}