import 'package:stable/persistance/update_one_field.dart';

void setPhoneNumberField(String userId, String value) {
  updateOneField("user", userId, "phoneNumber", value);
}

void setAgeField(String userId, String value) {
  updateOneField("user", userId, "Age", value);
}

void setProfileLinkField(String userId, String value) {
  updateOneField("user", userId, "FFE_link", value);
}
