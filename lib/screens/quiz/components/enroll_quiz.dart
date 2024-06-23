import 'package:cached_network_image/cached_network_image.dart';
import 'package:course_app/models/quiz_model.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/quiz/components/play_quiz.dart';
import 'package:course_app/screens/quiz/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class EnrollQuizScreen extends StatefulWidget {
  const EnrollQuizScreen({super.key, required this.quiz});
  final QuizModel quiz;

  @override
  State<EnrollQuizScreen> createState() => _EnrollQuizScreenState();
}

class _EnrollQuizScreenState extends State<EnrollQuizScreen> {
  final _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds

    final QuizModel newQuiz = widget.quiz.copyWith(
        isPurchased: true, isAttempted: false, lastScore: 0, lastResponse: []);
    await context.read<UserProvider>().buyQuizes(newQuiz);
    Get.off(() => PlayQuizScreen(userQuiz: newQuiz));

    Get.snackbar('Success', 'Payment Success ${response.paymentId}',
        backgroundColor: Colors.white,
        colorText: Colors.green,
        duration: const Duration(seconds: 5));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.back();
    Get.snackbar('Error', 'Payment Failed ${response.message}',
        backgroundColor: const Color.fromARGB(255, 179, 179, 179),
        colorText: Colors.red,
        duration: const Duration(seconds: 5));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void initState() {
    quizes.clear();
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    var options = {
      'key': 'rzp_test_QV6NcMIy4nKHCo',
      'amount': widget.quiz.price * 100,
      'name': 'Notepediax Quiz',
      'description': widget.quiz.description,
      'prefill': {'contact': '8888888888', 'email': 'ls8290519977@gmail.com'}
    };
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.quiz.title),
        ),
        body: DescriptionView(quiz: widget.quiz),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              if (widget.quiz.price != 0) {
                _razorpay.open(options);
              } else {
                _handlePaymentSuccess(PaymentSuccessResponse(
                    'FreeQuizPayment', 'FreeQuizPayment', 'FreeQuizPayment',{}));
              }
              setState(() {});
            },
            label: Text('Buy for only Rs. ${widget.quiz.price}')));
  }
}

class DescriptionView extends StatelessWidget {
  const DescriptionView({super.key, required this.quiz});
  final QuizModel quiz;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (quiz.image != null)
                ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: quiz.image.toString(),
                        fit: BoxFit.fill,
                      ),
                    )),
              const Divider(),
              const SizedBox(height: 20),
              Text(quiz.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 10),
              Text(quiz.description),
              Text('Total Questions in this Quiz: ${quiz.questions.length}')
                  
            ],
          )),
        ],
      ),
    );
  }
}
