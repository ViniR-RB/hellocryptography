import 'package:flutter/material.dart';

class TextFieldCustom extends StatelessWidget {
  final EdgeInsets? padding;
  final String? labelText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function()? onTap;
  const TextFieldCustom({
    super.key,
    this.controller,
    this.labelText,
    this.padding = const EdgeInsets.all(8),
    this.validator,
    this.onChanged,
    this.onTap,
  });
  final _border = const OutlineInputBorder();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding!,
      child: TextFormField(
        onTap: () => onTap,
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
            labelText: labelText,
            border: _border,
            errorBorder: _border.copyWith(
                borderSide: const BorderSide(color: Colors.red))),
      ),
    );
  }
}
