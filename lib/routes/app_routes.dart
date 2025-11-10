import 'package:flutter/material.dart';
import 'package:mindwallet/screens/transactions/nova_transacao_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/emotions/emotion_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/habits/habits_screen.dart';
import '../screens/progress/progress_screen.dart';

class AppRoutes {
  static const String novaTransacao = '/novaTransacao';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String emotion = '/emotion';
  static const String chat = '/chat';
  static const String habits = '/habits';
  static const String progress = '/progress';

  static Map<String, WidgetBuilder> routes = {
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    dashboard: (context) => const DashboardScreen(),
    emotion: (context) => const EmotionScreen(),
    chat: (context) => const ChatScreen(),
    habits: (context) => const HabitsScreen(),
    progress: (context) => const ProgressScreen(),
    novaTransacao: (context) => const NovaTransacaoScreen(),
  };
}
