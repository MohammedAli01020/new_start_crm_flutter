import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/phone_number.dart';

class PhoneNumberModel extends PhoneNumber {
  const PhoneNumberModel({required String phone, required String isoCode,required String countryCode})
      : super(phone: phone, isoCode: isoCode, countryCode: countryCode);

  factory PhoneNumberModel.fromJson(Map<String, dynamic> json) =>
      PhoneNumberModel(
        phone: json["phone"],
        isoCode: json["isoCode"],
        countryCode : json["countryCode"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "isoCode": isoCode,
    "countryCode" : countryCode
      };



  PhoneNumberModel copyWith({
    Wrapped<String>? phone,
    Wrapped<String>? isoCode,
    Wrapped<String>? countryCode,


  }) {
    return PhoneNumberModel(
      phone: phone != null ? phone.value : this.phone,
      isoCode: isoCode != null ? isoCode.value : this.isoCode,
      countryCode: countryCode != null ? countryCode.value : this.countryCode,

    );
  }




}
