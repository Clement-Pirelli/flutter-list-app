import 'package:flutter/material.dart';


class Incrementer extends StatefulWidget
{
  final int _index;
  final int _originalAmount;
  final Function _changeCallback;
  Incrementer(this._index, this._originalAmount, this._changeCallback);
  @override
  _IncrementerState createState() =>_IncrementerState(_originalAmount, _changeCallback);
}

class _IncrementerState extends State<Incrementer>
{
  Function _changeCallback;

  _IncrementerState(int originalAmount, Function callback) : super()
  {
    _counter = originalAmount;
    _changeCallback = callback;
  }

  _increment()
  {
    setState(() {
      _counter++;
    });
    _changeCallback(_counter);
  }

  _decrement()
  {
    setState(() {
      _counter--;
    });
    _changeCallback(_counter);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingActionButton(
            heroTag: "incrementer_FAB_${widget._index}_right",
            backgroundColor: Theme.of(context).toggleButtonsTheme.color,
            onPressed: _decrement,
            tooltip: 'Decrement by one',
            child: Icon(Icons.remove)
        ),
        Container(
            width: 50.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            alignment: Alignment.center,
            child: Text(_counter.toString())
        ),
        FloatingActionButton(
            heroTag: "incrementer_FAB_${widget._index}_left",
            backgroundColor: Theme.of(context).toggleButtonsTheme.color,
            onPressed: _increment,
            tooltip: 'Increment by one',
            child: Icon(Icons.add)
        ),
      ],
    );
  }

  int _counter = 0;
  int get counter{ return _counter; }
}