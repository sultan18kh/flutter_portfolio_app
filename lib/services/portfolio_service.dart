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
      title: 'SOLUTION DEVELOPER II @ AlphaBOLD',
      profile:
          'A motivated, adaptable and responsible Computer Scientist, seeking a position in an IT domain which will utilize my professional and technical skills developed through rigorous endeavors and experiences in this field.',
      email: 'sultan512@gmail.com',
      linkedin: 'linkedin.com/in/sultan-khan-278014121',
      github: 'https://github.com/sultan18kh',
      home: 'Lahore Cantt',
      phoneNumbers: [
        '+92-323-8788300',
        '+92-355-4776815',
        '+92-346-4333929',
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
        title: 'Solution Developer II',
        company: 'AlphaBOLD',
        period: 'June 2021 - Present',
        responsibilities: [
          'Senior Full-stack Developer',
          'Flutter, MERN, Azure CosmosDB',
          'Azure Cloud, AI Services, Data Analytics (Microsoft Certified)',
        ],
      ),
      Experience(
        title: 'Senior Software Engineer',
        company: 'We > I',
        period: 'January 2020 - June 2021',
        responsibilities: [
          'Mobile Application Developer',
          'Flutter, Android Studio',
          'Google Cloud Services, AWS',
        ],
      ),
      Experience(
        title: 'Software Engineer',
        company: 'Confiz Limited',
        period: 'February 2019 - January 2020',
        responsibilities: [
          'Microsoft Dynamics R&D Team',
          'D365FO, Dynamics AX R3 2012',
          'Android studio applications, .NET Applications, SQL Server',
        ],
      ),
      Experience(
        title: 'Software Engineer',
        company: 'Finz Technologies',
        period: 'June 2018 - January 2019',
        responsibilities: [
          'Unity 3D Developer',
          'Specialized in 2.5D and 3D Fighting Games (UFE)',
        ],
      ),
      Experience(
        title: 'IT Intern',
        company: 'Fauji Fertilizer Company',
        period: 'August 2017 - September 2017',
        responsibilities: [
          'Mid-university internship',
          'Learned Basics of Marketing, SAP',
          'SQL Server 2012',
        ],
      ),
      Experience(
        title: 'Android Development Intern',
        company: 'Netsol Technologies',
        period: 'July 2016 - August 2016',
        responsibilities: [
          'Mid-university internship',
          'Android Studio, Java, XML',
          'Developed Netsol Phonebook Application',
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
      ),
      Project(
        name: 'BOLDBuild',
        description: 'Project management and task tracking application',
        technologies: ['Flutter', 'Bloc/Cubit', 'Google Cloud Services'],
        features: [
          'Task management interfaces',
          'Progress indicators and tracking',
          'Team collaboration tools',
        ],
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
      ),
    ];
  }

  static Future<List<Certification>> getCertifications() async {
    return const [
      Certification(
        name: 'AZ-900: Microsoft Azure Fundamentals',
        description:
            'Demonstrated foundational knowledge of cloud services and how they are provided with Microsoft Azure.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'AI-900: Microsoft Azure AI Fundamentals',
        description:
            'Proficient in understanding AI concepts and the capabilities of Microsoft Azure AI services.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'DP-900: Microsoft Azure Data Fundamentals',
        description:
            'Skilled in core data concepts and how they are implemented using Microsoft Azure data services.',
        issuer: 'Microsoft',
      ),
      Certification(
        name: 'English for Global Connectivity',
        description:
            'An ambitious language training program meant to build learners\' English language skills through modeling, practice, and personalizing, using modern teaching methodologies.',
        issuer: 'Muzammil Khan (CELTA/TEFL-CERT.UK)',
      ),
    ];
  }
}
