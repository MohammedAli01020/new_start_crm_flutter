import '../../domain/entities/phone_number.dart';

class PhoneNumberModel extends PhoneNumber {
  const PhoneNumberModel({required String phone, required String isoCode})
      : super(phone: phone, isoCode: isoCode);

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      PhoneNumberModel(
        phone: json["phone"],
        isoCode: json["isoCode"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "isoCode": isoCode,
      };
}
