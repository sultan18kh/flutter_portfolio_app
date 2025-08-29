# Sultan Khan - Flutter Portfolio Application

A professional Flutter web portfolio application showcasing Sultan Khan's skills, experience, and projects. Built with modern Flutter architecture and best practices.

## 🚀 Features

- **Responsive Design**: Optimized for web, mobile, and tablet devices
- **Modern UI/UX**: Clean, professional design with smooth animations
- **State Management**: Built with Flutter Bloc for efficient state management
- **Routing**: Implemented with Go Router for seamless navigation
- **Data Models**: Well-structured data models with JSON serialization
- **Contact Form**: Interactive contact form with validation
- **Skills Visualization**: Visual representation of skill proficiency levels
- **Project Showcase**: Detailed project information with technologies used

## 📱 Pages

1. **Home**: Hero section with overview and quick stats
2. **About**: Personal information, contact details, and education
3. **Experience**: Work experience timeline with detailed responsibilities
4. **Projects**: Project showcase with technologies and features
5. **Skills**: Skills with proficiency levels and visual indicators
6. **Contact**: Contact information and contact form

## 🛠️ Technology Stack

- **Framework**: Flutter 3.5+
- **State Management**: Flutter Bloc
- **Routing**: Go Router
- **UI Components**: Material Design 3
- **Fonts**: Google Fonts (Inter)
- **Icons**: Material Icons, Font Awesome
- **Code Generation**: JSON Serializable, Build Runner

## 📦 Dependencies

### Core Dependencies
- `flutter_bloc`: ^8.1.4 - State management
- `equatable`: ^2.0.5 - Value equality
- `go_router`: ^13.2.0 - Routing
- `google_fonts`: ^6.1.0 - Typography
- `url_launcher`: ^6.2.4 - URL handling
- `font_awesome_flutter`: ^10.7.0 - Icons

### Development Dependencies
- `build_runner`: ^2.4.8 - Code generation
- `json_serializable`: ^6.7.1 - JSON serialization
- `flutter_lints`: ^4.0.0 - Code linting

## 🏗️ Architecture

### Project Structure
```
lib/
├── blocs/           # State management
├── models/          # Data models
├── pages/           # UI pages
├── services/        # Business logic
├── utils/           # Utilities and constants
├── widgets/         # Reusable widgets
└── main.dart        # App entry point
```

### State Management
- **PortfolioBloc**: Manages portfolio data loading and state
- **Events**: LoadPortfolio
- **States**: PortfolioInitial, PortfolioLoading, PortfolioLoaded, PortfolioError

### Data Models
- **PersonalInfo**: Personal information and contact details
- **Education**: Educational background
- **Experience**: Work experience
- **Skill**: Skills with proficiency levels
- **Project**: Project information
- **Certification**: Professional certifications

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.5.1 or higher
- Dart SDK 3.5.1 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd portfolio_flutter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   dart run build_runner build
   ```

4. **Run the application**
   ```bash
   flutter run -d chrome
   ```

## 🌐 Web Deployment

### Build for Web
```bash
flutter build web
```

### Deploy Options
- **Firebase Hosting**: Recommended for easy deployment
- **Netlify**: Great for static site hosting
- **Vercel**: Excellent for Flutter web apps
- **GitHub Pages**: Free hosting option

## 🎨 Customization

### Colors
The app uses a consistent color scheme defined in `lib/utils/app_theme.dart`:
- **Primary**: Dark blue (#1E3A8A)
- **Secondary**: Light blue (#3B82F6)
- **Background**: Light grey (#F8FAFC)
- **Surface**: White (#FFFFFF)

### Data
Update the portfolio data in `lib/services/portfolio_service.dart`:
- Personal information
- Education details
- Work experience
- Skills and proficiency levels
- Projects and features
- Certifications

### Styling
- Modify `lib/utils/app_theme.dart` for theme changes
- Update fonts in `pubspec.yaml`
- Customize widgets in `lib/widgets/`

## 📊 Performance

- **Lazy Loading**: Images and data loaded on demand
- **Optimized Builds**: Efficient code generation and compilation
- **Responsive Design**: Optimized for all screen sizes
- **Fast Navigation**: Smooth page transitions

## 🔧 Development

### Code Generation
```bash
# Watch for changes and regenerate
dart run build_runner watch

# Clean and regenerate
dart run build_runner clean
dart run build_runner build
```

### Testing
```bash
flutter test
```

### Linting
```bash
flutter analyze
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Sultan Khan**
- Senior Solution Developer
- Flutter & Full-Stack Developer
- Microsoft Azure Certified

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## 📞 Contact

- **Email**: sultan512@gmail.com
- **LinkedIn**: linkedin.com/in/sultan-khan-278014121
- **GitHub**: https://github.com/sultan18kh
- **Location**: Bedian Road, Lahore Cantt

---

Built with ❤️ using Flutter