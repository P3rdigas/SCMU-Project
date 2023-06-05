import 'package:app/pages/ownersetup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../DTO/users.dart';
import '../utils/messages.dart';
import '../utils/reusable.dart';

class InitialConfigsUser extends StatefulWidget {
  final String email;
  final String kind;
  final String name;

  final double sliderHeightTemp;
  final int minTemp;
  final int maxTemp;
  final bool fullWidthTemp;
  final double sliderHeightLum;
  final int minLum;
  final int maxLum;
  final bool fullWidthLum;

  const InitialConfigsUser(
      {super.key,
      required this.email,
      required this.kind,
      required this.name,

      //Temp
      this.sliderHeightTemp = 48,
      this.minTemp = 16,
      this.maxTemp = 30,
      this.fullWidthTemp = false,
      //Lum
      this.sliderHeightLum = 48,
      this.minLum = 0,
      this.maxLum = 100,
      this.fullWidthLum = false});

  @override
  _InitialConfigsUser createState() => _InitialConfigsUser(email, kind, name);
}

class _InitialConfigsUser extends State<InitialConfigsUser> {
  late final String email;
  late final String kind;
  late final String name;

  final controller = PageController();

  bool isFirstPage = true;
  bool isLastPage = false;

  double _temperature = 24;
  double _luminosity = 75;

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  _InitialConfigsUser(this.email, this.kind, this.name);

  @override
  Widget build(BuildContext context) {
    double paddingFactor = .2;

    if (widget.fullWidthTemp) paddingFactor = .3;

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              isFirstPage = index == 0;
              isLastPage = index == 1;
            });
          },
          children: [
            //Page 1 - Slider: https://medium.com/flutter-community/flutter-sliders-demystified-4b3ea65879c
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("What is your ideal temperature in work?",
                      //Font Roboto Semi Bold
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: widget.fullWidthTemp
                        ? double.infinity
                        : (widget.sliderHeightTemp) * 5.5,
                    height: (widget.sliderHeightTemp),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((widget.sliderHeightTemp * .3)),
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0e5e98),
                            Color(0xFFFB090B),
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          widget.sliderHeightTemp * paddingFactor,
                          2,
                          widget.sliderHeightTemp * paddingFactor,
                          2),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${widget.minTemp}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.sliderHeightTemp * .3,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: widget.sliderHeightTemp * .1,
                          ),
                          Expanded(
                            child: Center(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white.withOpacity(1),
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(.5),
                                  trackHeight: 4.0,
                                  thumbShape: CustomSliderThumbCircle(
                                    thumbRadius: widget.sliderHeightTemp * .4,
                                    min: widget.minTemp,
                                    max: widget.maxTemp,
                                  ),
                                  overlayColor: Colors.white.withOpacity(.4),
                                  activeTickMarkColor: Colors.white,
                                  inactiveTickMarkColor:
                                      Colors.red.withOpacity(.7),
                                ),
                                child: Slider(
                                    value: _temperature,
                                    min: widget.minTemp.toDouble(),
                                    max: widget.maxTemp.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        _temperature = value;
                                      });
                                    }),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.sliderHeightTemp * .1,
                          ),
                          Text(
                            '${widget.maxTemp}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.sliderHeightTemp * .3,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //Page 2
            Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("What is your ideal luminosity in work?",
                      //Font Roboto Semi Bold
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: widget.fullWidthLum
                        ? double.infinity
                        : (widget.sliderHeightLum) * 5.5,
                    height: (widget.sliderHeightLum),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular((widget.sliderHeightLum * .3)),
                      ),
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFF000000),
                            Color(0xFFD3D3D3),
                          ],
                          begin: FractionalOffset(0.0, 0.0),
                          end: FractionalOffset(1.0, 1.00),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          widget.sliderHeightLum * paddingFactor,
                          2,
                          widget.sliderHeightLum * paddingFactor,
                          2),
                      child: Row(
                        children: <Widget>[
                          Text(
                            '${widget.minLum}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.sliderHeightLum * .3,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: widget.sliderHeightLum * .1,
                          ),
                          Expanded(
                            child: Center(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: Colors.white.withOpacity(1),
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(.5),
                                  trackHeight: 4.0,
                                  thumbShape: CustomSliderThumbCircle(
                                    thumbRadius: widget.sliderHeightLum * .4,
                                    min: widget.minLum,
                                    max: widget.maxLum,
                                  ),
                                  overlayColor: Colors.white.withOpacity(.4),
                                  activeTickMarkColor: Colors.white,
                                  inactiveTickMarkColor:
                                      Colors.red.withOpacity(.7),
                                ),
                                child: Slider(
                                    value: _luminosity,
                                    min: widget.minLum.toDouble(),
                                    max: widget.maxLum.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        _luminosity = value;
                                      });
                                    }),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widget.sliderHeightLum * .1,
                          ),
                          Text(
                            '${widget.maxLum}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: widget.sliderHeightLum * .3,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: 100,
              child: Visibility(
                visible: !isFirstPage,
                maintainSize: true,
                maintainAnimation: true,
                maintainState: true,
                child: TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6CAD7C)),
                  child: const Text("Previous"),
                  onPressed: () => controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: 100,
              child: SmoothPageIndicator(
                controller: controller,
                count: 2,
                effect: const SlideEffect(
                    activeDotColor: Color(0xFF6CAD7C),
                    paintStyle: PaintingStyle.stroke,
                    dotHeight: 14,
                    dotWidth: 14),
                onDotClicked: (index) => controller.animateToPage(index,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut),
              ),
            ),
            Container(
                alignment: Alignment.center,
                width: 100,
                child: !isLastPage
                    ? TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6CAD7C)),
                        child: const Text("Next"),
                        onPressed: () => controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut),
                      )
                    : TextButton(
                        style: TextButton.styleFrom(
                            foregroundColor: const Color(0xFF6CAD7C)),
                        child: const Text("Get Started"),
                        onPressed: () async {
                          final user = UserDTO(
                              email: email,
                              kind: kind,
                              luminosity: _luminosity.round(),
                              name: name,
                              temperature: _temperature.round(),
                              offices: <Map<String, bool>>[]);
                          await FirebaseFirestore.instance
                              .collection("Users")
                              .doc(email)
                              .set(user.toJson())
                              .whenComplete(() {
                            successMessage(context, "Signup completed");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        OwnerSetUp(user: user)));
                          });
                        },
                      ))
          ],
        ),
      ),
    );
  }
}
