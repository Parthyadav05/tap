import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tap/screens/home_main_view.dart';
import '../di/injection.dart';
import 'bloc/bloc_cubit.dart';
import 'bloc/bond_state.dart';


void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tap Invest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (_) => getIt<BondCubit>()..fetchBonds(),
        child: HomeScreen(),
      ),
    );
  }
}

