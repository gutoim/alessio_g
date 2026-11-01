/// Whether a user session exists. Drives the route guard.
enum AuthStatus {
  /// Not determined yet: stored credentials are still being read at startup.
  unknown,

  /// Tokens are stored. API calls are made on the user's behalf.
  authenticated,

  /// No session. The user has to log in.
  unauthenticated,
}
