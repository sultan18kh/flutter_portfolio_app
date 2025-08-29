// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalInfo _$PersonalInfoFromJson(Map<String, dynamic> json) => PersonalInfo(
      name: json['name'] as String,
      title: json['title'] as String,
      profile: json['profile'] as String,
      email: json['email'] as String,
      linkedin: json['linkedin'] as String,
      github: json['github'] as String,
      home: json['home'] as String,
      phoneNumbers: (json['phoneNumbers'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      profileImage: json['profileImage'] as String,
    );

Map<String, dynamic> _$PersonalInfoToJson(PersonalInfo instance) =>
    <String, dynamic>{
      'name': instance.name,
      'title': instance.title,
      'profile': instance.profile,
      'email': instance.email,
      'linkedin': instance.linkedin,
      'github': instance.github,
      'home': instance.home,
      'phoneNumbers': instance.phoneNumbers,
      'profileImage': instance.profileImage,
    };
