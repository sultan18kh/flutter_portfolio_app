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
        description: 'AI agent for healthcare trademark-compliance review',
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
        technologies: [
          'Flutter',
          'Bloc/Cubit',
          'BLE',
          'Google Maps API',
          'Mapbox'
        ],
        features: [
          'BLE communication protocol integration streaming live breath-alcohol readings from the SOBRsure hardware device',
          'Spike-detection and false-positive-filtering algorithms distinguishing genuine intoxication events from sensor noise and interference',
          'iOS and Android Live Activities surfacing real-time monitoring status on the lock screen without opening the app',
          'Background process handling keeping BLE data streaming and monitoring alive outside the foreground app lifecycle',
          'Multi-admin role management for family/organizational oversight of monitored users',
          'Map integration with Google Maps API for real-time location tracking',
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
          'LangChain',
          'Azure AAD'
        ],
        features: [
          'Automated resume parsing extracting structured candidate fields (skills, experience, education) from unstructured resume documents',
          'AI scoring engine that cross-analyzes a job description against a candidate\'s resume, integrating Llama 3.2 and Claude AI models',
          'Azure AAD OAuth single sign-on and CRM-embedded APIs integrating BOLDHR into AlphaBOLD\'s internal identity and CRM systems',
          'Implemented Beamer for nested routing',
          'BE powered by Node.js Express APIs',
        ],
        platforms: [ProjectPlatform.web],
        imageUrl: 'assets/projects/boldhr-01.webp',
      ),
      Project(
        name: 'BOLDVelocity',
        description: 'AlphaBOLD internal developer productivity dashboard',
        technologies: [
          'Python',
          'SQLite',
          'Vue.js',
          'Azure DevOps API',
          'LLM RAG'
        ],
        features: [
          'ETL pipeline fetching and compiling data from the Azure DevOps API, Microsoft Copilot analytics API, and Claude analytics API into commit, cycle-time, churn, and velocity metrics',
          'Chat agent answering ad-hoc user queries over the metrics store via an LLM wrapper backed by Text-to-SQL RAG',
          'Read-only stdlib Python API serving pre-aggregated SQLite metrics to a Vue 3 dashboard',
          'Azure AAD OAuth and CRM-embedded APIs integrating BOLDVelocity into AlphaBOLD\'s internal identity and CRM systems',
          'Idempotent natural-key upserts, safe for a 3x/day cron pipeline',
        ],
        platforms: [ProjectPlatform.web],
        imageUrl: 'assets/projects/boldvelocity-01.webp',
      ),
      Project(
        name: 'BOLDAgimble',
        description: 'Time tracking and productivity management application',
        technologies: [
          'Flutter',
          'Bloc/Cubit',
          'Google Cloud Services',
          'Azure AAD'
        ],
        features: [
          'Automated extraction of expense invoice elements (vendor, amount, date, line items) from uploaded receipts',
          'Automated time-entry generation, pre-filling entries from tracked activity instead of fully manual logging',
          'Azure AAD OAuth and CRM-embedded APIs integrating BOLDAgimble into AlphaBOLD\'s internal identity and CRM systems',
          'Bar charts for data visualization',
          'Time entry forms and calendar views',
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
        technologies: [
          'Flutter',
          'Bloc/Cubit',
          'Google Cloud Services',
          'Azure AAD'
        ],
        features: [
          'Real-time social feed with live peer-to-peer reward reactions',
          'Intuitive, animated redemption flow for reward points',
          'Azure AAD OAuth and CRM-embedded APIs integrating BOLDRewards into AlphaBOLD\'s internal identity and CRM systems',
          'Reward points system with redemption options and transaction history',
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
