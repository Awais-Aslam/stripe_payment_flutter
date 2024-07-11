import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.title,
    required this.hint,
    this.isNumber,
    required this.controller,
    required this.formKey,
  });

  final String title;
  final String hint;
  final bool? isNumber;
  final TextEditingController controller;
  final Key formKey;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: TextFormField(
        keyboardType:
            widget.isNumber == null ? TextInputType.text : TextInputType.number,
        decoration: InputDecoration(
          label: Text(widget.title),
          hintText: widget.hint,
        ),
        validator: (value) => value!.isEmpty ? "Cannot be empty" : null,
        controller: widget.controller,
      ),
    );
  }
}
