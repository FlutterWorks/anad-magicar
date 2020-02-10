
import 'package:anad_magicar/components/no_data_widget.dart';
import 'package:anad_magicar/components/wave_progress/wave_progress.dart';
import 'package:anad_magicar/model/invoice/invoice.dart';
import 'package:anad_magicar/model/invoice/invoice_detail.dart';
import 'package:anad_magicar/repository/center_repository.dart';
import 'package:anad_magicar/utils/dart_helper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anad_magicar/components/CircleImage.dart';
import 'package:anad_magicar/translation_strings.dart';


class InvoiceListItem extends StatelessWidget {


  InvoiceListItem({
    @required this.invoiceModel,
    @required this.planCounts
  });

  InvoiceModel invoiceModel;


  String renderUrl;
  Size screenSize;

  int planCounts = 0;


  Widget remainDayProgress(double progressValue) {
    var progress = new WaveProgress(
        50.0, Colors.blueAccent, Colors.redAccent, progressValue);

    var placeholder = new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: new Text(
          'COACHGO',
          textAlign: TextAlign.center,
        ));

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: progress,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return progress;
  }

  Widget remainAmountProgress(double progressValue) {
    var progress = new WaveProgress(50.0,
        Colors.blueAccent,
        Colors.redAccent,
        progressValue);

    var placeholder = new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: new Text(
          'COACHGO',
          textAlign: TextAlign.center,
        ));

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: progress,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return progress;
  }

  Widget get invoiceCard {
    return new Positioned(
      right: 0.0,
      top: 0.0,
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        width: screenSize.width - 50.0,
        height: 175.0,
        child: new Card(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          color: Color(0x100288D1),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(70.0),
                bottomLeft: Radius.circular(3.0)),
          ),
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              bottom: 0.0,
              left: 2.0,
            ),
            child: new Container(
              constraints: new BoxConstraints.expand(
                height: 230.0,
              ),
              padding: new EdgeInsets.only(
                  left: 16.0, bottom: 8.0, right: 16.0),
              decoration: new BoxDecoration(

              ),
              child: new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  new Container(
                    constraints: new BoxConstraints.expand(
                      height: 200.0,
                      width: 200.0,
                    ),
                    margin: EdgeInsets.only(right: 105.0, bottom: 2.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          new Text(invoiceModel.DisplayName,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )
                          ),

                          new Text(DartHelper.isNullOrEmptyString(invoiceModel
                              .InvoiceDate),
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )

                          ),
                          new Text(DartHelper.isNullOrEmptyString(invoiceModel
                              .Description),
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )

                          ),
                          new Text(DartHelper.isNullOrEmptyString(invoiceModel
                              .Amount.toString()),
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: new TextStyle(color: Colors.pink[200],
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )

                          ),
                        ]
                    ),

                  ),

                  /* new Positioned(
                    right: 0,
                    bottom: 0,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[

                            new Icon(Icons.stars,color: Colors.greenAccent,size: 54.0,),
                        new Text(DartHelper.isNullOrEmptyString(widget.invoiceModel.StartDate) ,style: new TextStyle(color: Colors.blueAccent[100],fontSize: 14.0,fontWeight: FontWeight.bold),),
                        new Icon(Icons.monetization_on,color: Colors.redAccent,size: 54.0,),
                        new Text(DartHelper.isNullOrEmptyString(widget.invoiceModel.Amount.toString()) ,style: new TextStyle(color: Colors.blueAccent[100],fontSize: 14.0,fontWeight: FontWeight.bold),),
                        GestureDetector(
                          onTap: () {},
                          child:
                        new Icon(Icons.visibility,color: Colors.redAccent,size: 54.0,),),
                        //new Text(DartHelper.isNullOrEmptyString(widget.invoiceModel.) ,style: new TextStyle(color: Colors.blueAccent[100],fontSize: 14.0,fontWeight: FontWeight.bold),),

                      ]
                  )
                  ),*/
                  /* new Positioned(
                    left: 0.0,
                      bottom: -20.0,
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: <Widget>[


new Stack(

                    overflow: Overflow.visible ,
                        children: <Widget>[


                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: new Text(DartHelper.isNullOrEmptyString(widget.invoiceModel.EndDate),style: new TextStyle(color: Colors.pink[100],fontSize: 12.0,
                          letterSpacing: 1.0,
                          wordSpacing: 5.0,
                        fontWeight: FontWeight.bold),),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:
                      Padding(
                        padding:
                        EdgeInsets.only(
                          left: 48.0,
                          bottom: 0.0,
                          right: 0.0,
                          top: 0.0
                        ),
                        child: new Icon(Icons.monetization_on,color: Colors.blueAccent[200],size: 26.0,),
                      ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(
                          left: 8.0,
                          bottom: 0.0,
                          right: 8.0,
                          top: 0.0
                      ),
                        child: new Icon(Icons.thumb_up,color: Colors.amber[200],size: 30.0,),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 0.0,
                          bottom: 0.0,
                          right: 8.0,
                          top: 0.0
                      ),
                        child: new Icon(Icons.add_comment,color: Colors.black45,size: 30.0,),
                      ),

                  ],

                  ),

                ],
              )



  ),*/
                ],
              ),
            ),

          ),
        ),
      ),
    );
  }

  Widget invoiceDetailCard(InvoiceDetailModel invDetail) {
    return new Positioned(
      right: 0.0,
      top: 0.0,
      child: new Container(
        margin: EdgeInsets.symmetric(vertical: 6.0),
        width: screenSize.width - 50.0,
        height: 175.0,
        child: new Card(
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
          color: Color(0x100288D1),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(70.0),
                bottomLeft: Radius.circular(3.0)),
          ),
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              bottom: 0.0,
              left: 2.0,
            ),
            child: new Container(
              constraints: new BoxConstraints.expand(
                height: 230.0,
              ),
              padding: new EdgeInsets.only(
                  left: 16.0, bottom: 8.0, right: 16.0),
              decoration: new BoxDecoration(

              ),
              child: new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  new Container(
                    constraints: new BoxConstraints.expand(
                      height: 200.0,
                      width: 200.0,
                    ),
                    margin: EdgeInsets.only(right: 105.0, bottom: 2.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(invDetail.Description,
                            style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            )
                        ),

                        new Positioned(
                          right: 0.0,
                          bottom: -25.0,
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                new Icon(Icons.stars, color: Colors.greenAccent,
                                  size: 54.0,),
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  createInvoiceDetailsListItem(InvoiceDetailModel invDetail) {
    if (planCounts > 0) {
      invDetail.planModel = centerRepository
          .getPlans()
          .where((p) => p.PlanId == invDetail.PlanId)
          .toList()
          .first;
      return new InkWell(
        onTap: () {},
        child: new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: new Container(
            padding: EdgeInsets.all(3.0),
            margin: EdgeInsets.all(4.0),
            height: 175.0,
            child: new Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                invoiceDetailCard(invDetail),
                new Positioned(top: -14.0, right: -10.0,
                    child: remainAmountProgress(invDetail.RemainAmount != null ?
                    invDetail.RemainAmount : 0.0)),
                new Positioned(top: -14.0, left: -10.0,
                    child: remainDayProgress(double.tryParse(
                        invDetail.RemainCount != null ? invDetail.RemainCount
                            .toString() : '0'))),

              ],
            ),
          ),
        ),
      );
    }
    else {
      return NoDataWidget();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery
        .of(context)
        .size;

    return
      invoiceCard;
  }
}




