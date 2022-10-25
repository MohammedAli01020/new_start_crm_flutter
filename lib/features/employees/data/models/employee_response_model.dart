
import '../../domain/entities/employee_response.dart';

class EmployeeResponseModel extends EmployeeResponse {
  const EmployeeResponseModel({
    required int employeeId,
    required String fullName,
    required String? imageUrl,
  }) : super(
      employeeId: employeeId,
      fullName: fullName,
      imageUrl: imageUrl,);

  factory EmployeeResponseModel.fromJson(Map<String, dynamic> json) => EmployeeResponseModel(
    employeeId: json["employeeId"],
    fullName: json["fullName"],
    imageUrl: json["imageUrl"],
  );

  Map<String, dynamic> toJson() => {
    "employeeId": employeeId,
    "fullName": fullName,
    "imageUrl": imageUrl
  };
}
