import 'package:equatable/equatable.dart';

class CustomerTableConfig extends Equatable {
  final bool showName;
  final bool showPhone;
  final bool showAssignedTo;
  final bool showLastAction;
  final bool showSources;
  final bool showUnitTypes;
  final bool showDevelopers;
  final bool showProjects;
  final bool showLastActionTime;
  final bool showLastComment;
  final bool showInsertDate;
  final bool showCreateBy;
  final bool showAssignedBy;
  final bool showReminderTime;
  final bool showDuplicateNumber;

  const CustomerTableConfig(
      {required this.showName,
      required this.showPhone,
      required this.showAssignedTo,
      required this.showLastAction,
      required this.showSources,
      required this.showUnitTypes,
      required this.showDevelopers,
      required this.showProjects,
      required this.showLastActionTime,
      required this.showLastComment,
      required this.showInsertDate,
      required this.showCreateBy,
      required this.showAssignedBy,
      required this.showReminderTime,
      required this.showDuplicateNumber});

  @override
  List<Object> get props => [
        showName,
        showPhone,
        showAssignedTo,
        showLastAction,
        showSources,
        showUnitTypes,
        showDevelopers,
        showProjects,
        showLastActionTime,
        showLastComment,
        showInsertDate,
        showCreateBy,
        showAssignedBy,
        showReminderTime,
        showDuplicateNumber,
      ];
}
