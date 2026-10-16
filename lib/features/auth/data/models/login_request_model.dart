import 'package:equatable/equatable.dart';

/// DTO mapping to LoginViewModel from OpenAPI 3.0.1 (docs/api/api-1.json).
class LoginRequestModel extends Equatable {
  const new({
    required this.username,
    required this.password,
    this.deviceId,
    this.model,
    this.brand,
    this.platform,
    this.versionRelease,
    this.versionApp,
    this.checkMobile = true,
    this.root = '0',
    this.tsAppVerSion,
    this.isJsc,
    this.email,
    this.phone,
    this.userCode,
    this.tokenId,
  });

  final String username;
  final String password;
  final String? deviceId;
  final String? model;
  final String? brand;
  final String? platform;
  final String? versionRelease;
  final String? versionApp;
  final bool checkMobile;
  final String root;
  final String? tsAppVerSion;
  final int? isJsc;
  final String? email;
  final String? phone;
  final String? userCode;
  final String? tokenId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'username': username,
      'password': password,
      'check_mobile': checkMobile,
      'root': root,
    };
    if (deviceId != null) map['device_id'] = deviceId;
    if (model != null) map['model'] = model;
    if (brand != null) map['brand'] = brand;
    if (platform != null) map['platform'] = platform;
    if (versionRelease != null) map['version_release'] = versionRelease;
    if (versionApp != null) map['version_app'] = versionApp;
    if (tsAppVerSion != null) map['tsAppVerSion'] = tsAppVerSion;
    if (isJsc != null) map['is_jsc'] = isJsc;
    if (email != null) map['email'] = email;
    if (phone != null) map['phone'] = phone;
    if (userCode != null) map['user_code'] = userCode;
    if (tokenId != null) map['token_id'] = tokenId;
    return map;
  }

  @override
  List<Object?> get props => [
        username,
        password,
        deviceId,
        model,
        brand,
        platform,
        versionRelease,
        versionApp,
        checkMobile,
        root,
        tsAppVerSion,
        isJsc,
      ];
}
