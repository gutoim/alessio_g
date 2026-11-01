import 'package:dummy_shop/domain/entities/auth_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_state.freezed.dart';

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({@Default(AuthStatus.unknown) AuthStatus status}) =
      _SessionState;
}
