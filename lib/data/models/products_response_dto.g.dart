// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'products_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductsResponseDto _$ProductsResponseDtoFromJson(Map<String, dynamic> json) =>
    ProductsResponseDto(
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      skip: (json['skip'] as num).toInt(),
    );
