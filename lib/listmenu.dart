import 'dart:convert';

import 'package:flutter/material.dart';
import 'incrementer.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ListMenu extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _ListMenuState();
}

class _ElementData
{
  String _title;
  int _incrementerAmount;

  _ElementData({String title, int amount})
  {
    _title = title;
    _incrementerAmount = amount;
  }

  factory _ElementData.fromJson(Map<String, dynamic> json)
  {
    return _ElementData(
        title: json['title'],
        amount: json['amount']
    );
  }

  Map<String, dynamic> toJson()  => { 'title': _title, 'amount' : _incrementerAmount };
}


class _ListElement extends StatelessWidget
{
  final int _elementIndex;
  final _ElementData _elementData;
  final Function _callback;
  _ListElement(this._elementIndex, this._elementData, this._callback);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (_elementIndex & 1 == 0) ? Theme.of(context).backgroundColor : Theme.of(context).primaryColorLight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(_elementData._title)
          ),
          Incrementer(_elementIndex, _elementData._incrementerAmount, _callback)
        ],
      ),
    );
  }
}


class _ElementDataList
{
  List<_ElementData> _elements;

  _ElementDataList(this._elements);

  factory _ElementDataList.fromJson(Map<String, dynamic> json) {
    return _ElementDataList(
        json['elements'] != null ?
        List<_ElementData>.from(json['elements'])
            : null);
  }

  Map<String, dynamic> toJson()  => { 'elements': _elements, };
}

class _ListMenuState extends State<ListMenu>
{
  _ElementDataList _elementDataList;

  _loadElements() async
  {
    final directory = await getApplicationDocumentsDirectory();
    File elementsFile = File('${directory.path}/counter.json');
    if(elementsFile.existsSync())
    {
      String contentsAsJson = elementsFile.readAsStringSync();
      Map<String, dynamic> contents = jsonDecode(contentsAsJson);
      List elementsFromJson = contents['elements'] as List;


      setState(() {
        if(elementsFromJson == null)
        {
          _elementDataList = new _ElementDataList(new List<_ElementData>());
        } else
          {
            List<_ElementData> data = elementsFromJson.map((element) => _ElementData.fromJson(element)).toList();
            _elementDataList = new _ElementDataList(data);
          }
      });
    } else
      {
        setState(() {
          _elementDataList = new _ElementDataList(new List<_ElementData>());
        });
        await elementsFile.create();
        await _saveElements();
      }
  }

  _saveElements() async
  {
    final directory = await getApplicationDocumentsDirectory();
    File elementsFile = File('${directory.path}/counter.json');
    String json = jsonEncode(_elementDataList);
    elementsFile.writeAsStringSync(json);
  }

  @override
  initState()
  {
    super.initState();
    _loadElements();
  }

  _askNewTitle(BuildContext context) async {
    Navigator.of(context).pushNamed("/newListItem").then((value) {if(value!=null)_elementDataList._elements.add(new _ElementData(title: value, amount: 0)); _saveElements(); });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    //add elements to the widget list, telling each element its index in the list
    for(int i = 0; i < _elementDataList._elements.length; i++)
    {
      widgets.add(_ListElement(i, _elementDataList._elements[i], (value){ _elementDataList._elements[i]._incrementerAmount = value; _saveElements(); } ));
    }

    widgets.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FloatingActionButton(
                heroTag: "addButton",
                backgroundColor: Theme.of(context).toggleButtonsTheme.color,
                onPressed: () { _askNewTitle(context); },
                tooltip: 'Add element',
                child: Icon(Icons.add)
            ),
          ],
        )
    );


    return ListView(
      children: widgets,
    );
  }
}

class ListMenuForm extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() => _ListMenuFormState();
}

class _ListMenuFormState extends State<ListMenuForm> {
  final _formKey = GlobalKey<FormState>();
  String _newItemName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  return (value.isEmpty) ? 'Please enter some text' : null;
                },
                onSaved: (String value) {
                  setState(() {
                    _newItemName = value;
                  });
                },
              ),
            ),
            FloatingActionButton(
              heroTag: "submitButton",
              child: Icon(Icons.check),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  Navigator.pop<String>(context, _newItemName);
                }
              },
            )
          ],
        ),
      ),
    );
  }

}