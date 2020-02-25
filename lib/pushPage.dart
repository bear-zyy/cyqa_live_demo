import 'package:flutter/material.dart';
import 'package:flutter_rtmp_publisher/flutter_rtmp_publisher.dart';
//import 'package:camera/camera.dart';

class pushPageVC extends StatefulWidget {

//  pushPageVC(this.cameras);
//  List<CameraDescription> cameras;
  @override
  _pushPageVCState createState() => new _pushPageVCState();
}

class _pushPageVCState extends State<pushPageVC>{

//  CameraController controller;
//
//  CameraLensDirection currentDirection = CameraLensDirection.back;

  TextEditingController _pushStreamUrlTextC = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    initPermission();
//    initCamrea();

  }



  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

//  initCamrea()async{
//    Future.delayed(Duration(milliseconds: 300)).then((e){
//      for (CameraDescription cameraDescription in widget.cameras) {
//        if(cameraDescription.lensDirection == currentDirection){
//          onNewCameraSelected(cameraDescription);
//          return;
//        }
//      }
//    });
//  }

//  void onNewCameraSelected(CameraDescription cameraDescription) async {
//
//    print("是要走这里才能打开摄像头吧 ${cameraDescription}");
//
//    if (controller != null) {
//      await controller.dispose();
//    }
//    controller = CameraController(
//      cameraDescription,
//      ResolutionPreset.low,
//      enableAudio: true,
//    );
//
//    // If the controller is updated then update the UI.
//    controller.addListener(() {
//      if (mounted) setState(() {});
//      if (controller.value.hasError) {
////        showInSnackBar('Camera error ${controller.value.errorDescription}');
//        print("Camera error ${controller.value.errorDescription}");
//      }
//    });
//
//    try {
//      await controller.initialize();
//    } on CameraException catch (e) {
////      _showCameraException(e);
//      print("${e}");
//    }
//
//    if (mounted) {
//      setState(() {});
//    }
//  }


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
//            Padding(
//              padding: EdgeInsets.only(top: 0 , left: 0 ,right: 0),
//              child: Container(
//                height: 400,
//                width: double.infinity,
//                color: Colors.black,
//                child: _cameraPreviewWidget(),
//              ),
//            ),

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

  /// Display the preview from the camera (or a message if the preview is not available).
//  Widget _cameraPreviewWidget() {
//    if (controller == null || !controller.value.isInitialized) {
//      return const Center(
//        child: Text(
//          '初始化相机中',
//          style: TextStyle(
//            color: Colors.white,
//            fontSize: 24.0,
//            fontWeight: FontWeight.w900,
//          ),
//        ),
//      );
//    } else {
////      return CameraPreview(controller);
//      return AspectRatio(
//        aspectRatio:controller.value.aspectRatio,//controller.value.aspectRatio
//        child: CameraPreview(controller),
//      );
//    }
//  }

  startPushStream(){

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

    RTMPPublisher.streamVideo(_pushStreamUrlTextC.text);

  }

}