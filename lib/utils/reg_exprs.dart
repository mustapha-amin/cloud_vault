final RegExp emailRegex = RegExp(
  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
);

bool isValidEmail(String email) {
  return emailRegex.hasMatch(email);
}

RegExp passwordRegex =
    RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_])?.{8,}$");

bool isValidPassword(String password) {
  return passwordRegex.hasMatch(password);
}
