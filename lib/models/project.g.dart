// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Project _$ProjectFromJson(Map<String, dynamic> json) => Project(
      name: json['name'] as String,
      description: json['description'] as String,
      technologies: (json['technologies'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      imageUrl: json['imageUrl'] as String?,
      githubUrl: json['githubUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'technologies': instance.technologies,
      'features': instance.features,
      'imageUrl': instance.imageUrl,
      'githubUrl': instance.githubUrl,
      'liveUrl': instance.liveUrl,
    };
