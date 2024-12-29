import 'package:flutter/material.dart';

class CustomInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool suffixIcon;
  final bool? isDense;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    this.suffixIcon = false,
    this.isDense,
    this.obscureText = false,
    this.controller,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.labelText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 3,
                    color: Colors.black.withOpacity(0.25),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50
                  .withOpacity(0.7), // جعل الخلفية شفافة قليلاً
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.brown, width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: TextFormField(
              obscureText: (widget.obscureText && _obscureText),
              decoration: InputDecoration(
                isDense: widget.isDense ?? false,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  color: Colors.grey.shade700,
                  backgroundColor: Colors.transparent,
                  fontStyle: FontStyle.italic,
                ),
                suffixIcon: widget.suffixIcon
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.remove_red_eye
                              : Icons.visibility_off_outlined,
                          color: Colors.black54,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      )
                    : null,
                suffixIconConstraints: widget.isDense != null
                    ? const BoxConstraints(maxHeight: 33)
                    : null,
                border: InputBorder.none,
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (textValue) {
                if (textValue == null || textValue.isEmpty) {
                  return 'required!';
                }
                return null;
              },
              controller: widget.controller,
            ),
          ),
        ],
      ),
    );
  }
}
