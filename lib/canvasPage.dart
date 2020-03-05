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

            setState(() {
//              _list = new List.from(_list)..add({"color":color , "point":localPosition},);

              _data.last = new List.from(_data.last)..add({"color":color , "point":localPosition});
//              _data.last..add({"color":color , "point":localPosition},);

            });

          },
          onPanEnd: (DragEndDetails details) => {
//    _list.add({"color":color , "point":null})
           setState((){
                _data.last.add({"color":color , "point":null});
             }),
          },
          onPanStart: (DragStartDetails details) => {
            setState((){
                 _data = new List.from(_data)..add([]);
            }),
          },
        ),

        CustomPaint(painter: new SignaturePainter(_data),),

//        CustomPaint(painter: new SignaturePainter(_list),),

        Positioned(
          child: IconButton(icon: Icon(Icons.color_lens , color: Colors.black,), onPressed: (){setState(() {
            color = Colors.black;
          });}),
          bottom: 10,
          right: 0,
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.color_lens , color: Colors.red,), onPressed: (){setState(() {
            color = Colors.red;
          });}),
          bottom: 10,
          right: 40,
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.color_lens , color: Colors.green,), onPressed: (){setState(() {
            color = Colors.green;
          });}),
          bottom: 10,
          right: 80,
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.replay , color: Colors.grey,), onPressed: (){setState(() {
//            _list = [];
           _data.removeLast();
          });}),
          bottom: 10,
          right: 120,
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.clear , color: Colors.grey,), onPressed: (){setState(() {
//            _list = [];
              _data = [];
          });}),
          bottom: 10,
          right: 160,
        ),
      ],
    );
  }
}

class canvasPage extends StatelessWidget {
  Widget build(BuildContext context) => new Scaffold(body: new Signature());
}
