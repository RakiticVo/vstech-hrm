import 'dart:async';
import 'package:flutter/material.dart';

/// Helper to bridge Stream to ChangeNotifier for GoRouter refresh.
class GoRouterRefreshStream extends ChangeNotifier {
  new(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
