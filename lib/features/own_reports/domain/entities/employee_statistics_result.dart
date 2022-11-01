import 'package:equatable/equatable.dart';

class EmployeeStatisticsResult extends Equatable {
  const EmployeeStatisticsResult({
    required this.employeeLastEventsReportList,
    required this.employeeCustomerTypesCount,
  });

  final List<EmployeeLastEventsReportList> employeeLastEventsReportList;
  final EmployeeCustomerTypesCount employeeCustomerTypesCount;

  factory EmployeeStatisticsResult.fromJson(Map<String, dynamic> json) =>
      EmployeeStatisticsResult(
        employeeLastEventsReportList: List<EmployeeLastEventsReportList>.from(
            json["employeeLastEventsReportList"].map((x) =>
                EmployeeLastEventsReportList.fromJson(x))),
        employeeCustomerTypesCount: EmployeeCustomerTypesCount.fromJson(
            json["employeeCustomerTypesCount"]),
      );

  Map<String, dynamic> toJson() =>
      {
        "employeeLastEventsReportList": List<dynamic>.from(
            employeeLastEventsReportList.map((x) => x.toJson())),
        "employeeCustomerTypesCount": employeeCustomerTypesCount.toJson(),
      };

  @override
  List<Object> get props =>
      [employeeLastEventsReportList, employeeCustomerTypesCount,];
}

class EmployeeCustomerTypesCount extends Equatable {
  const EmployeeCustomerTypesCount({
    required this.all,
    required this.delayed,
    required this.now,
    required this.skip,
    required this.noEvent,
    required this.own,
    required this.notAssigned,


  });

  final int all;
  final int delayed;
  final int now;
  final int skip;
  final int noEvent;

  final int own;
  final int notAssigned;

  factory EmployeeCustomerTypesCount.fromJson(Map<String, dynamic> json) =>
      EmployeeCustomerTypesCount(
        all: json["all"] ?? 0,
        delayed: json["delayed"]  ?? 0,
        now: json["now"] ?? 0,
        skip: json["skip"] ?? 0,
        noEvent: json["noEvent"] ?? 0,
        own: json["own"] ?? 0,
        notAssigned: json["notAssigned"] ?? 0,

      );

  Map<String, dynamic> toJson() =>
      {
        "all": all,
        "delayed": delayed,
        "now": now,
        "skip": skip,
        "noEvent": noEvent,

        "own": own,
        "notAssigned": notAssigned,

      };

  @override
  List<Object> get props => [all, delayed, now, skip, noEvent, own, notAssigned];
}

class EmployeeLastEventsReportList extends Equatable {
  const EmployeeLastEventsReportList({
    required this.eventName,
    required this.count,
  });

  final String eventName;
  final int count;

  factory EmployeeLastEventsReportList.fromJson(Map<String, dynamic> json) =>
      EmployeeLastEventsReportList(
        eventName: json["eventName"],
        count: json["count"] ?? 0,
      );

  Map<String, dynamic> toJson() =>
      {
        "eventName": eventName,
        "count": count,
      };

  @override
  List<Object> get props => [eventName, count];
}


