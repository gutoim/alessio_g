// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'login_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent()';
}


}

/// @nodoc
class $LoginEventCopyWith<$Res>  {
$LoginEventCopyWith(LoginEvent _, $Res Function(LoginEvent) __);
}


/// Adds pattern-matching-related methods to [LoginEvent].
extension LoginEventPatterns on LoginEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoginUsernameChanged value)?  usernameChanged,TResult Function( LoginPasswordChanged value)?  passwordChanged,TResult Function( LoginSubmitted value)?  submitted,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoginUsernameChanged() when usernameChanged != null:
return usernameChanged(_that);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case LoginSubmitted() when submitted != null:
return submitted(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoginUsernameChanged value)  usernameChanged,required TResult Function( LoginPasswordChanged value)  passwordChanged,required TResult Function( LoginSubmitted value)  submitted,}){
final _that = this;
switch (_that) {
case LoginUsernameChanged():
return usernameChanged(_that);case LoginPasswordChanged():
return passwordChanged(_that);case LoginSubmitted():
return submitted(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoginUsernameChanged value)?  usernameChanged,TResult? Function( LoginPasswordChanged value)?  passwordChanged,TResult? Function( LoginSubmitted value)?  submitted,}){
final _that = this;
switch (_that) {
case LoginUsernameChanged() when usernameChanged != null:
return usernameChanged(_that);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that);case LoginSubmitted() when submitted != null:
return submitted(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String username)?  usernameChanged,TResult Function( String password)?  passwordChanged,TResult Function()?  submitted,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoginUsernameChanged() when usernameChanged != null:
return usernameChanged(_that.username);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case LoginSubmitted() when submitted != null:
return submitted();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String username)  usernameChanged,required TResult Function( String password)  passwordChanged,required TResult Function()  submitted,}) {final _that = this;
switch (_that) {
case LoginUsernameChanged():
return usernameChanged(_that.username);case LoginPasswordChanged():
return passwordChanged(_that.password);case LoginSubmitted():
return submitted();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String username)?  usernameChanged,TResult? Function( String password)?  passwordChanged,TResult? Function()?  submitted,}) {final _that = this;
switch (_that) {
case LoginUsernameChanged() when usernameChanged != null:
return usernameChanged(_that.username);case LoginPasswordChanged() when passwordChanged != null:
return passwordChanged(_that.password);case LoginSubmitted() when submitted != null:
return submitted();case _:
  return null;

}
}

}

/// @nodoc


class LoginUsernameChanged implements LoginEvent {
  const LoginUsernameChanged(this.username);
  

 final  String username;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginUsernameChangedCopyWith<LoginUsernameChanged> get copyWith => _$LoginUsernameChangedCopyWithImpl<LoginUsernameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginUsernameChanged&&(identical(other.username, username) || other.username == username));
}


@override
int get hashCode => Object.hash(runtimeType,username);

@override
String toString() {
  return 'LoginEvent.usernameChanged(username: $username)';
}


}

/// @nodoc
abstract mixin class $LoginUsernameChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $LoginUsernameChangedCopyWith(LoginUsernameChanged value, $Res Function(LoginUsernameChanged) _then) = _$LoginUsernameChangedCopyWithImpl;
@useResult
$Res call({
 String username
});




}
/// @nodoc
class _$LoginUsernameChangedCopyWithImpl<$Res>
    implements $LoginUsernameChangedCopyWith<$Res> {
  _$LoginUsernameChangedCopyWithImpl(this._self, this._then);

  final LoginUsernameChanged _self;
  final $Res Function(LoginUsernameChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? username = null,}) {
  return _then(LoginUsernameChanged(
null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoginPasswordChanged implements LoginEvent {
  const LoginPasswordChanged(this.password);
  

 final  String password;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginPasswordChangedCopyWith<LoginPasswordChanged> get copyWith => _$LoginPasswordChangedCopyWithImpl<LoginPasswordChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginPasswordChanged&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,password);

@override
String toString() {
  return 'LoginEvent.passwordChanged(password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginPasswordChangedCopyWith<$Res> implements $LoginEventCopyWith<$Res> {
  factory $LoginPasswordChangedCopyWith(LoginPasswordChanged value, $Res Function(LoginPasswordChanged) _then) = _$LoginPasswordChangedCopyWithImpl;
@useResult
$Res call({
 String password
});




}
/// @nodoc
class _$LoginPasswordChangedCopyWithImpl<$Res>
    implements $LoginPasswordChangedCopyWith<$Res> {
  _$LoginPasswordChangedCopyWithImpl(this._self, this._then);

  final LoginPasswordChanged _self;
  final $Res Function(LoginPasswordChanged) _then;

/// Create a copy of LoginEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? password = null,}) {
  return _then(LoginPasswordChanged(
null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoginSubmitted implements LoginEvent {
  const LoginSubmitted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginSubmitted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LoginEvent.submitted()';
}


}




// dart format on
