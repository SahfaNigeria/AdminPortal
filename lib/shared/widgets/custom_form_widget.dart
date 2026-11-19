import 'package:flutter/material.dart';

class CustomFormWidget extends StatelessWidget {
  final Widget? child;
  final AutovalidateMode? autovalidateMode;

  final void Function()? onChanged;

  final Key? formKey;
  const CustomFormWidget({
    Key? key,
    this.child,
    this.autovalidateMode,
    this.onChanged,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: autovalidateMode ?? AutovalidateMode.onUserInteraction,
      onChanged: onChanged,
      key: formKey,
      child: child ?? SizedBox(),
    );
  }
}
