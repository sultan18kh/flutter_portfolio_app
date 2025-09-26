part of 'portfolio_cubit.dart';

abstract class PortfolioState extends Equatable {
  const PortfolioState();

  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioLoaded extends PortfolioState {
  final PersonalInfo personalInfo;
  final List<Education> education;
  final List<Experience> experience;
  final List<Skill> skills;
  final List<Project> projects;
  final List<Certification> certifications;

  const PortfolioLoaded({
    required this.personalInfo,
    required this.education,
    required this.experience,
    required this.skills,
    required this.projects,
    required this.certifications,
  });

  @override
  List<Object?> get props => [
        personalInfo,
        education,
        experience,
        skills,
        projects,
        certifications,
      ];
}

class PortfolioError extends PortfolioState {
  final String message;

  const PortfolioError(this.message);

  @override
  List<Object?> get props => [message];
}
