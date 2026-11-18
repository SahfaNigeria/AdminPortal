import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidationUtil {
  static String? validatePassword(String value) {
    if (value.trim().isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }
    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return "Email cannot be empty";
    }
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email address";
    }
    return null;
  }

  static void checkValidation({
    required GlobalKey<FormState> globalKey,
    Function? callback,
  }) {
    final isValid = globalKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    globalKey.currentState!.save();
    callback?.call();
  }

  static String? validateName(String value, String title) {
    if (value.trim().isEmpty) {
      return "$title cannot be empty";
    }
    return null;
  }

  static String? validateUrl(String value, String title) {
    if (value.trim().isEmpty) {
      return "$title cannot be empty";
    }
    if (!GetUtils.isURL(value)) {
      return "$title is not a valid url";
    }
    return null;
  }
}
