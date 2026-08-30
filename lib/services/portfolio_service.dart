import '../models/personal_info.dart';
import '../models/education.dart';
import '../models/experience.dart';
import '../models/skill.dart';
import '../models/project.dart';
import '../models/certification.dart';

class PortfolioService {
  static Future<PersonalInfo> getPersonalInfo() async {
    // Mock data based on resume
    return const PersonalInfo(
      name: 'SULTAN KHAN',
      title: 'Senior AI Solutions Developer',
      profile:
          'Senior AI Solutions Developer specializing in Flutter, Azure AI, and agentic AI systems. Six-time Microsoft certified, currently extending depth in Azure AI Foundry, Model Context Protocol (MCP) tooling, and Claude Code agent workflows. Production track record across BLE/IoT mobile (SOBRsure, \$10M seed), AI-powered enterprise SaaS, and healthcare-compliance automation.',
      aboutBio:
          'I\'m a Senior AI Solutions Developer building production Flutter and Azure AI systems for clients ranging from a \$10M-seed IoT safety platform to enterprise HR and CRM tooling. My recent focus has shifted deeper into agentic AI — Azure AI Foundry, the Model Context Protocol, and Claude Code workflows — while staying hands-on with Flutter across mobile and web. Six-time Microsoft certified, I write about agentic AI and Spec-Driven Development on LinkedIn and contribute to open source in my spare time.',
      email: 'sultan512@gmail.com',
      linkedin: 'linkedin.com/in/sultan-khan-278014121',
      github: 'https://github.com/sultan18kh',
      home: 'AlphaBOLD, Carlsbad, CA',
      phoneNumbers: [
        '+92 323 8788300',
      ],
      profileImage: 'assets/sultan_angle.jpg',
    );
  }

  static Future<List<Education>> getEducation() async {
    return const [
      Education(
        institution: 'University of Management and Technology',
        degree: 'Bachelor of Science in Computer Science',
        field: 'Computer Science',
        period: '2014-2018',
        score: '3.25 CGPA',
      ),
      Education(
        institution: 'Garrison Academy for Cambridge Studies',
        degree: 'A Levels',
        field: 'Sciences',
        period: '2012-2014',
        score: '75.90%',
      ),
      Education(
        institution: 'DHA Senior School for Boys',
        degree: 'O Levels',
        field: 'Computer Studies',
        period: '2009-2012',
        score: '82.55%',
      ),
    ];
  }

  static Future<List<Experience>> getExperience() async {
    return const [
      Experience(
        title: 'Senior AI Solutions Developer',
        company: 'AlphaBOLD',
        period: 'June 2021 - Present',
        responsibilities: [
          'Lead Flutter, Python, and Azure AI engineering for the Microsoft Dynamics CRM ecosystem',
          'Built AI resume parser and AI score generator orchestrating Llama 3.2 and Claude AI via LangChain',
          'Engineered NCCN healthcare-compliance automation: LLM preprocessing, deterministic rule lookup, webhook-gated enforcement',
          'Delivered BLE-enabled IoT mobile platform for the \$10M-seed-funded SOBRsure',
        ],
      ),
      Experience(
        title: 'Senior Software Engineer',
        company: 'We > I',
        period: 'January 2020 - June 2021',
        responsibilities: [
          'Mobile tech lead, founding dev team of three at BridgeLinx (\$10M seed round)',
          'Built client and driver Flutter apps with Mapbox and Google Maps navigation',
          'Engineered Android foreground/background services for live location tracking',
        ],
      ),
      Experience(
        title: 'Software Engineer',
        company: 'Confiz Limited',
        period: 'February 2019 - January 2020',
        responsibilities: [
          'Microsoft Dynamics R&D team for D365FO and Dynamics AX R3 2012',
          'Authored FBR Connect, a C# .NET integration with the FBR POS API',
        ],
      ),
      Experience(
        title: 'Software Engineer',
        company: 'Finz Technologies',
        period: 'June 2018 - January 2019',
        responsibilities: [
          'Unity 3D developer specializing in 2.5D and 3D fighting games (UFE)',
        ],
      ),
      Experience(
        title: 'IT Intern',
        company: 'Fauji Fertilizer Company',
        period: '2017',
        responsibilities: [
          'Early-career internship in IT',
        ],
      ),
      Experience(
        title: 'Android Development Intern',
        company: 'Netsol Technologies',
        period: '2016',
        responsibilities: [
          'Early-career internship in Android development',
        ],
      ),
    ];
  }

  static Future<List<Skill>> getSkills() async {
    return const [
      Skill(name: 'Flutter', proficiency: 5),
      Skill(name: 'React.js', proficiency: 4),
      Skill(name: 'Azure AI', proficiency: 4),
      Skill(name: 'Microsoft Azure', proficiency: 4),
      Skill(name: 'Python', proficiency: 3),
      Skill(name: 'Node.js/Express', proficiency: 4),
      Skill(name: 'TypeScript', proficiency: 4),
      Skill(name: 'SQL', proficiency: 4),
      Skill(name: 'Google Cloud Platform', proficiency: 4),
      Skill(name: 'Dart', proficiency: 5),
      Skill(name: 'JavaScript', proficiency: 4),
      Skill(name: 'HTML/CSS', proficiency: 4),
      Skill(name: 'Git', proficiency: 4),
      Skill(name: 'Docker', proficiency: 3),
      Skill(name: 'MongoDB', proficiency: 4),
    ];
  }

