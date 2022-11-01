import '../../../../core/utils/wrapper.dart';
import '../../domain/entities/customer_filters.dart';

class CustomerFiltersModel extends CustomerFilters {
  const CustomerFiltersModel(
      {required int pageNumber,
      required int pageSize,
      required String sortDirection,
      required String sortBy,
      required String? fullNameOrPhoneNumber,
      required String? customerTypes,
      required List<int>? lastEventIds,
      required int? startDateTime,
      required int? endDateTime,
      required int? employeeId,
      required int? teamId,
      required String? reminderTypes,
      required List<String>? unitTypes,
      required List<String>? sources,
      required List<String>? projects,
      required List<String>? developers,

      required List<int>? assignedEmployeeIds,
      required List<int>? createdByIds,

      })
      : super(
            pageNumber: pageNumber,
            pageSize: pageSize,
            sortDirection: sortDirection,
            sortBy: sortBy,
            fullNameOrPhoneNumber: fullNameOrPhoneNumber,
            customerTypes: customerTypes,
            lastEventIds: lastEventIds,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            employeeId: employeeId,
            teamId: teamId,
            reminderTypes: reminderTypes,
            unitTypes: unitTypes,
            sources: sources,
            projects: projects,
            developers: developers,
      assignedEmployeeIds: assignedEmployeeIds,
      createdByIds: createdByIds
  );

  factory CustomerFiltersModel.fromJson(Map<String, dynamic> json) =>
      CustomerFiltersModel(
        pageNumber: json["pageNumber"],
        pageSize: json["pageSize"],
        sortDirection: json["sortDirection"],
        sortBy: json["sortBy"],
        fullNameOrPhoneNumber: json["fullNameOrPhoneNumber"],
        customerTypes: json["customerTypes"],
        lastEventIds: json["lastEventIds"],
        startDateTime: json["startDateTime"],
        endDateTime: json["endDateTime"],
        employeeId: json["employeeId"],
        teamId: json["teamId"],
        reminderTypes: json["reminderTypes"],
        unitTypes: json["unitTypes"],
        sources: json["sources"],
        projects: json["projects"],
        developers: json["developers"],

        assignedEmployeeIds: json["assignedEmployeeIds"],
        createdByIds: json["createdByIds"],


      );

  Map<String, dynamic> toJson() => {
        "pageNumber": pageNumber,
        "pageSize": pageSize,
        "sortDirection": sortDirection,
        "sortBy": sortBy,
        "fullNameOrPhoneNumber": fullNameOrPhoneNumber,
        "customerTypes": customerTypes,
        "lastEventIds": lastEventIds,
        "startDateTime": startDateTime,
        "endDateTime": endDateTime,
        "employeeId": employeeId,
        "teamId": teamId,
        "reminderTypes": reminderTypes,
        "unitTypes": unitTypes,
        "sources": sources,
        "projects": projects,
        "developers": developers,

    "assignedEmployeeIds": assignedEmployeeIds,
    "createdByIds": createdByIds,

  };


  Map<String, dynamic> toJsonForAllCustomers() => {
    "fullNameOrPhoneNumber": fullNameOrPhoneNumber,
    "customerTypes": customerTypes,
    "lastEventIds": lastEventIds,
    "startDateTime": startDateTime,
    "endDateTime": endDateTime,
    "employeeId": employeeId,
    "teamId": teamId,
    "reminderTypes": reminderTypes,
    "unitTypes": unitTypes,
    "sources": sources,
    "projects": projects,
    "developers": developers,

    "assignedEmployeeIds": assignedEmployeeIds,
    "createdByIds": createdByIds,

  };



  CustomerFiltersModel copyWith({
    Wrapped<int>? pageNumber,
    Wrapped<int>? pageSize,
    Wrapped<String>? sortDirection,
    Wrapped<String>? sortBy,
    Wrapped<String?>? fullNameOrPhoneNumber,
    Wrapped<String?>? customerTypes,
    Wrapped<List<int>?>? lastEventIds,
    Wrapped<int?>? startDateTime,
    Wrapped<int?>? endDateTime,
    Wrapped<int?>? employeeId,
    Wrapped<int?>? teamId,
    Wrapped<String?>? reminderTypes,
    Wrapped<List<String>?>? unitTypes,
    Wrapped<List<String>?>? sources,
    Wrapped<List<String>?>? projects,
    Wrapped<List<String>?>? developers,

    Wrapped<List<int>?>? assignedEmployeeIds,
    Wrapped<List<int>?>? createdByIds,


  }) {
    return CustomerFiltersModel(
      pageNumber: pageNumber != null ? pageNumber.value : this.pageNumber,
      pageSize: pageSize != null ? pageSize.value : this.pageSize,
      sortDirection:
          sortDirection != null ? sortDirection.value : this.sortDirection,
      sortBy: sortBy != null ? sortBy.value : this.sortBy,
      fullNameOrPhoneNumber: fullNameOrPhoneNumber != null
          ? fullNameOrPhoneNumber.value
          : this.fullNameOrPhoneNumber,
      customerTypes:
          customerTypes != null ? customerTypes.value : this.customerTypes,
      lastEventIds:
          lastEventIds != null ? lastEventIds.value : this.lastEventIds,
      startDateTime:
          startDateTime != null ? startDateTime.value : this.startDateTime,
      endDateTime: endDateTime != null ? endDateTime.value : this.endDateTime,
      employeeId: employeeId != null ? employeeId.value : this.employeeId,
      teamId: teamId != null ? teamId.value : this.teamId,
      reminderTypes:
          reminderTypes != null ? reminderTypes.value : this.reminderTypes,
      unitTypes: unitTypes != null ? unitTypes.value : this.unitTypes,
      sources: sources != null ? sources.value : this.sources,
      projects: projects != null ? projects.value : this.projects,
      developers: developers != null ? developers.value : this.developers,

      assignedEmployeeIds: assignedEmployeeIds != null ? assignedEmployeeIds.value : this.assignedEmployeeIds,
      createdByIds: createdByIds != null ? createdByIds.value : this.createdByIds,

    );
  }

  factory CustomerFiltersModel.initial() {
    return const CustomerFiltersModel(
        pageNumber: 0,
        pageSize: 100,
        sortDirection: "DESC",
        sortBy: "assignedDateTime",
        fullNameOrPhoneNumber: null,
        startDateTime: null,
        endDateTime: null,
        teamId: null,
        lastEventIds: null,
        employeeId: null,
        customerTypes: null,
        reminderTypes: null,
        unitTypes: null,
        sources: null,
        projects: null,
        developers: null,
        assignedEmployeeIds: null,
        createdByIds: null);
  }
}
