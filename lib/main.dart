import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallerycubit/bloc/image_edit_cubit.dart';
import 'package:gallerycubit/screen/home_screen.dart';

import 'bloc/gallery_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<GalleryCubit>(create: (context) => GalleryCubit()),
          BlocProvider<ImageEditCubit>(
            lazy: false,
            create: (context) => ImageEditCubit(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const HomeScreen(),
        ));
  }
}
