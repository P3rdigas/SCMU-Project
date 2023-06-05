import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../DTO/office.dart';

Image logoWidget(String imageName, color) {
  return Image.asset(imageName,
      fit: BoxFit.fitWidth, width: 240, height: 240, color: color);
}

TextFormField reusableTextField(
    String text,
    IconData icon,
    bool isPasswordType,
    TextEditingController controller,
    String? Function(String?)? validatorExec) {
  return TextFormField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.grey,
    style: TextStyle(color: Colors.grey.withOpacity(0.5)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.grey.withOpacity(0.5),
      ),
      suffixIcon: IconButton(
        onPressed: () {
          controller.clear();
        },
        color: Colors.grey.withOpacity(0.5),
        icon: const Icon(Icons.clear),
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.grey[150],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
              width: 1, color: Colors.red, style: BorderStyle.solid)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
    validator: validatorExec,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap, double width, double height, Color color) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: height,
    margin: EdgeInsets.fromLTRB(width, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white;
            }
            return color;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );
}

void calculateAverageTemperature(String id, OfficeDTO office, bool tempB, bool lightB) async {
  List yau = office.employeesInRoom;
  Iterator it = yau.iterator;
  int nUsers = 0;
  int tempTotal = 0;
  int lightTotal = 0;
  while(it.moveNext()) {
    nUsers= nUsers +1;
    String mail = it.current;
    final docRef = await FirebaseFirestore.instance
        .collection("Users")
        .doc(mail).get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        int temp = data["Temperature"];
        int light = data["Luminosity"];
        tempTotal = tempTotal +temp;
        lightTotal = lightTotal + light;
      },
      onError: (e) => print("Error getting document: $e"),
    );
  }

  int finalT = (tempTotal/nUsers).round();
  int finalL = (lightTotal/nUsers).round();

  if(tempB) {
    await FirebaseFirestore.instance
        .collection("Offices")
        .doc(id)
        .update({"target_Temperature": finalT});
  }

  if(lightB) {
    await FirebaseFirestore.instance
        .collection("Offices")
        .doc(id)
        .update({"target_Luminosity": finalL});
  }


}

class CustomSliderThumbCircle extends SliderComponentShape {
  final double thumbRadius;
  final int min;
  final int max;

  const CustomSliderThumbCircle({
    required this.thumbRadius,
    required this.min,
    required this.max,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final paint = Paint()
      ..color = Colors.white //Thumb Background Color
      ..style = PaintingStyle.fill;

    TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: thumbRadius * .8,
        fontWeight: FontWeight.w700,
        color: const Color(0xFF6CAD7C), //Text Color of Value on Thumb
      ),
      text: getValue(value),
    );

    TextPainter tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr);
    tp.layout();
    Offset textCenter =
        Offset(center.dx - (tp.width / 2), center.dy - (tp.height / 2));

    canvas.drawCircle(center, thumbRadius * .9, paint);
    tp.paint(canvas, textCenter);
  }

  String getValue(double value) {
    return (min + (max - min) * value).round().toString();
  }
}
