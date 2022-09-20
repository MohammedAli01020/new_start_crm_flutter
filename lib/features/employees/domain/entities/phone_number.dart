import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable {
  const PhoneNumber({
    required this.phone,
    required this.isoCode,
    required this.countryCode
  });

  final String phone;
  final String isoCode;
  final String countryCode;

  @override
  List<Object> get props => [phone, isoCode, countryCode];
}
