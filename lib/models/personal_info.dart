import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'personal_info.g.dart';

@JsonSerializable()
class PersonalInfo extends Equatable {
  final String name;
  final String title;
  final String profile;
  final String email;
  final String linkedin;
  final String github;
  final String home;
  final List<String> phoneNumbers;
  final String profileImage;

  const PersonalInfo({
    required this.name,
    required this.title,
    required this.profile,
    required this.email,
    required this.linkedin,
    required this.github,
    required this.home,
    required this.phoneNumbers,
    required this.profileImage,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) =>
      _$PersonalInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PersonalInfoToJson(this);

  @override
  List<Object?> get props => [
        name,
        title,
        profile,
        email,
        linkedin,
        github,
        home,
        phoneNumbers,
        profileImage,
      ];
}
