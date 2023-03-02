import 'package:flutter/material.dart';

class ProfileInput extends StatelessWidget {
  const ProfileInput({
    Key? key,
    required this.hintText,
    this.initialvalue,
    this.validator,
    this.readOnly = false,
    this.controller,
    this.inputType,
    this.onsaved,
    this.sIcon,
  }) : super(key: key);
  final String? initialvalue;
  final String hintText;
  // ignore: prefer_typing_uninitialized_variables
  final onsaved;
  // ignore: prefer_typing_uninitialized_variables
  final validator;
  final Icon? sIcon;
  final bool readOnly;
  final TextInputType? inputType;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 5),

    child: Material(
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: inputType,
        readOnly: readOnly,
        onSaved: onsaved,
        initialValue: initialvalue,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          suffixIcon: sIcon,
          label: Text(hintText),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
    ),
    );
  }
}
