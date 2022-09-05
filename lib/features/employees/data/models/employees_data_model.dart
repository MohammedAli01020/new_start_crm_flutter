import 'package:crm_flutter_project/features/employees/data/models/employee_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';
import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';

import '../../domain/entities/employees_data.dart';

class EmployeesDataModel extends EmployeesData {
  const EmployeesDataModel(
      {required List<EmployeeModel> employees,
      required PageableModel pageable,
      required bool last,
      required int totalPages,
      required int totalElements,
      required int size,
      required int number,
      required SortModel sort,
      required bool first,
      required int numberOfElements,
      required bool empty})
      : super(
            employees: employees,
            pageable: pageable,
            last: last,
            totalPages: totalPages,
            totalElements: totalElements,
            size: size,
            number: number,
            sort: sort,
            first: first,
            numberOfElements: numberOfElements,
            empty: empty);

  factory EmployeesDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeesDataModel(
        employees: List<EmployeeModel>.from(
            json["content"].map((x) => EmployeeModel.fromJson(x))),
        pageable: PageableModel.fromJson(json["pageable"]),
        last: json["last"],
        totalPages: json["totalPages"],
        totalElements: json["totalElements"],
        size: json["size"],
        number: json["number"],
        sort: SortModel.fromJson(json["sort"]),
        first: json["first"],
        numberOfElements: json["numberOfElements"],
        empty: json["empty"],
      );

  Map<String, dynamic> toJson() => {
        "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
        "pageable": pageable.toJson(),
        "last": last,
        "totalPages": totalPages,
        "totalElements": totalElements,
        "size": size,
        "number": number,
        "sort": sort.toJson(),
        "first": first,
        "numberOfElements": numberOfElements,
        "empty": empty,
      };
}
