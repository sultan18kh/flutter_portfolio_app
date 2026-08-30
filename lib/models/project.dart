import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// What kind of product a project is, driving which badge icon and which
/// family of action buttons (store links vs. site link) its card shows.
enum ProjectPlatform { ios, android, web, aiAgent }

@JsonSerializable()
class Project extends Equatable {
  final String name;
  final String description;
  final List<String> technologies;
  final List<String> features;
  final List<ProjectPlatform> platforms;
  final String? imageUrl;
  final String? appStoreUrl;
  final String? playStoreUrl;
  final String? siteUrl;

  const Project({
    required this.name,
    required this.description,
    required this.technologies,
    required this.features,
    this.platforms = const [],
    this.imageUrl,
    this.appStoreUrl,
    this.playStoreUrl,
    this.siteUrl,
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
        platforms,
        imageUrl,
        appStoreUrl,
        playStoreUrl,
        siteUrl,
      ];
}
