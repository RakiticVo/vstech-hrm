import 'package:equatable/equatable.dart';

/// Domain entity representing the result of face verification against registered baseline.
class FaceVerifyResultEntity extends Equatable {
  const new({
    required this.isSuccess,
    required this.isMatch,
    required this.message,
    this.similarity,
  });

  final bool isSuccess;
  final bool isMatch;
  final String message;
  final double? similarity;

  @override
  List<Object?> get props => [isSuccess, isMatch, message, similarity];
}
