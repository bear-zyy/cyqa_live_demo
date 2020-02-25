import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'pushPage.dart';
import 'pullPage.dart';
//import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

//List<CameraDescription> cameras;

void main() => runApp(MyApp());

//Future<void> main() async {
//  // Fetch the available cameras before initializing the app.
//  try {
//    cameras = await availableCameras();
//  } on CameraException catch (e) {
//
//  }
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
//  runApp(MyApp());
//}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter cyqa Demo',
      debugShowCheckedModeBanner: false,
      routes: {
        "pushPageVC":(context)=>pushPageVC(),
        "pullPageVC":(context)=>pullPageVC(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter CYQA Live Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Padding(
              padding: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: jumpToPushPage,
                child: Text("推流demo" ,
                  style: TextStyle(color: Colors.black , fontSize: 20 , fontWeight: FontWeight.w500),),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 40),
              child: GestureDetector(
                onTap: jumpToPullPage,
                child: Text("拉流demo" ,
                  style: TextStyle(color: Colors.black , fontSize: 20 , fontWeight: FontWeight.w500),),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }


  jumpToPullPage(){
    //
    Navigator.pushNamed(context, "pullPageVC");
  }

  jumpToPushPage(){

    Navigator.pushNamed(context, "pushPageVC");
  }



}
