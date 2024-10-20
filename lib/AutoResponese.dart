// import 'package:flutter_user_github/data/controller/Store_Controller.dart';
// import 'package:flutter_user_github/models/Model/Item/StoresItem.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class Autoresponese extends StatefulWidget {
//   const Autoresponese({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _AutoresponeseState createState() => _AutoresponeseState();
// }

// class _AutoresponeseState extends State<Autoresponese> {
//   int _currentQuestionIndex = 0;
//   bool _answered = false;
//   List<Storesitem>? respone;
//   Storecontroller? storecontroller;
//   List<Question> questions = [];
//   bool isLoading = true; // Track loading state

//   @override
//   void initState() {
//     super.initState();
//     storecontroller = Get.find<Storecontroller>();
//     _fetchData();
//   }

//   Future<void> _fetchData() async {
//     await storecontroller!.getall(); /
//     _initializeQuestions();
//     setState(() {
//       isLoading = false; 
//     });
//   }

//   void _initializeQuestions() {
//     if (storecontroller!.storeList.isNotEmpty) {
//       questions = [
//         Question(
//           'Xin chào Nhật. Chúng tôi có thể giúp gì cho bạn',
//           ['Mua sản phẩm', 'Mua combo',"Xem món"],
//           storecontroller!.storeList,
//         ),
//         Question(
//           'Câu hỏi của bạn',
//           ['Hướng dẫn', 'Cửa hàng',],
//           storecontroller!.storeList,
//         ),
//         Question(
//           'Cửa hàng bán gì?',
//           ['Thời trang', 'Đồ ăn', 'Đồ điện tử'],
//           storecontroller!.storeList,
//         ),
//         // Add more questions if needed
//       ];
//     }
//   }

//   void _selectAnswer() {
//     setState(() {
//       respone = questions[_currentQuestionIndex].answer as List<Storesitem>;
//       _answered = true;
//     });
//   }

//   void _nextQuestion() {
//     setState(() {
//       if (_currentQuestionIndex < questions.length - 1) {
//         _currentQuestionIndex++; // Move to the next question
//         _answered = false; // Reset answered state for the next question
//         respone = null; // Clear previous response
//       } else {
//         // Handle end of questions (optional)
//         _currentQuestionIndex = 0; // Reset to the first question, or handle accordingly
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Cửa hàng của bạn'),
//         ),
//         body: Center(
//           child: CircularProgressIndicator(), // Show loading indicator
//         ),
//       );
//     }

//     if (questions.isEmpty) {
//       return Scaffold(
//         appBar: AppBar(
//           title: Text('Cửa hàng của bạn'),
//         ),
//         body: Center(
//           child: Text('No questions available'), // Handle empty questions
//         ),
//       );
//     }

//     Question currentQuestion = questions[_currentQuestionIndex];

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Cửa hàng của bạn'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               currentQuestion.questionText,
//               style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ...List.generate(currentQuestion.answers.length, (index) {
//               return ElevatedButton(
//                 onPressed: _answered ? null : () => _selectAnswer(),
//                 child: Text(currentQuestion.answers[index]),
//               );
//             }),
//             if (_answered)
//               Column(
//                 children: [
//                   ...respone!.map((item) => Container(
//                         child: Text(item.storeName!),
//                       )),
//                   ElevatedButton(
//                     onPressed: _nextQuestion, // Call next question
//                     child: Text('Câu hỏi tiếp theo'),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class Question {
//   String questionText;
//   List<String> question;
//   List<Object> answer;

//   Question(this.questionText, this.question, this.answer);
// }
