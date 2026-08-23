sealed class NetworkConstants {
  static final String baseUrl = "baseUrl=http://49.249.23.234:80/";
  //http://49.249.23.234

  // static final String baseUrl="baseUrl=http://49.249.23.234:80/api/v1/";
  static final String login = "api/v1/pms/login/login";
  static final String verifyOtp = "api/v1/pms/login/verifyOtp";
  static final String dashboard = "api/v1/pms/mobile/dashboard";
  //static final String projectList = "mobile-api/getProjectByStatus";
  static final String projectList = "api/v1/pms/mobile/getProjectByStatus";
  static final String uploadMilestoneFiles =
      "api/v1/pms/mobile/uploadMilestoneFiles";
  // static final String assignedProjectList =
  //     "api/v1/pms/mobile/getAllAssignedProjects";
  static final String getAllSector = "api/v1/pms/master/getAllSectors";
  static final String getAllFinancialYears =
      "api/v1/pms/master/getAllFinancialYears";
  static final String uploadProfileImage = "api/v1/pms/user/updateProfile";
  static final String updateLatLng = "api/v1/pms/mobile/updateLatLng";
  static final String pendingProjectList =
      "api/v1/pms/mobile/getProjectNotVisited";
  static final String stateDashboard = "api/v1/pms/mobile/stateDashboard";
  static final String stateOfficerList =
      "api/v1/pms/mobile/getStateProjectByStatus";

  static final String getOfficerDetails = "api/v1/pms/mobile/getOfficerDetails";
  static final String exportAssignedProjects =
      "api/v1/pms/mobile/exportAssignedProjects";
  static final String updateFunctionality =
      "api/v1/pms/mobile/updateFunctionality";
  static final String getQuestionnaire = "api/v1/pms/mobile/questionnaire";
  static final String postQuestionnaire = "api/v1/pms/mobile/questionnaire";
}
