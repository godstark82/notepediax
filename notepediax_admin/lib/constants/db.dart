import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

ValueNotifier<Map<String, List>> db = ValueNotifier({});

final admin = FirebaseFirestore.instance.collection('admin');
