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
  int _currentPage = 0;
  Map<int, bool> _answeredQuestions = {};

  void _onAnswerSelected(int pageIndex, bool isAnswered) {
    setState(() {
      _answeredQuestions[pageIndex] = isAnswered;
    });
  }

  void _nextPage() {
    if (_currentPage < _answeredQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentPage++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Product"),
        centerTitle: true,
      ),
      body: StreamBuilder(
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

            return Center(
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: questions.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        final question = Question.fromJson(questions[index]);
                        return VariantsWidgets(question: question);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _answeredQuestions[_currentPage] == true ? _nextPage : null,
                      child: const Text("Next"),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class VariantsWidgets extends StatefulWidget {
  Question question;
  VariantsWidgets({super.key, required this.question});

  @override
  State<VariantsWidgets> createState() => _VariantsWidgetsState();
}

class _VariantsWidgetsState extends State<VariantsWidgets> {
  List<bool> useranswer = [false, false, false, false];

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
                value: useranswer[i],
                onChanged: (value) {
                  setState(() {
                    useranswer[i] = value!;

                  });
                },
                title: Text(widget.question.variants[i]),
              ),
              const Gap(10),
            ],
          ),
      ],
    );
    ;
  }
}
