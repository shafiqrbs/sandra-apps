import 'package:get/get.dart';

mixin ValidatorMixin {
  static const String _requiredErrorMessage = 'This field is required';

  String? noValidator(String? value) {
    return null;
  }

  String? requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return _requiredErrorMessage;
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (!GetUtils.isEmail(value!)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? phoneValidator(String? value) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (!GetUtils.isPhoneNumber(value!)) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? numberValidator(String? value) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (!GetUtils.isNumericOnly(value!)) {
      return 'Please enter a valid number';
    }
    return null;
  }

  String? dateValidator(String? value) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (!GetUtils.isDateTime(value!)) {
      return 'Please enter a valid date';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (value!.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value, String? password) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (value != password) {
      return 'Password does not match';
    }
    return null;
  }

  String? urlValidator(String? value) {
    if (requiredValidator(value) != null) {
      return _requiredErrorMessage;
    }
    if (!GetUtils.isURL(value!)) {
      return 'Please enter a valid URL';
    }
    return null;
  }
}
