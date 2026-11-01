// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsEvent()';
}


}

/// @nodoc
class $ProductsEventCopyWith<$Res>  {
$ProductsEventCopyWith(ProductsEvent _, $Res Function(ProductsEvent) __);
}


/// Adds pattern-matching-related methods to [ProductsEvent].
extension ProductsEventPatterns on ProductsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductsLoadRequested value)?  loadRequested,TResult Function( ProductsRefreshRequested value)?  refreshRequested,TResult Function( ProductsNextPageRequested value)?  nextPageRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductsLoadRequested() when loadRequested != null:
return loadRequested(_that);case ProductsRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case ProductsNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductsLoadRequested value)  loadRequested,required TResult Function( ProductsRefreshRequested value)  refreshRequested,required TResult Function( ProductsNextPageRequested value)  nextPageRequested,}){
final _that = this;
switch (_that) {
case ProductsLoadRequested():
return loadRequested(_that);case ProductsRefreshRequested():
return refreshRequested(_that);case ProductsNextPageRequested():
return nextPageRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductsLoadRequested value)?  loadRequested,TResult? Function( ProductsRefreshRequested value)?  refreshRequested,TResult? Function( ProductsNextPageRequested value)?  nextPageRequested,}){
final _that = this;
switch (_that) {
case ProductsLoadRequested() when loadRequested != null:
return loadRequested(_that);case ProductsRefreshRequested() when refreshRequested != null:
return refreshRequested(_that);case ProductsNextPageRequested() when nextPageRequested != null:
return nextPageRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function()?  refreshRequested,TResult Function()?  nextPageRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductsLoadRequested() when loadRequested != null:
return loadRequested();case ProductsRefreshRequested() when refreshRequested != null:
return refreshRequested();case ProductsNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function()  refreshRequested,required TResult Function()  nextPageRequested,}) {final _that = this;
switch (_that) {
case ProductsLoadRequested():
return loadRequested();case ProductsRefreshRequested():
return refreshRequested();case ProductsNextPageRequested():
return nextPageRequested();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function()?  refreshRequested,TResult? Function()?  nextPageRequested,}) {final _that = this;
switch (_that) {
case ProductsLoadRequested() when loadRequested != null:
return loadRequested();case ProductsRefreshRequested() when refreshRequested != null:
return refreshRequested();case ProductsNextPageRequested() when nextPageRequested != null:
return nextPageRequested();case _:
  return null;

}
}

}

/// @nodoc


class ProductsLoadRequested implements ProductsEvent {
  const ProductsLoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsLoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsEvent.loadRequested()';
}


}




/// @nodoc


class ProductsRefreshRequested implements ProductsEvent {
  const ProductsRefreshRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsRefreshRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsEvent.refreshRequested()';
}


}




/// @nodoc


class ProductsNextPageRequested implements ProductsEvent {
  const ProductsNextPageRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsNextPageRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsEvent.nextPageRequested()';
}


}




// dart format on
