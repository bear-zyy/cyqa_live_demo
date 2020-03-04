import 'package:flutter/material.dart';

class SignaturePainter extends CustomPainter {

  SignaturePainter(this.list);
  final List<Map<String , dynamic>> list;

  void paint(Canvas canvas, Size size) {

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

  Widget build(BuildContext context) {
    return new Stack(
      children: [
        GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            RenderBox referenceBox = context.findRenderObject();
            Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);

            setState(() {
              _list = new List.from(_list)..add({"color":color , "point":localPosition},);
            });
          },
          onPanEnd: (DragEndDetails details) => _list.add({"color":color , "point":null}),
        ),

        CustomPaint(painter: new SignaturePainter(_list),),

        Positioned(
          child: IconButton(icon: Icon(Icons.ac_unit , color: Colors.black,), onPressed: (){setState(() {
            color = Colors.black;
          });}),
          bottom: 0,
          right: 0,
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.change_history , color: Colors.red,), onPressed: (){setState(() {
            color = Colors.red;
          });}),
          bottom: 0,
          right: 40,
        ),
        Positioned(
          child: IconButton(icon: Icon(Icons.build , color: Colors.green,), onPressed: (){setState(() {
            color = Colors.green;
          });}),
          bottom: 0,
          right: 80,
        ),
      ],
    );
  }
}

class canvasPage extends StatelessWidget {
  Widget build(BuildContext context) => new Scaffold(body: new Signature());
}
