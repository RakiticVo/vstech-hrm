import 'package:equatable/equatable.dart';

/// Supported roles in Phase 0 (Employee and Direct Manager).
enum UserRole {
  employee,
  manager;

  bool get isManager => this == UserRole.manager;
  bool get isEmployee => this == UserRole.employee;

  static UserRole fromString(String? role) {
    if (role == null) return UserRole.employee;
    final r = role.toLowerCase().trim();
    if (r == 'manager' || r == 'ql' || r == 'mss') {
      return UserRole.manager;
    }
    return UserRole.employee;
  }
}

/// Lightweight session user entity stored in memory during active session.
class UserSession extends Equatable {
  const new({
    required this.id,
    required this.name,
    required this.email,
    required this.employeeCode,
    required this.department,
    required this.role,
    this.avatarUrl,
  });

  factory fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id']?.toString() ?? '',
      name: json['fullName']?.toString() ?? json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      employeeCode: json['employeeCode']?.toString() ?? '',
      department: json['department']?.toString() ?? '',
      role: UserRole.fromString(json['role']?.toString()),
      avatarUrl: json['avatarUrl']?.toString(),
    );
  }

  final String id;
  final String name;
  final String email;
  final String employeeCode;
  final String department;
  final UserRole role;
  final String? avatarUrl;

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': name,
        'email': email,
        'employeeCode': employeeCode,
        'department': department,
        'role': role.name,
        'avatarUrl': avatarUrl,
      };

  @override
  List<Object?> get props => [id, name, email, employeeCode, department, role, avatarUrl];
}

/// Sealed state hierarchy for authentication and role session.
sealed class AuthState extends Equatable {
  const new();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const new();
}

class AuthLoading extends AuthState {
  const new();
}

class Authenticated extends AuthState {
  const new({
    required this.user,
    required this.token,
    required this.role,
  });

  final UserSession user;
  final String token;
  final UserRole role;

  @override
  List<Object?> get props => [user, token, role];
}

class Unauthenticated extends AuthState {
  const new({this.message});

  final String? message;

  @override
  List<Object?> get props => [message];
}
