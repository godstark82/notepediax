import 'package:course_app/constants/utils/utils.dart';
import 'package:course_app/models/course_model.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/course/explore_course.dart';
import 'package:course_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmCoursePurchasePage extends StatefulWidget {
  const ConfirmCoursePurchasePage({super.key, required this.course});
  final Course course;

  @override
  State<ConfirmCoursePurchasePage> createState() =>
      _ConfirmCoursePurchasePageState();
}

class _ConfirmCoursePurchasePageState extends State<ConfirmCoursePurchasePage> {
  final _razorpay = Razorpay();
  late Course course;

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    // Do something when payment succeeds
    await UserProvider().buyCourse(course).whenComplete(() async {
      Get.offAll(() => Home());
      await Future.delayed(Duration(seconds: 1));
      Get.to(() =>
          ExploreCourseScreen(course: course, isPurchased: true, tabIndex: 1));
      SnackBars.showGreenSnackBar(
          context: context, message: 'Course Purchased Successfully');
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get.back(result: true);
    SnackBars.showRedSnackBar(
        context: context,
        message: 'Payment Failed ${response.code} ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  @override
  void initState() {
    course = widget.course;
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': 'rzp_test_QV6NcMIy4nKHCo',
      'amount': widget.course.price * 100,
      'name': 'Notepediax',
      'description': widget.course.description.characters.take(200).toString(),
      'prefill': {'contact': '8888888888', 'email': 'ls8290519977@gmail.com'}
    };

    _razorpay.open(options);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size(context.width, 5),
            child: const LinearProgressIndicator()),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: CircularProgressIndicator()),
            TextButton(onPressed: () => Get.back(), child: const Text('Cancel'))
          ],
        ));
  }
}

class AlreadyPurchasedPage extends StatelessWidget {
  const AlreadyPurchasedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: const Center(child: Text(' ')));
  }
}
