import 'package:equatable/equatable.dart';

class PhoneNumber extends Equatable {
  const PhoneNumber({
    required this.phone,
    required this.isoCode,
  });

  final String phone;
  final String isoCode;

  @override
  List<Object> get props => [phone, isoCode];
}
