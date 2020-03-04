import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class pullPageVC extends StatefulWidget {

  @override
  _pullPageVCState createState() => new _pullPageVCState();
}

class _pullPageVCState extends State<pullPageVC>{

  IjkMediaController controller = IjkMediaController();

  TextEditingController _setUrlTextC = new TextEditingController();

  IjkStatus playState = IjkStatus.noDatasource;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _setUrlTextC.addListener((){
      setState(() {
        playState = IjkStatus.noDatasource;
      });
    });

    Stream<IjkStatus> ijkStatusStream = controller.ijkStatusStream;
    ijkStatusStream.listen((e){
      print("ijkStatusStream  ========================  {$e}");

      setState(() {
        playState = e;
      });

      if(e == IjkStatus.preparing){//准备中

      }
      else if(e == IjkStatus.prepared){//准备完成

      }
      else if(e == IjkStatus.playing){//播放
        setState(() {

        });
      }
      else if(e == IjkStatus.pause){//暂停
        setState(() {

        });
      }
      else if(e == IjkStatus.error){//播放错误

      }
    });


  }

  @override
  void dispose() {
    // TODO: implement dispose

    controller.dispose();

    _setUrlTextC.dispose();

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
                controller: _setUrlTextC,
                textInputAction: TextInputAction.done,
                style: TextStyle(fontSize: 20 , color: Colors.red ,decoration: TextDecoration.none),
                decoration: InputDecoration(
                  hintText: "直播地址",
                  hintStyle: TextStyle(fontSize: 20 , color: Colors.black26),
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 20 , bottom: 50),
              child: Container(
                height: 200,
                width: double.infinity,
                child: ijkplayerWidget(),
              ),
            ),
            Container(
              child: Text( playState == IjkStatus.setDatasourceFail || playState == IjkStatus.error ? "直播地址错误": "",
                style: TextStyle(color: Colors.red , fontSize:20 , decoration: TextDecoration.none),),
            ),
            GestureDetector(
              onTap: play,
              child: Icon(
                  playState == IjkStatus.pause || playState == IjkStatus.noDatasource || playState == IjkStatus.setDatasourceFail || playState == IjkStatus.error ?
                  Icons.play_circle_filled : Icons.pause_circle_filled),
            ),



          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Widget ijkplayerWidget(){
    return Container(
      child: IjkPlayer(
        mediaController: controller,
        statusWidgetBuilder: ( BuildContext context, IjkMediaController controller, IjkStatus status){
          return Container();
        },
//        controllerWidgetBuilder: (m){
//          return Container();
//        },
      ),
    );
  }

  play() async{
    //rtmp://47.92.249.183:1935/live/61f79544afdf471fa6c419a218325c35
    //http://47.92.249.183:89/61f79544afdf471fa6c419a218325c35/index.m3u8

    if(playState == IjkStatus.pause){

      controller.play();

    }
    else if(playState == IjkStatus.playing) {
      controller.pause();
    }
    else{
      await controller.setNetworkDataSource(_setUrlTextC.text , autoPlay: true);
    }

  }



}