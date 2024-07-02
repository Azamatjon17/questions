import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lesson66/models/question.dart';
import 'package:lesson66/services/qustion_service.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QustionService qustionService = QustionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[300],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[300],
        title: const Text("Question"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Center(
        child: StreamBuilder(
            stream: qustionService.getQuestion(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data == null) {
                return const Center(
                  child: Text("Mahsulotlar mavjud emas"),
                );
              }

              final questions = snapshot.data!.docs;

              return QuestionsWidget(
                questions: questions,
              );
            }),
      ),
    );
  }
}

class QuestionsWidget extends StatefulWidget {
  List<QueryDocumentSnapshot<Object?>> questions;

  QuestionsWidget({super.key, required this.questions});

  @override
  State<QuestionsWidget> createState() => _QuestionsWidgetState();
}

class _QuestionsWidgetState extends State<QuestionsWidget> {
  final PageController _pageController = PageController();
  int trueAnswers = 0;
  List<String> userAnswers = ['A', 'B', 'C', 'D'];
  bool didAnswer = false;
  bool trueAnsevr = false;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padEnds: false,
              allowImplicitScrolling: true,
              scrollDirection: Axis.vertical,
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  didAnswer = false;
                  trueAnsevr = false;
                });
              },
              itemCount: widget.questions.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.questions.length) {
                  return Center(
                    child: Text(
                      trueAnswers.toString(),
                    ),
                  );
                } else {
                  final question = Question.fromJson(widget.questions[index]);
                  return Stack(
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            question.question,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 2,
                              letterSpacing: 2,
                            ),
                          ),
                          for (int i = 0; i < 4; i++)
                            Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    didAnswer = true;

                                    if (i == question.answer) {
                                      trueAnsevr = true;
                                      trueAnswers++;
                                    } else {
                                      trueAnsevr = false;
                                    }
                                    setState(() {});
                                    Future.delayed(
                                      const Duration(seconds: 1),
                                      () {
                                        setState(() {
                                          didAnswer = false;
                                          trueAnsevr = false;
                                        });
                                        _pageController.nextPage(
                                          duration: const Duration(milliseconds: 700),
                                          curve: Curves.linear,
                                        );
                                      },
                                    );
                                  },
                                  leading: Text(
                                    "${userAnswers[i]} :",
                                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                                  ),
                                  titleAlignment: ListTileTitleAlignment.center,
                                  title: Text(question.variants[i]),
                                ),
                                const Gap(10),
                              ],
                            ),
                        ],
                      ),
                      Visibility(
                        visible: didAnswer,
                        child: trueAnsevr ? Lottie.asset("assets/tick.json") : Lottie.asset("assets/error.json"),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
    ;
  }
}
