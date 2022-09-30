enum EmployeeTypes {
  NOT_ASSIGNED,
  NOT_IN_MEMBER,
  ALL,
  TEAM_LEADERS,
  NOT_TEAM_LEADERS,
  NOT_TEAM_LEADERS_NOT_IN_TEAM,
  I_CREATED
}

enum CustomerTypes { ALL, ME, ME_AND_TEAM, TEAM, NOT_ASSIGNED }

enum EmployeePickerTypes {
  SELECT_TEAM_LEADER,
  SELECT_TEAM_MEMBER,
  ASSIGN_MEMBER,
  SELECT_EMPLOYEE

}

enum RoleType { SELECT_ROLES, VIEW_ROLES }

enum EventType { SELECT_EVENT, VIEW_EVENTS }

enum SourceType { SELECT_SOURCES, VIEW_SOURCES }

enum UnitTypesType { SELECT_UNIT_TYPES, VIEW_UNIT_TYPES }

enum DevelopersType { SELECT_DEVELOPERS, VIEW_DEVELOPERS }

enum PreDefinedRoleType { SELECT_PRE_DEFINED_ROLES, VIEW_PRE_DEFINED_ROLES, }

enum ReminderTypes {
  ALL,
  DELAYED,
  NOW,
  SKIP,
  NO_EVENT
}

enum TeamTypes {
  ALL,
  ME
}

enum PermissionsType {
  view_all_leads,
  view_assigned_leads,
  view_own_leads,
  view_team_leads,
  edit_all_leads,
  edit_assigned_leads,
  edit_own_leads,
  edit_team_leads,
  delete_all_leads,
  delete_assigned_leads,
  delete_own_leads,
  delete_team_leads,
  view_lead_name,
  view_lead_creator,
  view_lead_phone,
  view_lead_note,
  edit_lead_name,
  edit_lead_creator,
  edit_lead_phone,
  edit_lead_note,
  delete_lead_phone,
  create_employees,
  edit_employees,
  delete_employees,
  view_employees,
  create_action,
  bulk_actions,
  bulk_import,
  bulk_export,
  available_to_assign,
  view_events,
  edit_events,
  create_events,
  delete_events,
  view_projects,
  edit_projects,
  create_projects,
  delete_projects,
  view_unit_type,
  edit_unit_type,
  create_unit_type,
  delete_unit_type,
  view_not_assigned_leads
}
