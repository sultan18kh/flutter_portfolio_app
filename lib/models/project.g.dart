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
      platforms: (json['platforms'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ProjectPlatformEnumMap, e))
              .toList() ??
          const [],
      imageUrl: json['imageUrl'] as String?,
      appStoreUrl: json['appStoreUrl'] as String?,
      playStoreUrl: json['playStoreUrl'] as String?,
      siteUrl: json['siteUrl'] as String?,
    );

Map<String, dynamic> _$ProjectToJson(Project instance) => <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'technologies': instance.technologies,
      'features': instance.features,
      'platforms':
          instance.platforms.map((e) => _$ProjectPlatformEnumMap[e]!).toList(),
      'imageUrl': instance.imageUrl,
      'appStoreUrl': instance.appStoreUrl,
      'playStoreUrl': instance.playStoreUrl,
      'siteUrl': instance.siteUrl,
    };

const _$ProjectPlatformEnumMap = {
  ProjectPlatform.ios: 'ios',
  ProjectPlatform.android: 'android',
  ProjectPlatform.web: 'web',
  ProjectPlatform.aiAgent: 'aiAgent',
};
