import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {

  SignaturePainter(this.data);
//  final List<Map<String , dynamic>> list;

  List<List<Map<String , dynamic>>> data;

  void paint(Canvas canvas, Size size) {

    for( int j = 0; j < data.length ; j ++){

      List<Map<String , dynamic>> list = data[j];

      for (int i = 0; i < list.length - 1; i++) {

        Map<String , dynamic> map= list[i];
        Paint paint = new Paint()
          ..color = map["color"]
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 5.0;
        if (map["point"] != null && list[i+1]["point"] != null)
          canvas.drawLine(map["point"], list[i+1]["point"], paint);
      }

    }
  }
  bool shouldRepaint(SignaturePainter other){
    return true;
  }

}

class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> {

  Color color = Colors.blue;

  List<Map<String , dynamic>> _list = <Map<String , dynamic>>[];


  List<List<Map<String , dynamic>>> _data = <List<Map<String , dynamic>>>[];


  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);
            print("${localPosition}");
            if (localPosition.dx < 0 || localPosition.dy < 0 || localPosition.dx >300 || localPosition.dy > 300){
              setState(() {
                _data.last = new List.from(_data.last)..add({"color":color , "point":null});
              },);
            }
            else {
              setState(() {
                _data.last = new List.from(_data.last)..add({"color":color , "point":localPosition});
              },);
            }
            },
          onPanEnd: (DragEndDetails details) => endFunction(),
          onPanStart: (DragStartDetails details) => startFunction(),
        ),

        CustomPaint(
          painter: new SignaturePainter(_data),),

      ],
    );
  }

  RenderObjectWidget test(){

  }


  void startFunction(){
    setState((){
      _data = new List.from(_data)..add([]);
    });
  }

  void endFunction(){
    setState((){
      _data.last.add({"color":color , "point":null});
    },);
  }

}

class canvasTest extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(

        body: Center(
          child: Container(
            width: 300,
            height: 400,
            color: Color(0x20000000),
            child: new Signature(),
          ),
        ),
      floatingActionButton: FloatingActionButton(onPressed: (){Navigator.pop(context);} , child: Icon(Icons.backspace),),
    );
  }
}
