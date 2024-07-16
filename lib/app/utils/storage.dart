import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:m_expense/app/const/const.dart';

import '../routes/app_pages.dart';

class AppStorage {
  final instance = GetStorage();

  final userName = "".val("userRoleName");
  final userProfileName = "".val("userProfileName");
  final userProfilePhoto = "".val("userProfilePhoto");
  final userRoleName = "".val("userRoleName");
  final userRoleId = 0.val("userRoleId");
  final userId = "abcd-efgh-ijkl-mnop-qrst-uvwx-yz".val("userId");
  final isActiveUser = 0.val("userActive");
  final login = false.val("login");
  final remember = false.val("remember");
  final refreshToken = ''.val("refreshToken");
  final token = ''.val("token");
  final otpRestInterval = 2.val("otpRestInterval");
  final languageCode = "en".val("languageCode");
  final countryCode = "UK".val("DU");
  final userType = UserType.STUFF.toString().val("userType");

  Future<void> loginUser(
      {required bool login,
         bool? remember,
        required String userId,
        required String userName,
        required String refreshToken,
        required String token,
        int? tokenExpireAt,
        String userProfileName = ""
      }) async {
    this.userProfileName .val= userProfileName;
    this.login.val = login;
    this.userId.val = userId;
    this.userName.val = userName;
    this.refreshToken.val = refreshToken;
    this.token.val = token;
    this.remember.val = remember??false;
    
    Get.toNamed(Routes.HOME);
    userType.val = UserType.STUFF.toString();
  }

  logOutUser() async {
    // await NotificationService().removeNotificationToken();
    login.val = false;
    userId.val = "";
    userName.val = '';
    refreshToken.val = '';
    token.val = '';
    Get.offAllNamed(Routes.LOGIN);
  }
}