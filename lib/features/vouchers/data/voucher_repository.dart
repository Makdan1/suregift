import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/api/dio_client.dart';
import '../../../core/constants/app_constants.dart';
import 'voucher_models.dart';
import 'voucher_operation_models.dart';

final voucherRepositoryProvider = Provider<VoucherRepository>((ref) {
  return VoucherRepository(ref.watch(dioProvider));
});

final vouchersProvider = FutureProvider<List<VoucherHistoryResponse>>((ref) {
  return ref.watch(voucherRepositoryProvider).getVouchers();
});

class VoucherRepository {
  final Dio _dio;

  VoucherRepository(this._dio);

  Future<List<VoucherHistoryResponse>> getVouchers() async {
    try {
      final response = await _dio.get(AppConstants.vouchersUrl);
      return (response.data as List)
          .map((e) => VoucherHistoryResponse.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<VoucherHistoryResponse> getVoucherById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.vouchersUrl}/$id');
      return VoucherHistoryResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VoucherOperationResponse>> getVoucherOperations(int id) async {
    try {
      final response = await _dio.get('${AppConstants.vouchersUrl}/$id/operations');
      return (response.data as List)
          .map((e) => VoucherOperationResponse.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
