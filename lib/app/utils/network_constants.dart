sealed class NetworkConstants {
  static final String baseUrl = "baseUrl=http://49.249.23.234:80/";
  //http://49.249.23.234

  // static final String baseUrl="baseUrl=http://49.249.23.234:80/api/v1/";
  static final String login = "api/v1/login/login";
  static final String verifyOtp = "api/v1/login/verifyOtp";
  static final String dashboard = "api/v1/mobile/dashboard";
  //static final String projectList = "mobile-api/getProjectByStatus";
  static final String projectList = "api/v1/mobile/getProjectByStatus";
  static final String uploadMilestoneFiles =
      "api/v1/mobile/uploadMilestoneFiles";
  static final String assignedProjectList =
      "api/v1/mobile/getAllAssignedProjects";
  static final String getAllSector = "api/v1/master/getAllSectors";
  static final String uploadProfileImage = "api/v1/user/updateProfile";
  static final String updateLatLng = "api/v1/mobile/updateLatLng";
}
