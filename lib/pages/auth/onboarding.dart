import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:onboarding/onboarding.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  late Material materialButton;
  late int index;
  var pageOneText = const Flexible(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Welcome to DCourier",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            "Your convinient delivery solution at your fingertips.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Order, Track & recieve your items with ease",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
  var pageTwoText = const Flexible(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Package Delivery",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          Text(
            "Start exploring our vast network of couriers today.",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Experience the speed, reliability and simplicity of DCourier",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
  final onboardingPagesList = [
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Center(
                  child: Image.asset(
                    "images/dan sahu.png",
                    width: 280,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    PageModel(
      widget: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Center(
                  child: Image.asset(
                    "images/delivery.png",
                    width: 280,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  ];

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 2;
            setIndex(2);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  _changeIndex({void Function(int)? setIndex, index}) {
    setIndex!(index);
    setState(() => index = index);
  }

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "images/logo.png",
                    color: primaryColor,
                    height: 20,
                  ),
                ),
              ],
            ),
            Flexible(
              child: Onboarding(
                pages: onboardingPagesList,
                onPageChange: (int pageIndex) {
                  index = pageIndex;
                },
                startPageIndex: 0,
                footerBuilder: (context, dragDistance, pagesLength, setIndex) {
                  return Container(
                    height: 350,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: tartiaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          index == 0 ? pageOneText : const SizedBox(),
                          index == 1 ? pageTwoText : const SizedBox(),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: index == 0
                                ? MaterialButton(
                                    color: accentColor,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    height: 50,
                                    onPressed: () {
                                      setIndex(1);
                                      setState(() => index = 1);
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Continue",
                                          style:
                                              TextStyle(color: secondaryColor),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Icon(
                                          Icons.arrow_forward,
                                          color: secondaryColor,
                                          size: 25,
                                        )
                                      ],
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      MaterialButton(
                                        height: 50,
                                        minWidth: 50,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        onPressed: () {
                                          setIndex(0);
                                          setState(() => index = 0);
                                        },
                                        color: accentColor,
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                          color: secondaryColor,
                                        ),
                                      ),
                                      MaterialButton(
                                        height: 50,
                                        minWidth: 100,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        color: accentColor,
                                        child: Text(
                                          "Let's Go",
                                          style:
                                              TextStyle(color: secondaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomIndicator(
                              netDragPercent: dragDistance,
                              pagesLength: pagesLength,
                              indicator: Indicator(
                                indicatorDesign: IndicatorDesign.line(
                                  lineDesign: LineDesign(
                                    lineType: DesignType.line_uniform,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
