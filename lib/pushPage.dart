import 'package:flutter/material.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class pushPageVC extends StatefulWidget {

  @override
  _pushPageVCState createState() => new _pushPageVCState();
}

class _pushPageVCState extends State<pushPageVC>{

  TextEditingController _pushStreamUrlTextC = new TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("推流",style: TextStyle(color: Colors.white,fontSize: 20),),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 38 ),
              child:TextField(
                controller: _pushStreamUrlTextC,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 20 , color: Colors.red ,decoration: TextDecoration.none),
                decoration: InputDecoration(
                  hintText: "输入推流地址",
                  hintStyle: TextStyle(fontSize: 20 , color: Colors.black26),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: startPushStream,
                child: Text("跳转到推流页面",
                  style: TextStyle(color: Colors.red , fontSize: 22 , fontWeight: FontWeight.w500),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  startPushStream() async{

    if(_pushStreamUrlTextC.text.length == 0){

      showDialog(context:context , builder: (_)=> AlertDialog(
        title: Text("提示"),
        content: Text("请填写推流地址"),
        actions: <Widget>[
          FlatButton(onPressed: (){
            Navigator.of(context).pop();

          },
            child: Text("确定"),),
        ],
      ),
      );

      return;
    }

      Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.camera , PermissionGroup.microphone]);

      print("permissions ==== ${permissions}");

      PermissionStatus cameraPermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

      PermissionStatus microphonePermission = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);

      print("cameraPermission ===  ${cameraPermission.value}");

      if(cameraPermission.value != 2){
        await PermissionHandler().openAppSettings();
      }

      if(microphonePermission.value != 2){
        await PermissionHandler().openAppSettings();
      }

      PermissionStatus camera = await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);
      if(camera.value != 2){//执行

        showDialog(context:context , builder: (_)=> AlertDialog(
          title: Text("提示"),
          content: Text("需要获取摄像头权限"),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();

            },
              child: Text("确定"),),
          ],
        ),
        );

        return;
      }

      PermissionStatus microphone = await PermissionHandler().checkPermissionStatus(PermissionGroup.microphone);

      if(microphone.value != 2){//执行

        showDialog(context:context , builder: (_)=> AlertDialog(
          title: Text("提示"),
          content: Text("需要获取麦克风权限"),
          actions: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(context).pop();

            },
              child: Text("确定"),),
          ],
        ),
        );

        return;
      }


    RTMPPublisher.streamVideo(_pushStreamUrlTextC.text);

  }

}