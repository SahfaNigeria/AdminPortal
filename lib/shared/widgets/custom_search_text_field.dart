import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/theme/colors.dart';
import 'app_text_field.dart';

class CustomSearchTextField extends StatelessWidget {
  final String? Function(String?)? validator;
  final String? fieldTitle;
  void Function(String value)? onChanged;

  final TextEditingController? controller;
   CustomSearchTextField({Key? key, this.validator, this.controller,  this.fieldTitle = "Hospital", this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  AppTextField(
      fillColor:  AppColors.surface,
      validator: validator,
      onChanged: onChanged,

      readOnly: false,
      prefix: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FaIcon(FontAwesomeIcons.search, size: 20,),
      ),
      hintText: "Search $fieldTitle",
      obscureText: false,
      enabled: true,
      controller: controller,
    );
  }
}
