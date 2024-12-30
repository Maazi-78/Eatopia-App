import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  CustomTextField({
    super.key,
    required this.emailController,
    required this.boxH,
    required Color primaryColor,
    required this.hintText,
    required this.labelText,
    required this.validator,
    this.icon,
    this.inputType = TextInputType.text,
    this.readOnly = false,
  }) : _primaryColor = primaryColor;

  final TextEditingController emailController;
  double boxH;
  final Color _primaryColor;
  final String hintText;
  final String labelText;
  String? Function(String?)? validator;
  final Icon? icon;
  final TextInputType inputType;
  final bool readOnly;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: widget.readOnly,
      controller: widget.emailController,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      cursorColor: Colors.grey[600],
      keyboardType: widget.inputType,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        constraints: BoxConstraints(maxHeight: widget.boxH, maxWidth: 400),
        label: Text(widget.labelText),
        prefixIcon: widget.icon,
        floatingLabelStyle:
            TextStyle(color: widget._primaryColor, fontSize: 15),
        labelStyle: TextStyle(color: widget._primaryColor, fontSize: 10),
        hintText: widget.hintText,
        hintStyle: const TextStyle(fontSize: 14),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget._primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: widget._primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget._primaryColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
      ),
      validator: widget.validator,
    );
  }
}

class PasswordTextField extends StatefulWidget {
  PasswordTextField({
    super.key,
    required this.passwordController,
    required this.boxPassH,
    required Color primaryColor,
    required this.hintText,
    required this.labelText,
    required this.validator,
    this.passIcon = const Icon(
      Icons.visibility,
      size: 20,
    ),
  }) : _primaryColor = primaryColor;

  final TextEditingController passwordController;
  Icon passIcon;
  final double boxPassH;
  final Color _primaryColor;
  final String labelText;
  final String hintText;
  String? Function(String?)? validator;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.passwordController,
      onTapOutside: (event) => FocusScope.of(context).unfocus(),
      obscureText: _isObscure,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
          fillColor: Colors.white,
          suffix: IconButton(
            onPressed: () {
              setState(() {
                _isObscure = !_isObscure;
                if (_isObscure) {
                  widget.passIcon = const Icon(
                    Icons.visibility,
                    size: 20,
                  );
                } else {
                  widget.passIcon = const Icon(
                    Icons.visibility_off,
                    size: 20,
                  );
                }
              });
            },
            icon: widget.passIcon,
            iconSize: 20,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          constraints:
              BoxConstraints(maxHeight: widget.boxPassH, maxWidth: 400),
          label: Text(widget.labelText),
          floatingLabelStyle:
              TextStyle(color: widget._primaryColor, fontSize: 15),
          prefixIcon: const Icon(Icons.password, color: Colors.black, size: 20),
          labelStyle: TextStyle(color: widget._primaryColor, fontSize: 10),
          hintText: widget.hintText,
          hintStyle: const TextStyle(fontSize: 14),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget._primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: widget._primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: widget._primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          )),
      validator: widget.validator,
    );
  }
}
