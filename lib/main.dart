import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/feature/add_todo/cubit/post_todo_cubit.dart';
import 'package:todo_app/feature/todo_listing/UI/Pages/main_screen.dart';
import 'package:todo_app/feature/todo_listing/cubit/delete_todo_listing_cubit.dart';
import 'package:todo_app/feature/todo_listing/cubit/fetch_todo_listing_cubit.dart';
import 'package:todo_app/feature/todo_listing/resources/todo_repositary.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => TodoRepositary(),
      child: MultiBlocProvider(
        providers: [
         BlocProvider(
            create: (context) => CreateTodoListingCubit(
              repositary: context.read<TodoRepositary>()),
          ),
           BlocProvider(
            create: (context) => DeleteTodoListingCubit(
              repositary: context.read<TodoRepositary>()),
          ),
          BlocProvider(
            create: (context) => FetchTododListingCubit(
                repositary: RepositoryProvider.of<TodoRepositary>(context),
                createTodoListingCubit: context.read<CreateTodoListingCubit>(),
                deleteTodoListingCubit: context.read<DeleteTodoListingCubit>()
                ),
          ),
        
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              fontFamily: "Poppins",
              primarySwatch: Colors.blue,
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    )),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    )),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    )),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    )),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.red,
                    )),
                disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    )),
              )),
          home: const MainTodoScreen(),
        ),
      ),
    );
  }
}
