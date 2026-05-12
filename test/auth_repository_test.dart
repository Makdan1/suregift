import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:suregift/features/auth/data/auth_repository.dart';
import 'package:suregift/core/constants/app_constants.dart';

class MockDio extends Mock implements Dio {}
class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late AuthRepository repository;
  late MockDio mockDio;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockSecureStorage();
    repository = AuthRepository(mockDio, mockStorage);
    
    // Default mock behavior
    when(() => mockStorage.write(
      key: any(named: 'key'),
      value: any(named: 'value'),
    )).thenAnswer((_) async => {});
  });

  group('AuthRepository', () {
    test('login should return LoginResponse on success and save token', () async {
      // Arrange
      final responseData = {
        'accessToken': 'test_token',
        'user': {'email': 'test@mail.com'}
      };
      
      when(() => mockDio.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 200,
                requestOptions: RequestOptions(path: AppConstants.loginUrl),
              ));

      // Act
      final result = await repository.login('test@mail.com', 'Password1@');

      // Assert
      expect(result.accessToken, 'test_token');
      verify(() => mockStorage.write(key: AppConstants.tokenKey, value: 'test_token')).called(1);
    });
  });
}
