import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class DropDownMenuMode extends StatefulWidget {
  final String hinttext;
  final List<dynamic> items;
  final dynamic selectedItem;
  final Function setdata;
  final TextEditingController? controller;
  const DropDownMenuMode(
      {Key? key,
        required this.hinttext,
        this.selectedItem,
        this.controller,
        required this.items,
        required this.setdata})
      : super(key: key);

  @override
  _DropDownMenuModeState createState() => _DropDownMenuModeState();
}

class _DropDownMenuModeState extends State<DropDownMenuMode> {
  bool valid = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      height: valid ? 50 : 60,
      child: Theme(
        data: ThemeData(
          primaryColor: const Color(0xff1B2072),
          primarySwatch: Colors.deepPurple,
        ),
        child: DropdownSearch<dynamic>(
          validator: (v) {
            if (v == null) {
              setState(() {
                valid = false;
              });
              return "required field";
            } else {
              setState(() {
                valid = true;
              });
              return null;
            }
          },

          dropdownSearchDecoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            label: Text(widget.hinttext),
            alignLabelWithHint: false,
            fillColor: const Color(0xffFAFAFA),
            hintStyle: const TextStyle(
                color: Colors.black,fontSize: 14
            ),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),

          // dropdownSearchDecoration: InputDecoration(
          //   alignLabelWithHint: false,
          //   hintText: widget.hinttext,
          //   filled: true,
          //   fillColor: Colors.white,
          //   contentPadding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
          //   border: const OutlineInputBorder(),
          // ),
          mode: Mode.MENU,
          items: widget.items.map((e) => e).toList(),
          itemAsString: (val) {
            if (val.runtimeType == String) {
              return val;
            }
            return val.name;
          },
          showClearButton: false,
          onChanged: (val) {
            widget.setdata(val);
          },
          selectedItem: widget.selectedItem,
        ),
      ),
    );
  }
}
