import 'package:flutter/material.dart';

class HomeBody extends StatelessWidget {
  final int counter;
  const HomeBody({super.key, required this.counter});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      );
}
