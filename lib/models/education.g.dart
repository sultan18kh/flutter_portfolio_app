// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'education.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Education _$EducationFromJson(Map<String, dynamic> json) => Education(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      field: json['field'] as String,
      period: json['period'] as String,
      score: json['score'] as String,
    );

Map<String, dynamic> _$EducationToJson(Education instance) => <String, dynamic>{
      'institution': instance.institution,
      'degree': instance.degree,
      'field': instance.field,
      'period': instance.period,
      'score': instance.score,
    };
