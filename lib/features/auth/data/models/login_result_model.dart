import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/auth/data/models/user_json_model.dart';

/// DTO mapping to LoginResultViewModel from OpenAPI 3.0.1 (docs/api/api-1.json).
class LoginResultModel extends Equatable {
  const new({
    required this.token,
    required this.validTo,
    this.webAllowed,
    this.user,
  });

  factory fromJson(Map<String, dynamic> json) {
    return LoginResultModel(
      token: json['token']?.toString() ?? '',
      validTo: json['validTo']?.toString() ?? '',
      webAllowed: json['webAllowed']?.toString(),
      user: json['user'] is Map<String, dynamic>
          ? UserJsonModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  final String token;
  final String validTo;
  final String? webAllowed;
  final UserJsonModel? user;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'token': token,
        'validTo': validTo,
        'webAllowed': webAllowed,
        'user': user?.toJson(),
      };

  @override
  List<Object?> get props => [token, validTo, webAllowed, user];
}
