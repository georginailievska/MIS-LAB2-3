import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:lab3_meals/theme.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/meal.dart';
import 'models/favorites_provider.dart';

import 'screens/home_screen.dart';
import 'screens/meals_screen.dart';
import 'screens/random_recipe_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/favorites_screen.dart';

import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <GoRoute>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    GoRoute(
      path: '/meals/:categoryName',
      name: 'meals',
      builder: (context, state) {
        final categoryName = state.pathParameters['categoryName']!;
        return MealsScreen(categoryName: categoryName);
      },
    ),

    GoRoute(
      path: '/random',
      name: 'random',
      builder: (context, state) => const RandomRecipeScreen(),
    ),

    GoRoute(
      path: '/detail',
      name: 'detail',
      builder: (context, state) {
        final meal = state.extra as Meal;
        return RecipeDetailScreen(mealId: meal.id);
      },
    ),

    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesScreen(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MIS Recipes',
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
    );
  }
}