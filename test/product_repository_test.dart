import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:suregift/features/products/data/product_repository.dart';
import 'package:suregift/core/constants/app_constants.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late ProductRepository repository;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    repository = ProductRepository(mockDio);
  });

  group('ProductRepository', () {
    test('getProducts should return a list of products', () async {
      // Arrange
      final responseData = [
        {'code': 'PROD1', 'name': 'Product 1'},
        {'code': 'PROD2', 'name': 'Product 2'},
      ];

      when(() => mockDio.get(any(), queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: AppConstants.productsUrl),
              ));

      // Act
      final result = await repository.getProducts();

      // Assert
      expect(result.length, 2);
      expect(result[0].code, 'PROD1');
      verify(() => mockDio.get(AppConstants.productsUrl, queryParameters: any(named: 'queryParameters'))).called(1);
    });
  });
}
