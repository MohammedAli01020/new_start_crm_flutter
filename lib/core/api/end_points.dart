class EndPoints {
  static const String baseUrl = 'http://192.168.1.38:5000/';

  // static const String baseUrl = 'http://construction-env.eba-ttpmkd5p.us-east-1.elasticbeanstalk.com/';

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

  // teams
  static const String modifyTeam = '${baseUrl}api/teams/modify';
  static const String pageTeam = '${baseUrl}api/teams/all';
  static const String deleteTeam = '${baseUrl}api/teams/delete/id/';

  // user_teams
  static const String insertAllTeamMember = '${baseUrl}api/user_teams/insert_all';
  static const String pageTeamMember= '${baseUrl}api/user_teams/all';
  static const String deleteAllTeamMembersByIds = '${baseUrl}api/user_teams/delete_all';

  // email
  static const String sendEmail = '${baseUrl}api/email/send';





}
