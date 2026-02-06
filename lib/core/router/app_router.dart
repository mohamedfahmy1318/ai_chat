import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../di/injection_container.dart' as di;
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/conversations_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static const String splash = '/splash';
  static const String conversations = '/';
  static const String chat = '/chat';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider(create: (_) => di.sl<ChatCubit>(), child: child);
        },
        routes: [
          GoRoute(
            path: conversations,
            builder: (context, state) => const ConversationsScreen(),
          ),
          GoRoute(
            path: '$chat/:conversationId',
            builder: (context, state) {
              final conversationId = state.pathParameters['conversationId'];
              return ChatScreen(conversationId: conversationId);
            },
          ),
        ],
      ),
    ],
  );
}
