import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

class TopSnapSheetExample extends StatefulWidget {
  @override
  _TopSnapSheetExampleState createState() => _TopSnapSheetExampleState();
}

class _TopSnapSheetExampleState extends State<TopSnapSheetExample> with SingleTickerProviderStateMixin{
  var _controller = SnappingSheetController();
  AnimationController _arrowIconAnimationController;
  Animation<double> _arrowIconAnimation;

  double _moveAmount = 0.0;

  @override
  void initState() {
    super.initState();
    _arrowIconAnimationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _arrowIconAnimation = Tween(begin: 0.0, end: 0.5).animate(CurvedAnimation(
      curve: Curves.elasticOut, 
      reverseCurve: Curves.elasticIn,
      parent: _arrowIconAnimationController)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ListView example'),
      ),
      body: SnappingSheet(
        sheetBelow: Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment(0.90, -1.0),
            child: FloatingActionButton(
              onPressed: () {
                if(_controller.snapPositions.last != _controller.currentSnapPosition) {
                  _controller.snapToPosition(_controller.snapPositions.last);
                } 
                else {
                  _controller.snapToPosition(_controller.snapPositions.first);
                }
              },
              child: RotationTransition(
                child: Icon(Icons.arrow_upward),
                turns: _arrowIconAnimation,
              ),
            ),
          ),
        ),
        onSnapEnd: () {
          if(_controller.snapPositions.last != _controller.currentSnapPosition) {
            _arrowIconAnimationController.reverse();
          }
          else {
            _arrowIconAnimationController.forward();
          }
        },
        onMove: (moveAmount) {
          setState(() {
            _moveAmount = moveAmount;
          });
        },
        snappingSheetController: _controller,
        snapPositions: const [
          SnapPosition(positionFactor: 0.2, snappingCurve: Curves.elasticOut, snappingDuration: Duration(milliseconds: 750)),
          SnapPosition(positionFactor: 0.6),
          SnapPosition(positionFactor: 1.0),
        ],
        initSnapPosition: SnapPosition(positionFactor: 1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Moved ${_moveAmount.round()} pixels',
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
        grabbingHeight: MediaQuery.of(context).padding.bottom + 50,
        grabbing: GrabSection(),
        sheetAbove: SheetContent(),
      ),
    );
  }
}


class SheetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.all(20.0),
        itemCount: 50,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[300], width: 1.0))
            ),
            child: ListTile(
              leading: Icon(Icons.info),
              title: Text('List item $index'),
            ),
          );
        },
      ),
    );
  }
}


class GrabSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(
          blurRadius: 20.0,
          color: Colors.black.withOpacity(0.2),
        )],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 2.0,
            margin: EdgeInsets.only(left: 20, right: 20),
            color: Colors.grey[300],
          ),
          Container(
            width: 100.0,
            height: 10.0,
            margin: EdgeInsets.only(bottom: 15.0),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
          ),
        ],
      ),
    );
  }
}