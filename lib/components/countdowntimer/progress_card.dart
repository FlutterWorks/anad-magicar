import 'package:anad_magicar/components/circular_progress_bar.dart';
import 'package:anad_magicar/data/rxbus.dart';
import 'package:anad_magicar/model/change_event.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatefulWidget {

  double width;
  bool isOn;
  bool isOff;
  double progress;
  @override
  _ProgressCardState createState() => _ProgressCardState();

  ProgressCard({
    @required this.width,
    @required this.isOn,
    @required this.isOff,
    this.progress,
  });
}

class _ProgressCardState extends State<ProgressCard> {
  double progressPercent = 0;


  void registerRXBus()
  {
    RxBus.register<ChangeEvent>().listen((ChangeEvent event)  {
      if(event.message=='UPDATE_PROGRESS')
        {
          setState(() {
            progressPercent=event.amount;
          });

        }
    });
  }
  @override
  void initState() {
    registerRXBus();
    super.initState();
    if(widget.progress!=null)
      progressPercent=widget.progress;
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color foreground = Colors.red;

    if (progressPercent >= 0.8) {
      foreground = Colors.green;
    } else if (progressPercent >= 0.4) {
      foreground = Colors.orange;
    }
    if(widget.isOn)
      {
        foreground = Colors.lightGreenAccent;
      }
    if(widget.isOff)
      foreground = Colors.redAccent;

    Color background = foreground.withOpacity(0.2);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: widget.width,
          child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              child: /*Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFff1744).withAlpha(80),
                      blurRadius: 7.0,
                      spreadRadius: 5.0,
                      offset: Offset(
                        0.0,
                        3.0,
                      ),
                    ),
                  ],
                ),
                child:
                Padding(
                  padding: EdgeInsets.all( 0.0),
                  child:*/
                  CircleProgressBar(
                    backgroundColor: background,
                    foregroundColor: foreground,
                    value: this.progressPercent,
                  ),
                /*),
              ),*/

              onTap: () {
                final updated = ((this.progressPercent + 0.1).clamp(0.0, 1.0) *
                    100);
                setState(() {
                  this.progressPercent = updated.round() / 100;
                });
              },
              onDoubleTap: () {
                final updated = ((this.progressPercent - 0.1).clamp(0.0, 1.0) *
                    100);
                setState(() {
                  this.progressPercent = updated.round() / 100;
                });
              },
            ),
          ),
        ),
        //Text("${this.progressPercent * 100}%"),
      ],
    );
  }
}
