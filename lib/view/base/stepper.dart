import 'package:flutter/material.dart';

class NumberStepper extends StatelessWidget {
  final double? width;
  final totalSteps;
  final int? curStep;
  final Color? stepCompleteColor;
  final Color? currentStepColor;
  final Color? inactiveColor;
  final double? lineWidth;

  const NumberStepper({
    Key? key,
     this.width,
     this.curStep = 1,
     this.stepCompleteColor,
     this.totalSteps,
     this.inactiveColor,
     this.currentStepColor,
     this.lineWidth,
  })  : assert( ((curStep ?? 1) > 0 == true) && (curStep ?? 1) <= totalSteps + 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 24.0,
        right: 24.0,
      ),
      width: width,
      child: Row(
        children: _steps(),
      ),
    );
  }

  getCircleColor(i) {
    Color color;
    if (i + 1 < curStep) {
      color = stepCompleteColor!;
    } else if (i + 1 == curStep)
      color = currentStepColor ?? Color(1);
    else
      color = Colors.white;
    return color;
  }

  getBorderColor(i) {
    Color color;
    if (i + 1 < curStep) {
      color = stepCompleteColor?? Color(1);
    } else if (i + 1 == curStep)
      color = currentStepColor?? Color(1);
    else
      color = inactiveColor?? Color(1);

    return color;
  }

  getLineColor(i) {
    var color =
    (curStep ?? 1) > i + 1 ? Colors.blue.withOpacity(0.4) : Colors.grey[200];
    return color;
  }

  List<Widget> _steps() {
    var list = <Widget>[];
    for (int i = 0; i < totalSteps; i++) {
      //colors according to state

      var circleColor = getCircleColor(i);
      var borderColor = getBorderColor(i);
      var lineColor = getLineColor(i);

      // step circles
      list.add(
        Container(
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: circleColor,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
            border: Border.all(
              color: borderColor,
              width: 1.0,
            ),
          ),
          child: getInnerElementOfStepper(i),
        ),
      );

      //line between step circles
      if (i != totalSteps - 1) {
        list.add(
          Expanded(
            child: Container(
              height: lineWidth,
              color: lineColor,
            ),
          ),
        );
      }
    }

    return list;
  }

  Widget getInnerElementOfStepper(index) {
    if (index + 1 < curStep) {
      return Icon(
        Icons.check,
        color: Colors.white,
        size: 16.0,
      );
    } else if (index + 1 == curStep) {
      return Center(
        child: Text(
          '$curStep',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      );
    } else
      return Container();
  }
}