import 'package:vstech_hrm/core/constants/api_endpoints.dart';
import 'package:vstech_hrm/core/errors/exceptions.dart';
import 'package:vstech_hrm/core/network/dio_client.dart';
import 'package:vstech_hrm/features/payroll/data/models/payroll_summary_model.dart';
import 'package:vstech_hrm/features/payroll/data/models/payslip_detail_model.dart';

abstract class PayrollRemoteDataSource {
  Future<PayslipDetailModel> getPayslipDetail(int id);
  Future<List<PayrollSummaryModel>> getPayrollSummary(int id);
}

class PayrollRemoteDataSourceImpl implements PayrollRemoteDataSource {
  const new({required DioClient dioClient}) : _dioClient = dioClient;

  final DioClient _dioClient;

  @override
  Future<PayslipDetailModel> getPayslipDetail(int id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.payslipDetail(id));
      final dynamic body = response.data;
      if (body is Map<String, dynamic>) {
        return PayslipDetailModel.fromJson(body);
      }
      throw const ServerException(message: 'Phản hồi chi tiết phiếu lương không hợp lệ');
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi tải chi tiết phiếu lương: $e');
    }
  }

  @override
  Future<List<PayrollSummaryModel>> getPayrollSummary(int id) async {
    try {
      final response = await _dioClient.get<dynamic>(ApiEndpoints.payrollSummary(id));
      final dynamic body = response.data;
      if (body is Map<String, dynamic> && body['data'] is List) {
        final list = body['data'] as List;
        return list
            .map((dynamic e) => PayrollSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (body is List) {
        return body
            .map((dynamic e) => PayrollSummaryModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return <PayrollSummaryModel>[];
    } on AppException {
      rethrow;
    } on Object catch (e) {
      throw ServerException(message: 'Lỗi tải tổng quan bảng lương: $e');
    }
  }
}
