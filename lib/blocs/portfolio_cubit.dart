import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/personal_info.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/certification.dart';
import '../services/portfolio_service.dart';

part 'portfolio_state.dart';

class PortfolioCubit extends Cubit<PortfolioState> {
  PortfolioCubit() : super(PortfolioInitial());

  Future<void> loadPortfolio() async {
    if (isClosed) return;
    emit(PortfolioLoading());

    try {
      final personalInfo = await PortfolioService.getPersonalInfo();
      if (isClosed) return;

      final education = await PortfolioService.getEducation();
      if (isClosed) return;

      final experience = await PortfolioService.getExperience();
      if (isClosed) return;

      final skills = await PortfolioService.getSkills();
      if (isClosed) return;

      final projects = await PortfolioService.getProjects();
      if (isClosed) return;

      final certifications = await PortfolioService.getCertifications();
      if (isClosed) return;

      emit(PortfolioLoaded(
        personalInfo: personalInfo,
        education: education,
        experience: experience,
        skills: skills,
        projects: projects,
        certifications: certifications,
      ));
    } catch (e) {
      if (isClosed) return;
      emit(PortfolioError(e.toString()));
    }
  }
}
