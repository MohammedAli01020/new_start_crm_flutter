class EndPoints {
  // static const String baseUrl = 'http://192.168.1.38:5000/';

  static const String baseUrl = 'http://construction-env.eba-ttpmkd5p.us-east-1.elasticbeanstalk.com/';

  static const String login = '${baseUrl}login';

  // employees
  static const String modifyEmployee = '${baseUrl}api/employees/modify';
  static const String pageEmployee = '${baseUrl}api/employees/all';
  static const String deleteEmployee= '${baseUrl}api/employees/delete/id/';
  static const String findEmployeeById = '${baseUrl}api/employees/id/';


  // customers
  static const String modifyCustomer = '${baseUrl}api/customers/modify';
  static const String pageCustomer = '${baseUrl}api/customers/all';
  static const String deleteCustomer= '${baseUrl}api/customers/delete/id/';
  static const String updateCustomerLastAction = '${baseUrl}api/customers/update_last_action';
  static const String updateCustomers = '${baseUrl}api/customers/update';
  static const String updateCustomerFullName = '${baseUrl}api/customers/update_full_name';
  static const String updateCustomerDescription = '${baseUrl}api/customers/update_description';
  static const String duplicateCustomersByPhoneNo = '${baseUrl}api/customers/duplicated_phone_no';
  static const String updateCustomerSources = '${baseUrl}api/customers/update_sources';
  static const String updateCustomerUnitTypes = '${baseUrl}api/customers/update_unit_types';

  static const String updateCustomerAssignedEmployee = '${baseUrl}api/customers/update_assigned_employee';
  static const String deleteCustomerAssignedEmployee = '${baseUrl}api/customers/delete_assigned_employee';

  // teams
  static const String modifyTeam = '${baseUrl}api/teams/modify';
  static const String pageTeam = '${baseUrl}api/teams/all';
  static const String deleteTeam = '${baseUrl}api/teams/delete/id/';

  // user_teams
  static const String insertAllTeamMember = '${baseUrl}api/user_teams/insert_all';
  static const String pageTeamMember= '${baseUrl}api/user_teams/all';
  static const String deleteAllTeamMembersByIds = '${baseUrl}api/user_teams/delete_all';
  static const String fetchAllTeamMembersIds = '${baseUrl}api/user_teams/';

  // email
  static const String sendEmail = '${baseUrl}api/email/send';



  // roles
  static const String modifyRole = '${baseUrl}api/roles/modify';
  static const String allRoles = '${baseUrl}api/roles/all';
  static const String deleteRole= '${baseUrl}api/roles/delete/id/';

  // events
  static const String modifyEvent = '${baseUrl}api/events/modify';
  static const String allEvent = '${baseUrl}api/events/all';
  static const String deleteEvent= '${baseUrl}api/events/delete/id/';

  // sources
  static const String modifySource = '${baseUrl}api/sources/modify';
  static const String allSources = '${baseUrl}api/sources/all';
  static const String deleteSource= '${baseUrl}api/sources/delete/id/';

  // unit_types
  static const String modifyUnitType = '${baseUrl}api/unit_types/modify';
  static const String allUnitTypes = '${baseUrl}api/unit_types/all';
  static const String deleteUnitType= '${baseUrl}api/unit_types/delete/id/';

  // permissions
  static const String allPermissions = '${baseUrl}api/permissions/all';


  // customer_logs
  static const String pageCustomerLogs = '${baseUrl}api/customer_logs/all';

  // employees assigns_report
  static const String allEmployeeAssignsReports = '${baseUrl}api/employees/assigns_report';



}
