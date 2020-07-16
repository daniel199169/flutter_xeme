import 'package:flutter/material.dart';
import 'package:xenome/firebase_services/build_manager.dart';
import 'package:xenome/models/postion.dart';
import 'package:xenome/utils/session_manager.dart';

class CustomMoveableItem extends StatefulWidget {
//  BuildContext context;
  Widget child;
  Position position;
  Function updatePosition;
  CustomMoveableItem(this.child, this.position, this.updatePosition);
  @override
  State<StatefulWidget> createState() {
    return _CustomMoveableItemState();
  }
}

class _CustomMoveableItemState extends State<CustomMoveableItem> {
  double xPosition = 0;
  double yPosition = 0;
  Color color;


  @override
  void initState() {

    color = Colors.red;
    super.initState();
    getPositionList();

    if (widget.position != null) {
      xPosition = widget.position.x;
      yPosition = widget.position.y;
    } else {
//       yPosition = MediaQuery.of(context).size.height / 2;
    }
  }

  getPositionList() async{
    List<double> _positionList = await BuildManager.getPositionList(SessionManager.getUserId());
    setState(() {
      xPosition = _positionList[0];
      yPosition = _positionList[1];

    });
  }



  @override
  Widget build(BuildContext context) {
    // if (widget.position == null) {
    //   xPosition = MediaQuery.of(context).size.width / 2;
    //   yPosition = MediaQuery.of(context).size.height / 2;
    // }
    if (yPosition == 0 && widget.position == null) {
      yPosition = MediaQuery.of(context).size.height / 4;
    }
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
           
            // updatePostion(xPosition, yPosition);
           
            xPosition += tapInfo.delta.dx;
            yPosition += tapInfo.delta.dy;
          });
        },
        onPanEnd: (tapInfo) {
          List<double> positionList = [];
          positionList.add(xPosition);
          positionList.add(yPosition);
       

          BuildManager.updatePosition(positionList, SessionManager.getUserId());

         
//          widget.updatePosition(xPosition, yPosition);
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          // height: 150,
          color: Colors.transparent,
          child: widget.child,
        ),
      ),
    );
  }
}
