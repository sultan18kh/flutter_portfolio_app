// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Certification _$CertificationFromJson(Map<String, dynamic> json) =>
    Certification(
      name: json['name'] as String,
      description: json['description'] as String,
      issuer: json['issuer'] as String?,
      date: json['date'] as String?,
    );

Map<String, dynamic> _$CertificationToJson(Certification instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'issuer': instance.issuer,
      'date': instance.date,
    };
