import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill extends Equatable {
  final String name;
  final int proficiency; // 1-5 scale

  const Skill({
    required this.name,
    required this.proficiency,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);

  Map<String, dynamic> toJson() => _$SkillToJson(this);

  @override
  List<Object?> get props => [name, proficiency];
}
