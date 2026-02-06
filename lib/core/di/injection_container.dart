import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../features/chat/data/datasources/chat_local_datasource.dart';
import '../../features/chat/data/datasources/chat_remote_datasource.dart';
import '../../features/chat/data/models/conversation_model.dart';
import '../../features/chat/data/models/message_model.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/domain/usecases/delete_conversation_usecase.dart';
import '../../features/chat/domain/usecases/get_conversations_usecase.dart';
import '../../features/chat/domain/usecases/save_conversation_usecase.dart';
import '../../features/chat/domain/usecases/send_message_usecase.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../network/dio_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(MessageModelAdapter());
  }
  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(ConversationModelAdapter());
  }

  // Open Hive Boxes
  final conversationsBox = await Hive.openBox<ConversationModel>(
    'conversations',
  );
  sl.registerLazySingleton<Box<ConversationModel>>(() => conversationsBox);

  // Dio
  sl.registerLazySingleton<DioClient>(() => DioClient());

  // ==================== Data Sources ====================

  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(dioClient: sl()),
  );

  sl.registerLazySingleton<ChatLocalDataSource>(
    () => ChatLocalDataSourceImpl(conversationsBox: sl()),
  );

  // ==================== Repositories ====================

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // ==================== Use Cases ====================

  sl.registerLazySingleton(() => SendMessageUseCase(sl()));
  sl.registerLazySingleton(() => GetConversationsUseCase(sl()));
  sl.registerLazySingleton(() => SaveConversationUseCase(sl()));
  sl.registerLazySingleton(() => DeleteConversationUseCase(sl()));

  // ==================== Cubits ====================

  sl.registerFactory<ChatCubit>(
    () => ChatCubit(
      sendMessageUseCase: sl(),
      getConversationsUseCase: sl(),
      saveConversationUseCase: sl(),
      deleteConversationUseCase: sl(),
    ),
  );
}
