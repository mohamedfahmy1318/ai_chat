import '../../../../core/constants/api_constants.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<String> sendMessage(List<MessageModel> messages);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;

  ChatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<String> sendMessage(List<MessageModel> messages) async {
    try {
      final response = await dioClient.post(
        ApiConstants.generateContent,
        data: {
          'contents': messages.map((m) => m.toApiFormat()).toList(),
          'generationConfig': {'temperature': 1.0},
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw ServerException(message: 'Failed to get response');
      }
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
