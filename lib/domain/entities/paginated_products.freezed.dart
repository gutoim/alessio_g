// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_products.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaginatedProducts {

 List<Product> get items;/// How many products come before this page.
 int get skip;/// Size of the whole catalog.
 int get total;
/// Create a copy of PaginatedProducts
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedProductsCopyWith<PaginatedProducts> get copyWith => _$PaginatedProductsCopyWithImpl<PaginatedProducts>(this as PaginatedProducts, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedProducts&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),skip,total);

@override
String toString() {
  return 'PaginatedProducts(items: $items, skip: $skip, total: $total)';
}


}

/// @nodoc
abstract mixin class $PaginatedProductsCopyWith<$Res>  {
  factory $PaginatedProductsCopyWith(PaginatedProducts value, $Res Function(PaginatedProducts) _then) = _$PaginatedProductsCopyWithImpl;
@useResult
$Res call({
 List<Product> items, int skip, int total
});




}
/// @nodoc
class _$PaginatedProductsCopyWithImpl<$Res>
    implements $PaginatedProductsCopyWith<$Res> {
  _$PaginatedProductsCopyWithImpl(this._self, this._then);

  final PaginatedProducts _self;
  final $Res Function(PaginatedProducts) _then;

/// Create a copy of PaginatedProducts
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? skip = null,Object? total = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Product>,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedProducts].
extension PaginatedProductsPatterns on PaginatedProducts {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedProducts value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedProducts() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedProducts value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedProducts():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedProducts value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedProducts() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Product> items,  int skip,  int total)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedProducts() when $default != null:
return $default(_that.items,_that.skip,_that.total);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Product> items,  int skip,  int total)  $default,) {final _that = this;
switch (_that) {
case _PaginatedProducts():
return $default(_that.items,_that.skip,_that.total);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Product> items,  int skip,  int total)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedProducts() when $default != null:
return $default(_that.items,_that.skip,_that.total);case _:
  return null;

}
}

}

/// @nodoc


class _PaginatedProducts extends PaginatedProducts {
  const _PaginatedProducts({required final  List<Product> items, required this.skip, required this.total}): _items = items,super._();
  

 final  List<Product> _items;
@override List<Product> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// How many products come before this page.
@override final  int skip;
/// Size of the whole catalog.
@override final  int total;

/// Create a copy of PaginatedProducts
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedProductsCopyWith<_PaginatedProducts> get copyWith => __$PaginatedProductsCopyWithImpl<_PaginatedProducts>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedProducts&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.skip, skip) || other.skip == skip)&&(identical(other.total, total) || other.total == total));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),skip,total);

@override
String toString() {
  return 'PaginatedProducts(items: $items, skip: $skip, total: $total)';
}


}

/// @nodoc
abstract mixin class _$PaginatedProductsCopyWith<$Res> implements $PaginatedProductsCopyWith<$Res> {
  factory _$PaginatedProductsCopyWith(_PaginatedProducts value, $Res Function(_PaginatedProducts) _then) = __$PaginatedProductsCopyWithImpl;
@override @useResult
$Res call({
 List<Product> items, int skip, int total
});




}
/// @nodoc
class __$PaginatedProductsCopyWithImpl<$Res>
    implements _$PaginatedProductsCopyWith<$Res> {
  __$PaginatedProductsCopyWithImpl(this._self, this._then);

  final _PaginatedProducts _self;
  final $Res Function(_PaginatedProducts) _then;

/// Create a copy of PaginatedProducts
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? skip = null,Object? total = null,}) {
  return _then(_PaginatedProducts(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Product>,skip: null == skip ? _self.skip : skip // ignore: cast_nullable_to_non_nullable
as int,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
