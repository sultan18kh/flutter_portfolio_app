import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/portfolio_bloc.dart';
import 'pages/landing_page.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PortfolioBloc>(
          create: (context) => PortfolioBloc()..add(LoadPortfolio()),
        ),
      ],
      child: MaterialApp(
        title: 'Sultan Khan - Portfolio',
        theme: AppTheme.darkTheme,
        home: const LandingPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
