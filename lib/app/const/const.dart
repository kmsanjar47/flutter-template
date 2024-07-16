enum UserType{
  ADMIN,
  STUFF
}

// const String mainBaseURL = "http://93.119.14.194:8030";
// const String securityBaseURL = "http://93.119.14.194:8020";
const String mainBaseURL = "http://10.22.0.3:8000";
const String securityBaseURL = "http://10.22.0.3:8880";
// const String mainBaseURL = "http://10.22.0.3:8000";
// const String securityBaseURL = "http://10.22.0.3:8880";
// const String mainBaseURL = "http://127.0.0.1:8000";
// const String securityBaseURL = "http://127.0.0.1:8880";

const String mainOpenBaseURL = "$mainBaseURL/api/v1/open";
const String mainAppBaseURL = "$mainBaseURL/api/v1/close";

const String securityOpenBaseURL = "$securityBaseURL/api/v1/open";
const String securityAppBaseURL = "$securityBaseURL/api/v1/close";

const aURL =  mainOpenBaseURL;
const oURL = mainAppBaseURL;

const String basicAuth = "ksfjal-aslfk-lsjdfl-eowir-sldkfj";