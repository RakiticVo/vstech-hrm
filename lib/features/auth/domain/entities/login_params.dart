import 'package:equatable/equatable.dart';

/// Pure domain parameters for login request.
class LoginParams extends Equatable {
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
