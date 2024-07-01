import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lesson66/models/question.dart';
import 'package:lesson66/services/qustion_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QustionService qustionService = QustionService();
  final PageController _pageController = PageController();
  int trueAnswers = 0;
  int _currentPage = 0;
  List<List<bool>> userAnswers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        centerTitle: true,
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
              userAnswers = List.generate(questions.length, (_) => [false, false, false, false]);

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: questions.length,
                        itemBuilder: (context, index) {
                          final question = Question.fromJson(questions[index]);
                          return Column(
                            children: [
                              VariantsWidgets(
                                question: question,
                                useranswer: (i, value) {
                                  setState(() {
                                    userAnswers[index] = [false, false, false, false];
                                    userAnswers[index][i] = value!;
                                  });
                                },
                                userAnswers: userAnswers[index],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (userAnswers[index].contains(true)) {
                                      if (userAnswers[index].indexOf(true) == question.answer) {
                                        trueAnswers++;
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text(
                                            "To'g'ri javob berdingiz",
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ));
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                          content: Text(
                                            "Xato javob berdingiz",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ));
                                      }
                                      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.bounceIn);
                                      setState(() {});
                                    }
                                  },
                                  child: const Text("Next"),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}

class VariantsWidgets extends StatefulWidget {
  final Question question;
  final List<bool> userAnswers;
  final Function(int, bool?) useranswer;

  VariantsWidgets({super.key, required this.question, required this.useranswer, required this.userAnswers});

  @override
  State<VariantsWidgets> createState() => _VariantsWidgetsState();
}

class _VariantsWidgetsState extends State<VariantsWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.question.question,
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
              CheckboxListTile(
                value: widget.userAnswers[i],
                onChanged: (value) {
                  widget.useranswer(i, value);
                },
                title: Text(widget.question.variants[i]),
              ),
              const Gap(10),
            ],
          ),
      ],
    );
  }
}
