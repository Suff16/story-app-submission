import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/story_provider.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/story_list_screen.dart';
import '../screens/story_detail_screen.dart';
import '../screens/add_story_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/pick_location_screen.dart';

class AppRouter {
  final AuthProvider authProvider;

  AppRouter(this.authProvider);

  late final GoRouter router = GoRouter(
    refreshListenable: authProvider,
    debugLogDiagnostics: true,
    initialLocation: '/splash',

    redirect: (context, state) {
      final isLoggedIn = authProvider.isLoggedIn;
      final isLoading = authProvider.isLoading;
      final location = state.matchedLocation;

      if (isLoading) {
        return location == '/splash' ? null : '/splash';
      }

      if (location == '/splash') {
        return isLoggedIn ? '/stories' : '/login';
      }

      final isAuthPage = location == '/login' || location == '/register';

      if (!isLoggedIn && !isAuthPage) {
        return '/login?from=${Uri.encodeComponent(location)}';
      }

      if (isLoggedIn && isAuthPage) {
        final from = state.uri.queryParameters['from'];
        return from ?? '/stories';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/stories',
        name: 'stories',
        builder: (context, state) => const StoryListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'story_detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StoryDetailScreen(storyId: id);
            },

            // ⭐ Declarative cleanup
            onExit: (context, state) {
              context.read<StoryProvider>().clearSelectedStory();
              return true;
            },
          ),
        ],
      ),
      GoRoute(
        path: '/add-story',
        name: 'add_story',
        builder: (context, state) => const AddStoryScreen(),
        routes: [
          GoRoute(
            path: 'pick-location',
            name: 'pick_location',
            builder: (context, state) => const PickLocationScreen(),
          ),
        ],
      ),
    ],
  );
}
