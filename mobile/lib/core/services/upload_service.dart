import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import '../constants/api_constants.dart';
import '../error/exceptions.dart';
import 'token_service.dart';
import 'package:riverpod/riverpod.dart';

class UploadService {
  final http.Client _client;
  final TokenService _tokenService;

  UploadService(this._client, this._tokenService);

  Future<List<String>> uploadPropertyImages(List<File> images) async {
    try {
      final token = await _tokenService.getToken();
      final urls = <String>[];

      for (final image in images) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.propertyPhotos}'),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(
          await http.MultipartFile.fromPath(
            'photo',
            image.path,
            filename: path.basename(image.path),
          ),
        );

        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          final url = Uri.parse(responseData).toString();
          urls.add(url);
        } else {
          throw ApiException(
            message: 'Failed to upload image: ${response.statusCode}',
            statusCode: response.statusCode,
          );
        }
      }

      return urls;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw NetworkException(message: 'Failed to upload images: ${e.toString()}');
    }
  }

  Future<List<String>> uploadPropertyDocuments(List<File> documents) async {
    try {
      final token = await _tokenService.getToken();
      final urls = <String>[];

      for (final document in documents) {
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('${ApiConstants.baseUrl}${ApiConstants.propertyDocuments}'),
        );

        request.headers['Authorization'] = 'Bearer $token';
        request.files.add(
          await http.MultipartFile.fromPath(
            'document',
            document.path,
            filename: path.basename(document.path),
          ),
        );

        final response = await request.send();
        final responseData = await response.stream.bytesToString();

        if (response.statusCode == 201) {
          final url = Uri.parse(responseData).toString();
          urls.add(url);
        } else {
          throw ApiException(
            message: 'Failed to upload document: ${response.statusCode}',
            statusCode: response.statusCode,
          );
        }
      }

      return urls;
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw NetworkException(message: 'Failed to upload documents: ${e.toString()}');
    }
  }

  Future<void> deleteFile(String fileUrl) async {
    try {
      final token = await _tokenService.getToken();
      final response = await _client.delete(
        Uri.parse(fileUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw ApiException(
          message: 'Failed to delete file',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw NetworkException(message: 'Failed to delete file: ${e.toString()}');
    }
  }
}


final uploadServiceProvider = Provider<UploadService>((ref) {
  return UploadService(
    http.Client(),
    ref.watch(tokenServiceProvider),
  );
});