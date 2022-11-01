class EndPoints {
  // static const String baseUrl = 'http://192.168.1.22:5000/';

  // new start url
  // static const String baseUrl = 'http://newstartcrm-env.eba-mtaqwgeq.us-east-1.elasticbeanstalk.com/';

  // test new start url

  static const String baseUrl = 'http://testnewstart-env.eba-ujdigsqp.us-east-1.elasticbeanstalk.com/';




  static const String login = '${baseUrl}login';

  // employees
  static const String modifyEmployee = '${baseUrl}api/employees/modify';
  static const String pageEmployee = '${baseUrl}api/employees/all';
  static const String deleteEmployee= '${baseUrl}api/employees/delete/id/';
  static const String findEmployeeById = '${baseUrl}api/employees/id/';

  static const String employeeReports = '${baseUrl}api/employees/report';


  // customers
  static const String modifyCustomer = '${baseUrl}api/customers/modify';
  static const String pageCustomers = '${baseUrl}api/customers/page';
  static const String allCustomers = '${baseUrl}api/customers/all';
  static const String deleteCustomer= '${baseUrl}api/customers/delete/id/';

  static const String deleteAllCustomersByIds = '${baseUrl}api/customers/delete_all_by_ids';

  static const String updateCustomerLastAction = '${baseUrl}api/customers/update_last_action';
  static const String updateCustomers = '${baseUrl}api/customers/update';
  static const String updateCustomerFullName = '${baseUrl}api/customers/update_full_name';
  static const String updateCustomerDescription = '${baseUrl}api/customers/update_description';
  static const String duplicateCustomersByPhoneNo = '${baseUrl}api/customers/duplicated_phone_no';
  static const String updateCustomerSources = '${baseUrl}api/customers/update_sources';
  static const String updateCustomerUnitTypes = '${baseUrl}api/customers/update_unit_types';

  static const String updateCustomerAssignedEmployee = '${baseUrl}api/customers/update_assigned_employee';
  static const String deleteCustomerAssignedEmployee = '${baseUrl}api/customers/delete_assigned_employee';
  static const String updateCustomerPhoneNumber = '${baseUrl}api/customers/update_phone_number';

  static const String updateCustomerDevelopersAndProjects = '${baseUrl}api/customers/update_developers_and_projects';



  // teams
  static const String modifyTeam = '${baseUrl}api/teams/modify';
  static const String pageTeam = '${baseUrl}api/teams/all';
  static const String deleteTeam = '${baseUrl}api/teams/delete/id/';

  // user_teams
  static const String insertAllTeamMember = '${baseUrl}api/user_teams/insert_all';
  static const String pageTeamMember= '${baseUrl}api/user_teams/all';
  static const String allTeamMembers = '${baseUrl}api/user_teams/employees/';

  static const String deleteAllTeamMembersByIds = '${baseUrl}api/user_teams/delete_all';
  static const String fetchAllTeamMembersIds = '${baseUrl}api/user_teams/';

  // email
  static const String sendEmail = '${baseUrl}api/email/send';

  // roles
  static const String modifyRole = '${baseUrl}api/roles/modify';
  static const String allRoles = '${baseUrl}api/roles/all';
  static const String deleteRole= '${baseUrl}api/roles/delete/id/';
  static const String roleByEmployeeId = '${baseUrl}api/roles/';


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

  // developers
  static const String modifyDeveloper = '${baseUrl}api/developers/modify';
  static const String allDevelopers = '${baseUrl}api/developers/all';
  static const String deleteDeveloper= '${baseUrl}api/developers/delete/id/';

  // projects
  static const String modifyProject= '${baseUrl}api/projects/modify';
  static const String allProjects = '${baseUrl}api/projects/all';
  static const String deleteProject = '${baseUrl}api/projects/delete/id/';

  // permissions
  static const String allPermissions = '${baseUrl}api/permissions/all';


  // customer_logs
  static const String pageCustomerLogs = '${baseUrl}api/customer_logs/all';

  // employees assigns_report
  static const String allEmployeeAssignsReports = '${baseUrl}api/employees/assigns_report';

  // employees own_reports
  static const String employeeOwnReports = '${baseUrl}api/statistics/employee';

  // files
  static const String uploadFiles = '${baseUrl}api/files/uploadFiles';
  static const String deleteFiles = '${baseUrl}api/files/deleteFiles';
  static const String uploadFile = '${baseUrl}api/files/uploadFile';
  static const String deleteFile = '${baseUrl}api/files/deleteFile';


  // pre_defined_roles
  static const String modifyPreDefinedRole = '${baseUrl}api/pre_defined_roles/modify';
  static const String allPreDefinedRoles = '${baseUrl}api/pre_defined_roles/all';
  static const String deletePreDefinedRole= '${baseUrl}api/pre_defined_roles/delete/id/';

}
