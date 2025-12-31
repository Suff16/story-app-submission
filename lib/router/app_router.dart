import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/story_list_screen.dart';
import '../screens/story_detail_screen.dart';
import '../screens/add_story_screen.dart';
import '../screens/splash_screen.dart';

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

      if (isLoggedIn && isAuthPage) {
        return '/stories';
      }

      if (!isLoggedIn && !isAuthPage) {
        return '/login';
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
      ),
      GoRoute(
        path: '/stories/:id',
        name: 'story_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return StoryDetailScreen(storyId: id);
        },
      ),
      GoRoute(
        path: '/add-story',
        name: 'add_story',
        builder: (context, state) => const AddStoryScreen(),
      ),
    ],
  );
}
