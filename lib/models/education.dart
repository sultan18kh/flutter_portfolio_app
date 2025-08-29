import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'education.g.dart';

@JsonSerializable()
class Education extends Equatable {
  final String institution;
  final String degree;
  final String field;
  final String period;
  final String score;

  const Education({
    required this.institution,
    required this.degree,
    required this.field,
    required this.period,
    required this.score,
  });

  factory Education.fromJson(Map<String, dynamic> json) =>
      _$EducationFromJson(json);

  Map<String, dynamic> toJson() => _$EducationToJson(this);

  @override
  List<Object?> get props => [
        institution,
        degree,
        field,
        period,
        score,
      ];
}
