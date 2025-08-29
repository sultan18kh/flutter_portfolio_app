import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

@JsonSerializable()
class Project extends Equatable {
  final String name;
  final String description;
  final List<String> technologies;
  final List<String> features;
  final String? imageUrl;
  final String? githubUrl;
  final String? liveUrl;

  const Project({
    required this.name,
    required this.description,
    required this.technologies,
    required this.features,
    this.imageUrl,
    this.githubUrl,
    this.liveUrl,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  Map<String, dynamic> toJson() => _$ProjectToJson(this);

  @override
  List<Object?> get props => [
        name,
        description,
        technologies,
        features,
        imageUrl,
        githubUrl,
        liveUrl,
      ];
}
