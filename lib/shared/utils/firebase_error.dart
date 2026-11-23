import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'toast.dart';

/// Utility class to catch, parse, and display user-friendly messages for Firebase errors.
class FirebaseError {
  /// Parses any Firebase, Platform, or generic Exception into a clear, human-readable error string.
  static String parseMessage(dynamic error) {
    if (error == null) return "An unexpected error occurred. Please try again.";

    if (error is FirebaseAuthException) {
      return _parseAuthErrorCode(error.code, defaultMessage: error.message);
    }

    if (error is FirebaseException) {
      return _parseFirestoreErrorCode(error.code, defaultMessage: error.message);
    }

    if (error is PlatformException) {
      if (error.message != null && error.message!.isNotEmpty) {
        return _cleanMessage(error.message!);
      }
      return _parseAuthErrorCode(error.code);
    }

    if (error is String) {
      return _cleanMessage(error);
    }

    final String errString = error.toString();
    return _cleanMessage(errString);
  }

  /// Catches and displays an error toast for any [error].
  ///
  /// Optionally accepts [title], [context], and [onTap].
  /// Returns the parsed error message string.
  static String handle(
    dynamic error, {
    String title = "Error Occurred",
    BuildContext? context,
    VoidCallback? onTap,
  }) {
    final String message = parseMessage(error);
    AppToast.error(
      message,
      title: title,
      context: context,
    );
    return message;
  }

  /// Maps Firebase Authentication error codes to user-friendly text messages.
  static String _parseAuthErrorCode(String code, {String? defaultMessage}) {
    switch (code.trim().toLowerCase()) {
      case 'invalid-email':
        return 'The email address is invalid or poorly formatted.';
      case 'user-disabled':
        return 'This account has been disabled by an administrator.';
      case 'user-not-found':
        return 'No registered user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please verify your password and try again.';
      case 'invalid-credential':
        return 'Invalid login credentials. Please check your email and password.';
      case 'email-already-in-use':
        return 'An account with this email address already exists.';
      case 'operation-not-allowed':
        return 'This sign-in option is currently disabled.';
      case 'weak-password':
        return 'Password is too weak. Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection.';
      case 'requires-recent-login':
        return 'For security, please log out and sign in again to perform this action.';
      case 'user-token-expired':
        return 'Your session has expired. Please log in again.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email using a different sign-in method.';
      case 'invalid-verification-code':
        return 'The verification code provided is invalid.';
      case 'invalid-verification-id':
        return 'The verification ID provided is invalid.';
      default:
        if (defaultMessage != null && defaultMessage.isNotEmpty) {
          return _cleanMessage(defaultMessage);
        }
        return 'Authentication error ($code). Please try again.';
    }
  }

  /// Maps Cloud Firestore & Cloud Storage error codes to user-friendly messages.
  static String _parseFirestoreErrorCode(String code, {String? defaultMessage}) {
    switch (code.trim().toLowerCase()) {
      case 'permission-denied':
        return 'You do not have permission to perform this action.';
      case 'unavailable':
        return 'The service is temporarily unavailable. Please try again shortly.';
      case 'not-found':
        return 'The requested document or resource was not found.';
      case 'already-exists':
        return 'This document or resource already exists.';
      case 'resource-exhausted':
        return 'System quota exceeded. Please try again later.';
      case 'failed-precondition':
        return 'Operation failed because the system is not in a valid state.';
      case 'aborted':
        return 'The operation was aborted due to a conflict. Please try again.';
      case 'unauthenticated':
        return 'Authentication required. Please sign in to continue.';
      case 'cancelled':
        return 'The operation was cancelled.';
      case 'data-loss':
        return 'Data loss error occurred. Please contact support.';
      case 'deadline-exceeded':
        return 'Request timed out. Please check your network connection.';
      default:
        if (defaultMessage != null && defaultMessage.isNotEmpty) {
          return _cleanMessage(defaultMessage);
        }
        return 'Database error ($code). Please try again.';
    }
  }

  /// Cleans raw error strings by stripping system prefixes and brackets.
  static String _cleanMessage(String rawMessage) {
    String msg = rawMessage;

    // Strip Exception: prefix
    if (msg.startsWith('Exception: ')) {
      msg = msg.substring(11);
    }

    // Strip [firebase_auth/error-code] or [cloud_firestore/permission-denied] prefixes
    msg = msg.replaceAll(RegExp(r'^\[.*?\]\s*'), '');

    msg = msg.trim();
    if (msg.isEmpty) {
      return 'An unexpected error occurred. Please try again.';
    }

    // Capitalize first letter if needed
    return msg[0].toUpperCase() + msg.substring(1);
  }
}
