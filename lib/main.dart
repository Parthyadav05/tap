import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../di/injection.dart';
import 'bloc/bloc_cubit.dart';


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
        child: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bonds List'),
      ),
      body: BlocBuilder<BondCubit, BondState>(
        builder: (context, state) {
          if (state is BondStateLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BondStateLoaded) {
            return ListView.builder(
              itemCount: state.bonds.length,
              itemBuilder: (context, index) {
                final bond = state.bonds[index];
                return ListTile(
                  leading: Image.network(bond.logo),
                  title: Text(bond.companyName),
                  subtitle: Text('Rating: ${bond.rating}'),
                );
              },
            );
          } else if (state is BondStateError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}