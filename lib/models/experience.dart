import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'experience.g.dart';

@JsonSerializable()
class Experience extends Equatable {
  final String title;
  final String company;
  final String period;
  final List<String> responsibilities;

  const Experience({
    required this.title,
    required this.company,
    required this.period,
    required this.responsibilities,
  });

  factory Experience.fromJson(Map<String, dynamic> json) =>
      _$ExperienceFromJson(json);

  Map<String, dynamic> toJson() => _$ExperienceToJson(this);

  @override
  List<Object?> get props => [
        title,
        company,
        period,
        responsibilities,
      ];
}
