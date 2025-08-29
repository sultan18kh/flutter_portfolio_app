import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/personal_info.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/certification.dart';
import '../services/portfolio_service.dart';

// Events
abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object?> get props => [];
}

class LoadPortfolio extends PortfolioEvent {}

// States
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

// Bloc
class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  PortfolioBloc() : super(PortfolioInitial()) {
    on<LoadPortfolio>(_onLoadPortfolio);
  }

  Future<void> _onLoadPortfolio(
    LoadPortfolio event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(PortfolioLoading());

    try {
      final personalInfo = await PortfolioService.getPersonalInfo();
      final education = await PortfolioService.getEducation();
      final experience = await PortfolioService.getExperience();
      final skills = await PortfolioService.getSkills();
      final projects = await PortfolioService.getProjects();
      final certifications = await PortfolioService.getCertifications();

      emit(PortfolioLoaded(
        personalInfo: personalInfo,
        education: education,
        experience: experience,
        skills: skills,
        projects: projects,
        certifications: certifications,
      ));
    } catch (e) {
      emit(PortfolioError(e.toString()));
    }
  }
}
