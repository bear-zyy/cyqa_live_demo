import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'dart:async';
import 'dart:ui';


class classPageVC extends StatefulWidget{

  @override
  _classPageVCState createState()=> new _classPageVCState();
}

class _classPageVCState extends State<classPageVC>{

  IjkMediaController controller = IjkMediaController();

  var dataList = ["课堂签到" , "课堂问题", "课堂笔记" , "上传信息" , "课堂资料" , "收视课程" , "退出课程"];

  TextEditingController urlTextControler = new TextEditingController();

  double volumeValue = 0.5;

  IjkStatus playState = IjkStatus.noDatasource;

  bool isLive = false;

  int liveTimerDuration = 0;

  var liveTimeString = "00:00";

  Timer _timer;

  MediaQueryData mediaQuery;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SystemChrome.setPreferredOrientations([

      DeviceOrientation.landscapeLeft,

      DeviceOrientation.landscapeRight

    ]);

    setState(() {

    });


    Stream<IjkStatus> ijkStatusStream = controller.ijkStatusStream;
    ijkStatusStream.listen((e){

      if(!mounted){
        return;
      }
      setState(() {
        playState = e;
      });

      if(e == IjkStatus.preparing){//准备中

      }
      else if(e == IjkStatus.prepared){//准备完成

      }
      else if(e == IjkStatus.playing){//播放

        videoInfoGet();
      }
      else if(e == IjkStatus.error){

      }

    });

  }

  @override
  void dispose() {
    // TODO: implement dispose

    controller.dispose();

    if(_timer != null){
      _timer.cancel();
    }

    urlTextControler.dispose();

    SystemChrome.setPreferredOrientations([

      DeviceOrientation.portraitUp,

    ]);

    super.dispose();

  }


  videoInfoGet()async{
    VideoInfo info = await controller.getVideoInfo();

    if(info.duration == 0.0){//直播
      if(!mounted){
        return;
      }
      setState(() {
        isLive = true;
      });

      liveTimerDuration = 0;

      if(_timer != null){
        _timer.cancel();
      }

      _timer = Timer.periodic(Duration(milliseconds: 1000), (_){

        liveTimerDuration ++;

        int h = (liveTimerDuration / 3600).toInt();

        int m = ((liveTimerDuration - 3600 * h) / 60).toInt();

        int s = (liveTimerDuration % 60).toInt();

        String string = "";

        if(h != 0){
          string = "${h}:";
        }
        if(m< 10){
          string = string + "0${m}:";
        }
        else{
          string = string + "${m}:";
        }
        if(s< 10){
          string = string + "0${s}";
        }
        else{
          string = string + "${s}";
        }

        if(!mounted){
          return;
        }
        setState(() {
          liveTimeString = string;
        });

      });

    }
    else{//点播
      setState(() {
        isLive = false;
      });
    }
  }



  @override
  Widget build(BuildContext context) {

    mediaQuery = MediaQueryData.fromWindow(window);

    return Scaffold(
      body: Container(
        width: mediaQuery.size.width,
        height: mediaQuery.size.height,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.green,
              width: mediaQuery.size.width,
              height: 20,
            ),
            Container(
              color: Colors.green,
              width: mediaQuery.size.width,
              height: 44,
              child: navWidget(),
            ),
            bodyWidget(),
          ],
        ),
      ),
      resizeToAvoidBottomPadding: false,
    );
    // This trailing comma makes auto-formatting nicer for build methods.
  }


  Widget navWidget(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 500,
            height: 44,
            child: Padding(padding: EdgeInsets.only(left: 20 , ),
              child: TextField(
                controller: urlTextControler,
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: 20, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "输入资源地址",
                  hintStyle: TextStyle(fontSize: 20 , color: Colors.white),
                  contentPadding: EdgeInsets.symmetric(vertical: 8),
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),),
          ),
          GestureDetector(
            onTap: ()=>{},
            child: Container(
              height: 30,
              width: 90,
              child: Row(
                children: <Widget>[
//                    Image.asset(""),
                  Text("申请发言", style: TextStyle(color: Colors.white , fontSize: 16 , decoration: TextDecoration.none),),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget bodyWidget(){
    return Container(
      height: mediaQuery.size.height - 64,
      width: mediaQuery.size.width,
      color: Colors.black,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 547,
            child: Container(
              color: Colors.white,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 296,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          child: ijkplayerView(),
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 37,
                    child: bottomView(),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 110,
            child: RightListView(),
          ),
        ],
      ),
    );
  }

  Widget ijkplayerView(){
    return IjkPlayer(
      mediaController: controller,
    );
  }

  Widget RightListView(){
    return Container(
      color: Color(0xff232328),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 0),
        itemCount: dataList.length,
        itemBuilder: (BuildContext context , int index){
          return GestureDetector(
            onTap: ()=>rightListViewClick(index),
            child: Container(
              height: (mediaQuery.size.height - 30 - 64)/ 7,
              child: Center(
                child: Text(dataList[index] , style: TextStyle(color: Color(0xff9D9D9D), fontSize: 16 ,decoration: TextDecoration.none)),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget bottomView(){
    return Container(
      color: Colors.black,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            height: 1,
            width: mediaQuery.size.width,
          ),
          Expanded(
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  bottomViewLeft(),

                  bottomViewRight(),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget bottomViewLeft(){
    return isLive ?
    Padding(
      padding: EdgeInsets.only(left: 10),
      child: Text(liveTimeString , style: TextStyle(color: Colors.white , fontSize: 16 , fontWeight: FontWeight.w500 , decoration: TextDecoration.none),),
    ) :
    Padding(
      padding: EdgeInsets.only(left: 10),
      child: Container(
        height: double.infinity,
        width: 150,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(padding: EdgeInsets.all(1),color: Colors.white
                ,iconSize: 20, icon: Icon(Icons.arrow_back), onPressed: ()=>itemSwitch(0)),

            IconButton(
                padding: EdgeInsets.all(0), iconSize: 20,color: Colors.white, icon: Icon(playState==IjkStatus.playing ? Icons.pause: Icons.play_arrow ,), onPressed: ()=>itemSwitch(1)),

            IconButton(
                padding: EdgeInsets.all(1) , iconSize: 20, color: Colors.white , icon: Icon(Icons.forward), onPressed: ()=>itemSwitch(2)),
          ],
        ),
      ),
    );
  }

  Widget bottomViewRight(){
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Row(
        children: <Widget>[
          Icon(Icons.volume_up  , color: Colors.white,size: 16,),
          Container(
            height: double.infinity,
            width: 100,
            child: SliderTheme(
              child: Slider(
                value: volumeValue, onChanged: volumeChange,
                max: 1.0,
                min: 0.0,
              ),
              data: SliderThemeData(
                activeTrackColor: Color(0xff4FC47B),
                inactiveTrackColor: Color(0xffB7B7B7),
                trackHeight: 3,
                thumbColor: Colors.white,
                overlayShape: RoundSliderOverlayShape(overlayRadius: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  itemSwitch(int index){

    print(playState);

    switch(index){
      case 0:
        break;
      case 1:
        if(playState == IjkStatus.playing){
          controller.pause();
        }
        else if(playState == IjkStatus.pause){
          controller.play();
        }
        break;
      case 2:
        break;
    }
  }

  volumeChange(double value){

    setState(() {
      volumeValue = value;
    });

//    print(value);
//
//    print((value*100).toInt());

    controller.volume = (value*100).toInt();

  }

  rightListViewClick(int index) {
    if(index == 5){
      videoPlayer();
    }
//    print("点击了  ${index}");
  }

  videoPlayer() async {

    controller.setNetworkDataSource(
        urlTextControler.text,
        autoPlay: true);

    //{duration=51.2, tcpSpeed=96707, isPlaying=true, outputFps=32.0, currentPosition=11.637, width=568, degree=0, height=320} 26

  }

}