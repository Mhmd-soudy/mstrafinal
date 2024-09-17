String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return " Name required!";
  }
  return null;
}

String? validateUpdateName(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return null;
}

// String? validateEmail(String? value) {
//   if (value == null || value.isEmpty) {
//     return "email adress required!";
//   } else if (!RegExp(
//           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//       .hasMatch(value)) {
//     return "invalid email adress";
//   }
//   return null;
// }

// String? validateUpdateEmail(String? value) {
//   if (value == null || value.isEmpty) {
//     return null;
//   } else if (!RegExp(
//           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//       .hasMatch(value)) {
//     return "invalid email adress";
//   }
//   return null;
// }
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email address required!";
  }
  return null; // No email format validation, so any input is valid
}

String? validateUpdateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return "Email address required!";
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return "password required!";
  } else if (!RegExp(r'^.{8,}$').hasMatch(value)) {
    return "password must have 8 characters or more ";
  }
  return null;
}

String? validateUpdatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (!RegExp(r'^.{8,}$').hasMatch(value)) {
    return "password must have 8 characters or more ";
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return "Phone Number required!";
  } else if (!RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(value)) {
    return "invalid Phone Number";
  }
  return null;
}

String? validateUpdatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (!RegExp(r'^(010|011|012|015)[0-9]{8}$').hasMatch(value)) {
    return "invalid Phone Number";
  }
  return null;
}
