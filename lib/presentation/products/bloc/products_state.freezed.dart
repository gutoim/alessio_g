// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsState()';
}


}

/// @nodoc
class $ProductsStateCopyWith<$Res>  {
$ProductsStateCopyWith(ProductsState _, $Res Function(ProductsState) __);
}


/// Adds pattern-matching-related methods to [ProductsState].
extension ProductsStatePatterns on ProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductsLoading value)?  loading,TResult Function( ProductsFailure value)?  failure,TResult Function( ProductsLoaded value)?  loaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading(_that);case ProductsFailure() when failure != null:
return failure(_that);case ProductsLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductsLoading value)  loading,required TResult Function( ProductsFailure value)  failure,required TResult Function( ProductsLoaded value)  loaded,}){
final _that = this;
switch (_that) {
case ProductsLoading():
return loading(_that);case ProductsFailure():
return failure(_that);case ProductsLoaded():
return loaded(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductsLoading value)?  loading,TResult? Function( ProductsFailure value)?  failure,TResult? Function( ProductsLoaded value)?  loaded,}){
final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading(_that);case ProductsFailure() when failure != null:
return failure(_that);case ProductsLoaded() when loaded != null:
return loaded(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Failure failure)?  failure,TResult Function( List<Product> products,  bool hasMore,  bool isRefreshing,  Failure? refreshFailure,  bool isLoadingMore,  Failure? loadMoreFailure)?  loaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading();case ProductsFailure() when failure != null:
return failure(_that.failure);case ProductsLoaded() when loaded != null:
return loaded(_that.products,_that.hasMore,_that.isRefreshing,_that.refreshFailure,_that.isLoadingMore,_that.loadMoreFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Failure failure)  failure,required TResult Function( List<Product> products,  bool hasMore,  bool isRefreshing,  Failure? refreshFailure,  bool isLoadingMore,  Failure? loadMoreFailure)  loaded,}) {final _that = this;
switch (_that) {
case ProductsLoading():
return loading();case ProductsFailure():
return failure(_that.failure);case ProductsLoaded():
return loaded(_that.products,_that.hasMore,_that.isRefreshing,_that.refreshFailure,_that.isLoadingMore,_that.loadMoreFailure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Failure failure)?  failure,TResult? Function( List<Product> products,  bool hasMore,  bool isRefreshing,  Failure? refreshFailure,  bool isLoadingMore,  Failure? loadMoreFailure)?  loaded,}) {final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading();case ProductsFailure() when failure != null:
return failure(_that.failure);case ProductsLoaded() when loaded != null:
return loaded(_that.products,_that.hasMore,_that.isRefreshing,_that.refreshFailure,_that.isLoadingMore,_that.loadMoreFailure);case _:
  return null;

}
}

}

/// @nodoc


class ProductsLoading implements ProductsState {
  const ProductsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsState.loading()';
}


}




/// @nodoc


class ProductsFailure implements ProductsState {
  const ProductsFailure(this.failure);
  

 final  Failure failure;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsFailureCopyWith<ProductsFailure> get copyWith => _$ProductsFailureCopyWithImpl<ProductsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsFailure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'ProductsState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ProductsFailureCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory $ProductsFailureCopyWith(ProductsFailure value, $Res Function(ProductsFailure) _then) = _$ProductsFailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});


$FailureCopyWith<$Res> get failure;

}
/// @nodoc
class _$ProductsFailureCopyWithImpl<$Res>
    implements $ProductsFailureCopyWith<$Res> {
  _$ProductsFailureCopyWithImpl(this._self, this._then);

  final ProductsFailure _self;
  final $Res Function(ProductsFailure) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(ProductsFailure(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res> get failure {
  
  return $FailureCopyWith<$Res>(_self.failure, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

/// @nodoc


class ProductsLoaded implements ProductsState {
  const ProductsLoaded({required final  List<Product> products, required this.hasMore, this.isRefreshing = false, this.refreshFailure, this.isLoadingMore = false, this.loadMoreFailure}): _products = products;
  

 final  List<Product> _products;
 List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  bool hasMore;
/// A pull-to-refresh is running. The current list stays visible.
@JsonKey() final  bool isRefreshing;
/// The last pull-to-refresh failed. The list is kept and the error is
/// shown once, as a snackbar.
 final  Failure? refreshFailure;
/// The next page is loading. Shown as a spinner at the end of the list.
@JsonKey() final  bool isLoadingMore;
/// Loading the next page failed. Shown at the end of the list with a
/// retry; scrolling does not retry on its own.
 final  Failure? loadMoreFailure;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsLoadedCopyWith<ProductsLoaded> get copyWith => _$ProductsLoadedCopyWithImpl<ProductsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsLoaded&&const DeepCollectionEquality().equals(other._products, _products)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.isRefreshing, isRefreshing) || other.isRefreshing == isRefreshing)&&(identical(other.refreshFailure, refreshFailure) || other.refreshFailure == refreshFailure)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.loadMoreFailure, loadMoreFailure) || other.loadMoreFailure == loadMoreFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),hasMore,isRefreshing,refreshFailure,isLoadingMore,loadMoreFailure);

@override
String toString() {
  return 'ProductsState.loaded(products: $products, hasMore: $hasMore, isRefreshing: $isRefreshing, refreshFailure: $refreshFailure, isLoadingMore: $isLoadingMore, loadMoreFailure: $loadMoreFailure)';
}


}

/// @nodoc
abstract mixin class $ProductsLoadedCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory $ProductsLoadedCopyWith(ProductsLoaded value, $Res Function(ProductsLoaded) _then) = _$ProductsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Product> products, bool hasMore, bool isRefreshing, Failure? refreshFailure, bool isLoadingMore, Failure? loadMoreFailure
});


$FailureCopyWith<$Res>? get refreshFailure;$FailureCopyWith<$Res>? get loadMoreFailure;

}
/// @nodoc
class _$ProductsLoadedCopyWithImpl<$Res>
    implements $ProductsLoadedCopyWith<$Res> {
  _$ProductsLoadedCopyWithImpl(this._self, this._then);

  final ProductsLoaded _self;
  final $Res Function(ProductsLoaded) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,Object? hasMore = null,Object? isRefreshing = null,Object? refreshFailure = freezed,Object? isLoadingMore = null,Object? loadMoreFailure = freezed,}) {
  return _then(ProductsLoaded(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,isRefreshing: null == isRefreshing ? _self.isRefreshing : isRefreshing // ignore: cast_nullable_to_non_nullable
as bool,refreshFailure: freezed == refreshFailure ? _self.refreshFailure : refreshFailure // ignore: cast_nullable_to_non_nullable
as Failure?,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,loadMoreFailure: freezed == loadMoreFailure ? _self.loadMoreFailure : loadMoreFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get refreshFailure {
    if (_self.refreshFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.refreshFailure!, (value) {
    return _then(_self.copyWith(refreshFailure: value));
  });
}/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadMoreFailure {
    if (_self.loadMoreFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadMoreFailure!, (value) {
    return _then(_self.copyWith(loadMoreFailure: value));
  });
}
}

// dart format on
