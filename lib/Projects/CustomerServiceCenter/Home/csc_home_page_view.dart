import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'csc_home_page_bloc.dart';
import 'csc_home_page_event.dart';
import 'csc_home_page_state.dart';

class CscHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CscHomePageBloc()..add(InitEvent()),
      child: Builder(builder: (context) => _buildPage(context)),
    );
  }

  Widget _buildPage(BuildContext context) {
    final bloc = BlocProvider.of<CscHomePageBloc>(context);

    return Container();
  }
}

