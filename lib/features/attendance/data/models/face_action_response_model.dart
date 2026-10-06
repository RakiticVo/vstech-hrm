/// DTO for Face API action responses (POST /register/, POST /update/, DELETE /delete/).
class FaceActionResponseModel {
  const new({
    required this.status,
    required this.message,
  });

  factory fromJson(Map<String, dynamic> json) {
    final rawStatus = json['status'];
    final status = rawStatus == true ||
        rawStatus?.toString().toLowerCase() == 'true' ||
        rawStatus?.toString().toLowerCase() == 'success' ||
        rawStatus == 1 ||
        rawStatus?.toString() == '1' ||
        json['code'] == 200;
    return FaceActionResponseModel(
      status: status,
      message: json['message']?.toString() ?? json['detail']?.toString() ?? '',
    );
  }

  final bool status;
  final String message;

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
      };
}
