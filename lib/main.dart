import 'package:flutter/material.dart';
import 'package:quiver/async.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_brain.dart';

GeneralQuizBrain quizBrain = new GeneralQuizBrain();

void main() => runApp(Quizzler());

class Quizzler extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: QuizPage(),
          ),
        ),
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Widget> scoreKeeper = [];
  int total = 0;
  int score = 0;

  void checkAnswer(bool picked) {
    if (picked == quizBrain.getAnswer()) {
      correct();
      score++;
      total++;
    } else {
      wrong();
      total++;
    }
  }

  void correct() {
    scoreKeeper.add(
      Icon(
        Icons.check,
        color: Colors.green,
      ),
    );
  }

  void wrong() {
    scoreKeeper.add(
      Icon(
        Icons.close,
        color: Colors.red,
      ),
    );
  }

  void alert() {
    Alert(
      context: context,
      title: 'Congratulations!',
      desc: 'Your score is $score/$total.',
      buttons: [
        DialogButton(
          color: Colors.grey,
          child: Text(
            'Restart',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  int timerStart = 5;
  int timerCurrent = 5;

  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: timerStart),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        timerCurrent = timerStart - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      alert();
      sub.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 15,
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                quizBrain.getQuestion(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.green,
              child: Text(
                'True',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
              onPressed: () {
                setState(() {
                  checkAnswer(true);
                  if (!quizBrain.nextQuestion()) {
                    alert();
                    scoreKeeper = [];
                    total = 0;
                    score = 0;
                  }
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: FlatButton(
              color: Colors.red,
              child: Text(
                'False',
                style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                setState(() {
                  checkAnswer(false);
                  if (!quizBrain.nextQuestion()) {
                    alert();
                    scoreKeeper = [];
                    total = 0;
                    score = 0;
                  }
                });
              },
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: scoreKeeper,
          ),
        ),
      ],
    );
  }
}
