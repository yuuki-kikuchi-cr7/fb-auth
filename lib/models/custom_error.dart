import 'package:freezed_annotation/freezed_annotation.dart';

part "custom_error.freezed.dart";

@freezed
class CustomError with _$CustomError {
  factory CustomError({
    @Default("") String code,
    @Default("") String message,
    @Default("") String plugin,
  }) = _CustomError;
}
