import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'certification.g.dart';

@JsonSerializable()
class Certification extends Equatable {
  final String name;
  final String description;
  final String? issuer;
  final String? date;

  const Certification({
    required this.name,
    required this.description,
    this.issuer,
    this.date,
  });

  factory Certification.fromJson(Map<String, dynamic> json) =>
      _$CertificationFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationToJson(this);

  @override
  List<Object?> get props => [name, description, issuer, date];
}
