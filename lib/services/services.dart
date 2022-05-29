import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:feedy/services/my_plants.service.dart';

class Services extends InheritedWidget {
  final MyPlantsService myPlantsService;
  final GoTrueClient authService;

  Services._({
    required this.myPlantsService,
    required this.authService,
    required Widget child,
  }) : super(child: child);

  factory Services({required Widget child}) {
    final client = Supabase.instance.client;
    final myPlantsService = MyPlantsService(client);
    final authService = client.auth;
    return Services._(
      myPlantsService: myPlantsService,
      authService: authService,
      child: child,
    );
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static Services of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Services>()!;
  }
}
