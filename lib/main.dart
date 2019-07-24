import 'package:expended/bloc/account_bloc.dart';
import 'package:expended/misc/colors.dart';
import 'package:expended/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => AccountBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Montserrat',
          scaffoldBackgroundColor: AppColors.whisper,
          accentColor: AppColors.seance,
          primaryColor: AppColors.seance,
          cursorColor: AppColors.seance,
          iconTheme: IconThemeData(color: AppColors.govBay),
        ),
        // darkTheme: ThemeData.dark(),
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}