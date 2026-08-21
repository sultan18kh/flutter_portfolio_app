import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/portfolio_cubit.dart';
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
        BlocProvider<PortfolioCubit>(
          create: (context) => PortfolioCubit(),
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
