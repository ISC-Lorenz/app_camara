import 'package:flutter/material.dart';

class TextBoxWidget extends StatelessWidget {
  final String field;
  final TextEditingController txtcontroller;
  final IconData iconText;
  final TextInputType inputType;
  final bool isPassword;
  final String txtTitle;

  const TextBoxWidget({
    super.key,
    required this.field,
    required this.txtcontroller,
    required this.iconText,
    required this.inputType,
    required this.isPassword,
    required this.txtTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(18),
      child: TextFormField(
        obscureText: isPassword,
        controller: txtcontroller,
        keyboardType: inputType,
        decoration: InputDecoration(
          label: Text(txtTitle),
          hintText: "Por favor ingrese $field",
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green, width: 2.5),
          ),
          suffix: Icon(iconText),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '*El campo es obligatorio';
          } else {
            return null;
          }
        },
      ),
    );
  }
}
