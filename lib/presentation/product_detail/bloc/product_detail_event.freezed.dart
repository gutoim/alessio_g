// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_detail_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductDetailEvent {

 int get productId; Product? get preview;
/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailEventCopyWith<ProductDetailEvent> get copyWith => _$ProductDetailEventCopyWithImpl<ProductDetailEvent>(this as ProductDetailEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailEvent&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,productId,preview);

@override
String toString() {
  return 'ProductDetailEvent(productId: $productId, preview: $preview)';
}


}

/// @nodoc
abstract mixin class $ProductDetailEventCopyWith<$Res>  {
  factory $ProductDetailEventCopyWith(ProductDetailEvent value, $Res Function(ProductDetailEvent) _then) = _$ProductDetailEventCopyWithImpl;
@useResult
$Res call({
 int productId, Product? preview
});


$ProductCopyWith<$Res>? get preview;

}
/// @nodoc
class _$ProductDetailEventCopyWithImpl<$Res>
    implements $ProductDetailEventCopyWith<$Res> {
  _$ProductDetailEventCopyWithImpl(this._self, this._then);

  final ProductDetailEvent _self;
  final $Res Function(ProductDetailEvent) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? preview = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}
/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}


/// Adds pattern-matching-related methods to [ProductDetailEvent].
extension ProductDetailEventPatterns on ProductDetailEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductDetailLoadRequested value)?  loadRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductDetailLoadRequested() when loadRequested != null:
return loadRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductDetailLoadRequested value)  loadRequested,}){
final _that = this;
switch (_that) {
case ProductDetailLoadRequested():
return loadRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductDetailLoadRequested value)?  loadRequested,}){
final _that = this;
switch (_that) {
case ProductDetailLoadRequested() when loadRequested != null:
return loadRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( int productId,  Product? preview)?  loadRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductDetailLoadRequested() when loadRequested != null:
return loadRequested(_that.productId,_that.preview);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( int productId,  Product? preview)  loadRequested,}) {final _that = this;
switch (_that) {
case ProductDetailLoadRequested():
return loadRequested(_that.productId,_that.preview);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( int productId,  Product? preview)?  loadRequested,}) {final _that = this;
switch (_that) {
case ProductDetailLoadRequested() when loadRequested != null:
return loadRequested(_that.productId,_that.preview);case _:
  return null;

}
}

}

/// @nodoc


class ProductDetailLoadRequested implements ProductDetailEvent {
  const ProductDetailLoadRequested(this.productId, {this.preview});
  

@override final  int productId;
@override final  Product? preview;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductDetailLoadRequestedCopyWith<ProductDetailLoadRequested> get copyWith => _$ProductDetailLoadRequestedCopyWithImpl<ProductDetailLoadRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductDetailLoadRequested&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.preview, preview) || other.preview == preview));
}


@override
int get hashCode => Object.hash(runtimeType,productId,preview);

@override
String toString() {
  return 'ProductDetailEvent.loadRequested(productId: $productId, preview: $preview)';
}


}

/// @nodoc
abstract mixin class $ProductDetailLoadRequestedCopyWith<$Res> implements $ProductDetailEventCopyWith<$Res> {
  factory $ProductDetailLoadRequestedCopyWith(ProductDetailLoadRequested value, $Res Function(ProductDetailLoadRequested) _then) = _$ProductDetailLoadRequestedCopyWithImpl;
@override @useResult
$Res call({
 int productId, Product? preview
});


@override $ProductCopyWith<$Res>? get preview;

}
/// @nodoc
class _$ProductDetailLoadRequestedCopyWithImpl<$Res>
    implements $ProductDetailLoadRequestedCopyWith<$Res> {
  _$ProductDetailLoadRequestedCopyWithImpl(this._self, this._then);

  final ProductDetailLoadRequested _self;
  final $Res Function(ProductDetailLoadRequested) _then;

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? preview = freezed,}) {
  return _then(ProductDetailLoadRequested(
null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,preview: freezed == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as Product?,
  ));
}

/// Create a copy of ProductDetailEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProductCopyWith<$Res>? get preview {
    if (_self.preview == null) {
    return null;
  }

  return $ProductCopyWith<$Res>(_self.preview!, (value) {
    return _then(_self.copyWith(preview: value));
  });
}
}

// dart format on
