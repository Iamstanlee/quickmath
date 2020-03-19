import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmath/helpers/constants.dart';
import 'package:quickmath/helpers/functions.dart';

class BaseTextField extends StatelessWidget {
  final Widget suffix;
  final String labelText;
  final String hintText;
  final List<TextInputFormatter> inputFormatters;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final String initialValue;
  final TextInputType keyboardType;

  BaseTextField(
      {this.suffix,
      this.labelText,
      this.hintText,
      this.inputFormatters,
      this.onSaved,
      this.validator,
      this.controller,
      this.initialValue,
      this.keyboardType = TextInputType.number})
      : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: inputFormatters,
      onSaved: onSaved,
      validator: validator,
      maxLines: 1,
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: TextStyle(
          color: Colors.grey[900], fontSize: 16.0, fontFamily: fontThree),
      decoration: new InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
        hintStyle: TextStyle(
            color: Colors.grey, fontSize: 16.0, fontFamily: fontThree),
        suffixIcon: suffix == null
            ? null
            : new Padding(
                padding: EdgeInsetsDirectional.only(end: 12.0),
                child: suffix,
              ),
        errorStyle: TextStyle(fontSize: 12.0, fontFamily: fontThree),
        errorMaxLines: 3,
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).accentColor, width: 1.0)),
        hintText: hintText,
      ),
    );
  }
}

class RegField extends BaseTextField {
  final int length;
  RegField(
      {@required FormFieldSetter<String> onSaved,
      @required Widget suffix,
      String labelText,
      String hintText,
      this.length})
      : super(
            labelText: labelText,
            hintText: hintText,
            onSaved: onSaved,
            validator: length == null ? validateField : null,
            keyboardType: TextInputType.numberWithOptions(),
            suffix: suffix,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(length == null ? 2 : length)
            ]);

  static String validateField(String value) {
    return value.isNotEmpty
        ? parseInt(value) > 32 ? 'Max number is 32.' : null
        : 'Select number of questions.';
  }
}

class NumberPadField extends StatelessWidget {
  final Widget suffix;
  final String hintText;
  final String initialValue;
  final VoidCallback onSend;

  NumberPadField({
    this.suffix,
    this.initialValue,
    this.hintText,
    this.onSend,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: 1,
      initialValue: initialValue,
      readOnly: true,
      style: TextStyle(
          color: Colors.grey[900], fontSize: 16.0, fontFamily: fontThree),
      decoration: new InputDecoration(
        border: OutlineInputBorder(),
        suffixStyle: TextStyle(
          color: Colors.grey,
        ),
        contentPadding: EdgeInsets.only(left: 16, right: 10),
        labelStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
        hintStyle: TextStyle(
            color: initialValue == '' ? Colors.grey : Colors.black,
            fontSize: 16.0,
            fontFamily: fontThree),
        suffixIcon: suffix == null
            ? null
            : InkWell(
                onTap: onSend,
                child: new Padding(
                  padding: EdgeInsetsDirectional.only(end: 12.0),
                  child: suffix,
                ),
              ),
        errorStyle: TextStyle(fontSize: 12.0, fontFamily: fontThree),
        errorMaxLines: 3,
        isDense: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 0.5)),
        hintText: hintText,
      ),
    );
  }
}
