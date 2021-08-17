import 'package:flutter/material.dart';
import '../main.dart';
import 'game.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(Padding(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Sudoku", style: Theme.of(context).textTheme.headline4),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Game()),
                    );
                  },
                  icon: Icon(Icons.play_arrow),
                  label: Expanded(child: Text("New Game")),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
