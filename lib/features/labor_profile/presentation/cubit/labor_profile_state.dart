import 'package:equatable/equatable.dart';
import 'package:vstech_hrm/features/labor_profile/domain/entities/labor_profile_entity.dart';

enum LaborProfileStatus { initial, loading, success, failure }

class LaborProfileState extends Equatable {
  const new({
    this.status = LaborProfileStatus.initial,
    this.profile,
    this.errorMessage,
  });

  final LaborProfileStatus status;
  final LaborProfileEntity? profile;
  final String? errorMessage;

  LaborProfileState copyWith({
    LaborProfileStatus? status,
    LaborProfileEntity? profile,
    String? errorMessage,
  }) {
    return LaborProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage];
}
