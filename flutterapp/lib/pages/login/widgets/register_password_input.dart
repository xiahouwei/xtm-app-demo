import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';

class RegisterPasswordInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  RegisterPasswordInput({this.label, this.controller, this.validator});

  @override
  State<RegisterPasswordInput> createState() => _RegisterPasswordInputState();
}

class _RegisterPasswordInputState extends State<RegisterPasswordInput> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    return XtmInput(
      label: widget.label,
      controller: widget.controller,
      inputType: TextInputType.visiblePassword,
      obscureText: obscureText,
      clear: true,
      validator: widget.validator,
      suffix: eyeButton(),
    );
  }

  Widget eyeButton() {
    String imageName = 'login_eye_close.png';
    if (!obscureText) {
      imageName = 'login_eye_open.png';
    }
    return GestureDetector(
      child: Image.asset(
        'assets/images/login/$imageName',
        width: 23,
        height: 23,
      ),
      onTap: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
    );
  }
}
