import 'package:course_app/models/notes_model.dart';
import 'package:course_app/provider/user_provider.dart';
import 'package:course_app/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ConfirmNotesPurchase extends StatefulWidget {
  const ConfirmNotesPurchase({super.key, required this.notes});
  final NotesModel notes;

  @override
  State<ConfirmNotesPurchase> createState() => _ConfirmNotesPurchaseState();
}

class _ConfirmNotesPurchaseState extends State<ConfirmNotesPurchase> {
  final _razorpay = Razorpay();

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    UserProvider().buyNotes(widget.notes);
    Get.offAll(() => Home());
    selectedIndex.value = 1;

    Get.snackbar('Success', 'Payment Success ${response.paymentId}',
        backgroundColor: Colors.white,
        colorText: Colors.green,
        duration: const Duration(seconds: 5));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    Get
      ..back()
      ..back<bool>(result: false);
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
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    var options = {
      'key': 'rzp_test_QV6NcMIy4nKHCo',
      'amount': widget.notes.price * 100,
      'name': 'Notepediax Notes',
      'description': widget.notes.description,
      'prefill': {'contact': '8888888888', 'email': 'ls8290519977@gmail.com'}
    };

    _razorpay.open(options);
  }

  Future<bool> checkPayment() async {
    if (context.watch<UserProvider>().userNotes.contains(widget.notes)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkPayment(),
          builder: (context, snapshot) {
            if (snapshot.data == false) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(
                child: Text('Purchased You can now go back'),
              );
            }
          }),
    );
  }
}
