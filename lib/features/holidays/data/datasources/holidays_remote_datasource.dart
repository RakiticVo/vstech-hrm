import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/holidays/data/models/holiday_model.dart';

abstract class HolidaysRemoteDataSource {
  Future<List<HolidayModel>> getHolidays();
}

class HolidaysRemoteDataSourceImpl implements HolidaysRemoteDataSource {
  const new({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<List<HolidayModel>> getHolidays() async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.holidays);
      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['items'] is List) {
        final list = body['items'] as List;
        return list
            .map((dynamic e) => HolidayModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (body is List) {
        return body
            .map((dynamic e) => HolidayModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <HolidayModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi tải danh mục ngày lễ: $e');
    }
  }
}
