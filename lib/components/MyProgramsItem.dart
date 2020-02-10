/*
import 'package:flutter/material.dart';
import 'package:anad_magicar/models/fake/coach_model.dart';
import 'package:anad_magicar/models/viewmodel/myprograms_vm.dart';
import 'package:anad_magicar/ui/coach/coach_detail_page.dart';

class MyProgramsItem extends StatefulWidget
{

  final MyProgramsVM myProgramsVM;
  final int isDiet;

  MyProgramsItem(this.myProgramsVM,this.isDiet);

  @override
  MyProgramsItemState createState() {
    // TODO: implement createState
    return new MyProgramsItemState();
  }

}

class MyProgramsItemState extends State<MyProgramsItem>
{
  //MyProgramsVM myProgramsVM;
  //int isDiet;
  String renderUrl;
  Size screenSize;


  MyProgramsItemState();


  @override
  void initState() {
    super.initState();
    renderProgramPic();
  }


  void renderProgramPic() async {
    // await coach.getImageUrl();
    setState(() {
      renderUrl=widget.isDiet==1 ? "assets/images/foods.png" : "assets/images/exercise.png";
    });
  }


  Widget programImage(int diet) {
    renderUrl=(diet==1) ? "assets/images/foods.png" : "assets/images/exercise.png";
    var programAvatar = new Hero(
      tag: diet==1 ? widget.myProgramsVM.requestProgramDiet :widget.myProgramsVM.exercisePrograms,
      child: new Container(
        width: 50.0,
        height: 50.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new AssetImage(renderUrl ?? ''),//new NetworkImage( ?? ''),
          ),
        ),
      ),
    );

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
          'MYPROGRAMS',
          textAlign: TextAlign.center,
        ));

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: programAvatar,
      crossFadeState: renderUrl == null
          ? CrossFadeState.showFirst
          : CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 1000),
    );

    return crossFade;
  }

  Widget get programCard {
    return new Positioned(
      right: 0.0,
      top: 0.0,
      child: new Container(
        margin: EdgeInsets.all(3.0),
        width: screenSize.width-50.0,
        height: 145.0,
        child: new Card(
          margin: EdgeInsets.only(top: 10.0, bottom: 18.0),
          color: Color(0x100288D1),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(40.0),bottomLeft: Radius.circular(3.0) ),
          ),
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 2.0,
              bottom: 0.0,
              left: 2.0,
            ),
            child: new Container(
              constraints: new BoxConstraints.expand(
                height: 220.0,
              ),
              padding: new EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
              decoration: new BoxDecoration(

              ),
              child: new Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  new Container(
                    constraints: new BoxConstraints.expand(
                      height: 190.0,
                      width: 200.0,
                    ),
                    margin: EdgeInsets.only(right: 105.0,bottom: 2.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: <Widget>[
                          new Text(widget.isDiet==1 ? widget.myProgramsVM.requestProgramDiet.requestProgramDietDetail.titleofprogram :
                                            widget.myProgramsVM.exercisePrograms.exerciseProgramDetail.titleofprogram,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )
                          ),

                          new Text(widget.isDiet==1 ? widget.myProgramsVM.requestProgramDiet.requestProgramDietDetail.description :
                          widget.myProgramsVM.exercisePrograms.exerciseProgramDetail.description,
                              softWrap: true,
                              overflow: TextOverflow.fade,
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )

                          ),
                          new Text( widget.myProgramsVM.request.scheduleduration.toString(),
                              style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )

                          ),
                          new Text(widget.myProgramsVM.programLevel,
                              style: new TextStyle(color: Colors.pink[200],
                                fontWeight: FontWeight.bold,
                                fontSize: 12.0,
                              )

                          ),
                        ]
                    ),

                  ),
                  */
/*new Positioned(
                    left: 0.0,
                    bottom: -20.0,
                    child:*//*

                  new Positioned(
                      right: -18.0,
                      bottom: -10.0,
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[

                            new Icon(Icons.stars,color: Colors.greenAccent,size: 34.0,),
                            new Text(widget.myProgramsVM.programLevel,style: new TextStyle(color: Colors.blueAccent[100],fontSize: 14.0,fontWeight: FontWeight.bold),),
                          ]
                      )
                  ),
                  new Positioned(
                      left: 0.0,
                      bottom: -20.0,
                      child: new Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,

                        children: <Widget>[

                          */
/*new Stack(
                    overflow: Overflow.visible ,
                        children: <Widget>[*//*


                          */
/*Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new Text('20000',style: new TextStyle(color: Colors.pink[100],fontSize: 12.0,
                                letterSpacing: 1.0,
                                wordSpacing: 5.0,
                                fontWeight: FontWeight.bold),),
                          ),*//*

                          */
/*Padding(
                            padding:
                            EdgeInsets.only(
                                left: 8.0,
                                bottom: 0.0,
                                right: 0.0,
                                top: 0.0
                            ),
                            child: new Icon(Icons.monetization_on,color: Colors.blueAccent[200],size: 26.0,),
                          ),*//*


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

                        // ),

                        // ],
                      )



                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenSize=MediaQuery.of(context).size;

    return new InkWell(
      onTap: () => showProgramDetailPage(context,widget.myProgramsVM),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: new Container(
          padding: EdgeInsets.all(3.0),
          margin: EdgeInsets.all(4.0),
          height: 125.0,
          child: new Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              programCard,
              new Positioned(top: -14.0,right: -10.0, child:  programImage(widget.isDiet)),

            ],
          ),
        ),
      ),
    );
  }

  showProgramDetailPage(BuildContext context,MyProgramsVM pr) {
    Navigator.pushNamed(context, '/programdetail',arguments: widget.myProgramsVM);
  }

}
*/