  static Future<List<Project>> getProjects() async {
    return const [
      Project(
        name: 'Healthcare Trademark Compliance Automation Agent',
        description:
            'AI agent that checks submitted research papers for a confidential healthcare client against trademark-usage rules that vary by submission type',
        technologies: [
          'Python',
          'Azure Functions',
          'Azure DevOps',
          'OpenAI API'
        ],
        features: [
          'PDF text and annotation extraction feeds an LLM preprocessing pass that classifies each submission type (abstract, poster, manuscript, etc.)',
          'Deterministic rule-lookup engine matches the classified type against 30+ verbatim trademark-usage entries, so enforcement stays consistent and auditable rather than left to LLM judgment alone',
          'Webhook-gated enforcement blocks non-compliant submissions before publication, with zero runtime LLM cost on the rule-check path',
        ],
        platforms: [ProjectPlatform.aiAgent],
        imageUrl: 'assets/projects/nccn-01.webp',
      ),
      Project(
        name: 'SOBRSafe - SOBRsure',
        description: 'Safety and compliance monitoring application',
        technologies: ['Flutter', 'Bloc/Cubit', 'Google Maps API', 'Mapbox'],
        features: [
          'User profiles and device connection',
          'Map integration with Google Maps API',
          'Real-time safety monitoring',
        ],
        platforms: [ProjectPlatform.ios, ProjectPlatform.android],
        imageUrl: 'assets/projects/sobrsafe-01.webp',
        siteUrl: 'https://sobrsafe.com/pages/sobrsure',
      ),
      Project(
        name: 'BOLDHR',
        description: 'Flutter Web App (iOS/Android WIP) - HR Management System',
        technologies: [
          'Flutter',
          'Node.js',
          'Express',
          'OpenAI API',
          'LangChain'
        ],
        features: [
          'AI-Powered Resume Parser leveraging OpenAI APIs',
          'AI Score Generator integrating Llama 3.2 and Claude AI models',
          'Implemented Beamer for nested routing',
          'BE powered by Node.js Express APIs',
        ],
        platforms: [ProjectPlatform.web],
        imageUrl: 'assets/projects/boldhr-01.webp',
      ),
      Project(
        name: 'BOLDVelocity',
        description: 'AlphaBOLD internal developer productivity dashboard',
        technologies: ['Python', 'SQLite', 'Vue.js', 'Azure DevOps API'],
        features: [
          'ETL pipeline normalizing Git, PR, Boards, and Copilot activity into commit, cycle-time, churn, and velocity metrics',
          'Read-only stdlib Python API serving pre-aggregated SQLite metrics to a Vue 3 dashboard',
          'Idempotent natural-key upserts, safe for a 3x/day cron pipeline; zero LLM calls by design',
        ],
        platforms: [ProjectPlatform.web],
        imageUrl: 'assets/projects/boldvelocity-01.webp',
      ),
      Project(
        name: 'BOLDAgimble',
        description: 'Time tracking and productivity management application',
        technologies: ['Flutter', 'Bloc/Cubit', 'Google Cloud Services'],
        features: [
          'Bar charts for data visualization',
          'Time entry forms and calendar views',
          'Real-time tracking and analytics',
        ],
        platforms: [ProjectPlatform.ios, ProjectPlatform.android],
        imageUrl: 'assets/projects/boldagimble-01.webp',
        appStoreUrl: 'https://apps.apple.com/us/app/boldagimble/id1590827447',
        playStoreUrl:
            'https://play.google.com/store/apps/details?id=com.alphabold.boldagimble&hl=en',
      ),
      Project(
        name: 'BOLDRewards',
        description: 'Employee rewards and recognition platform',
        technologies: ['Flutter', 'Bloc/Cubit', 'Google Cloud Services'],
        features: [
          'Reward points system',
          'Redemption options and transaction history',
          'Gamified employee engagement',
        ],
        platforms: [ProjectPlatform.ios, ProjectPlatform.android],
        imageUrl: 'assets/projects/boldrewards-01.webp',
        appStoreUrl: 'https://apps.apple.com/us/app/boldreward/id1529437438',
      ),
    ];
  }

  static Future<List<Certification>> getCertifications() async {
    return const [
      Certification(
        name: 'AI-900: Microsoft Azure AI Fundamentals',
        description:
            'Foundational knowledge of AI concepts and the capabilities of Microsoft Azure AI services.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'AI-901: Microsoft Azure AI Fundamentals (Refresh)',
        description:
            'Refreshed certification covering current Azure AI fundamentals and services.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'AZ-900: Microsoft Azure Fundamentals',
        description:
            'Foundational knowledge of cloud services and how they are provided with Microsoft Azure.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'DP-900: Microsoft Azure Data Fundamentals',
        description:
            'Core data concepts and how they are implemented using Microsoft Azure data services.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'APL-7008: Build Agents with Microsoft Copilot Studio',
        description:
            'Applied Skills credential for building and deploying agents with Microsoft Copilot Studio.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'AI-103: Azure AI Engineer Associate',
        description:
            'Associate-level certification for designing and implementing AI solutions on Microsoft Azure.',
        issuer: 'Microsoft',
      ),
    ];
  }
}
