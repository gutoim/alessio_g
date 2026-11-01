import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_event.freezed.dart';

@freezed
sealed class SessionEvent with _$SessionEvent {
  /// Starts following the auth status. Sent once at app start.
  const factory SessionEvent.started() = SessionStarted;

  const factory SessionEvent.logoutRequested() = SessionLogoutRequested;
}
