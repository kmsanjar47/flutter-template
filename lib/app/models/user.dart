import 'dart:convert';

class User {
  String? id;
  DateTime? lastLogin;
  bool? isSuperuser;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  bool? isStaff;
  bool? isActive;
  DateTime? dateJoined;
  String? actionType;
  DateTime? actionDate;
  String? actionBy;
  DateTime? createdAt;
  int? designation;
  String? otp;
  DateTime? otpCreated;
  bool? isVerified;
  List<dynamic>? groups;
  List<dynamic>? userPermissions;

  User({
    this.id,
    this.lastLogin,
    this.isSuperuser = false,
    this.username,
    this.firstName = '',
    this.lastName = '',
    this.email,
    this.isStaff = false,
    this.isActive = false,
    this.dateJoined,
    this.actionType = '',
    this.actionDate,
    this.actionBy = '',
    this.createdAt,
    this.designation = 0,
    this.otp = '',
    this.otpCreated,
    this.isVerified = false,
    this.groups = const [],
    this.userPermissions = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      isSuperuser: json['is_superuser'],
      username: json['username'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      isStaff: json['is_staff'],
      isActive: json['is_active'],
      dateJoined: json['date_joined'] != null ? DateTime.parse(json['date_joined']) : null,
      actionType: json['action_type'] ?? '',
      actionDate: json['action_date'] != null ? DateTime.parse(json['action_date']) : null,
      actionBy: json['action_by'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      designation: json['designation'] ?? 0,
      otp: json['otp'] ?? '',
      otpCreated: json['otp_created'] != null ? DateTime.parse(json['otp_created']) : null,
      isVerified: json['is_verified'] ?? false,
      groups: json['groups'] ?? [],
      userPermissions: json['user_permissions'] ?? [],
    );
  }
  factory User.fromString(String source) {
    Map<String, dynamic> json = jsonDecode(source);
    return User(
      id: json['id'],
      lastLogin: json['last_login'] != null ? DateTime.parse(json['last_login']) : null,
      isSuperuser: json['is_superuser'],
      username: json['username'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'],
      isStaff: json['is_staff'],
      isActive: json['is_active'],
      dateJoined: json['date_joined'] != null ? DateTime.parse(json['date_joined']) : null,
      actionType: json['action_type'] ?? '',
      actionDate: json['action_date'] != null ? DateTime.parse(json['action_date']) : null,
      actionBy: json['action_by'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      designation: json['designation'] ?? '',
      otp: json['otp'] ?? '',
      otpCreated: json['otp_created'] != null ? DateTime.parse(json['otp_created']) : null,
      isVerified: json['is_verified'] ?? false,
      groups: json['groups'] ?? [],
      userPermissions: json['user_permissions'] ?? [],
    );
  }
}
