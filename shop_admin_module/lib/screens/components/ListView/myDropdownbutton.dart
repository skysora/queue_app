import 'package:flutter/material.dart';

class MyDropdownbutton extends StatefulWidget {
  MyDropdownbutton({
    Key? key,
    required this.tags,
  }) : super(key: key);
  final List tags;
  @override
  State<MyDropdownbutton> createState() => MyDropdownbuttonState(tags);
}

class MyDropdownbuttonState extends State<MyDropdownbutton> {
  late List tags;

  MyDropdownbuttonState(List tags) {
    this.tags = tags;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var dropdownValue = tags[0];
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),

      // dropdown below..
      child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 42,
          underline: SizedBox(),
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: tags.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList()),
    );
  }
}
