import 'package:crm_flutter_project/features/customers/data/models/customer_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/pageable_model.dart';

import 'package:crm_flutter_project/features/employees/data/models/sort_model.dart';

import '../../domain/entities/customers_data.dart';

class CustomersDataModel extends CustomersData {
  const CustomersDataModel({required List<CustomerModel> customers, required PageableModel pageable, required bool last, required int totalPages, required int totalElements, required int size, required int number, required SortModel sort, required bool first, required int numberOfElements, required bool empty}) : super(customers: customers, pageable: pageable, last: last, totalPages: totalPages, totalElements: totalElements, size: size, number: number, sort: sort, first: first, numberOfElements: numberOfElements, empty: empty);

  factory CustomersDataModel.fromJson(Map<String, dynamic> json) => CustomersDataModel(
    customers: List<CustomerModel>.from(
        json["content"].map((x) => CustomerModel.fromJson(x))),
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
    "customers": List<dynamic>.from(customers.map((x) => x.toJson())),
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