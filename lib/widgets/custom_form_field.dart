import 'package:flutter/material.dart';

import '../constants.dart';

class CustomFormField extends StatelessWidget {
  const CustomFormField(
      {Key? key,
      this.focusNode,
      this.labelText,
      this.initialValue,
      this.maxLines,
      this.obscure = false,
      this.onChanged,
      this.onSaved,
      this.onSubmitted,
      this.textInputAction,
      this.textInputType,
      this.validator,
      this.suffixIconButton})
      : super(key: key);

  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String? labelText;
  final String? initialValue;
  final int? maxLines;
  final bool obscure;
  final Function? onChanged;
  final Function? onSubmitted;
  final Function? onSaved;
  final Function? validator;
  final IconButton? suffixIconButton;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator as String? Function(String?)?,
      onChanged: onChanged as void Function(String)?,
      maxLines: maxLines,
      onFieldSubmitted: onSubmitted as void Function(String)?,
      onSaved: onSaved as void Function(String?)?,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      obscureText: obscure,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: commonTextStyle.copyWith(
          color: const Color(0xFFCCCACA),
        ),
        enabled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusColor: Colors.blue,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        suffixIcon: suffixIconButton,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

class OnTapFormField extends StatelessWidget {
  const OnTapFormField(
      {Key? key,
      this.focusNode,
      this.labelText,
      this.initialValue,
      this.maxLines,
      this.obscure = false,
      this.onChanged,
      this.onSaved,
      this.onSubmitted,
      required this.onTap,
      this.textInputAction,
      this.textInputType,
      this.validator,
      this.suffixIconButton})
      : super(key: key);

  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final TextInputType? textInputType;
  final String? labelText;
  final String? initialValue;
  final int? maxLines;
  final bool obscure;
  final Function? onChanged;
  final Function? onSubmitted;
  final Function? onSaved;
  final VoidCallback? onTap;
  final Function? validator;
  final IconButton? suffixIconButton;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      validator: validator as String? Function(String?)?,
      onChanged: onChanged as void Function(String)?,
      maxLines: maxLines,
      onFieldSubmitted: onSubmitted as void Function(String)?,
      onSaved: onSaved as void Function(String?)?,
      onTap: onTap,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: textInputType,
      obscureText: obscure,
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: commonTextStyle.copyWith(
          color: const Color(0xFFCCCACA),
        ),
        enabled: true,
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(
            color: Colors.red,
            width: 1,
          ),
        ),
        focusColor: Colors.blue,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
          borderSide: BorderSide(
            color: Colors.white,
            width: 1,
          ),
        ),
        suffixIcon: suffixIconButton,
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
