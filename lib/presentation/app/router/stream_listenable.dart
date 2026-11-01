import 'dart:async';

import 'package:flutter/foundation.dart';

/// Notifies its listeners whenever [stream] emits.
///
/// Used as `GoRouter.refreshListenable` so the redirect runs again when the
/// session status changes.
class StreamListenable extends ChangeNotifier {
  StreamListenable(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
