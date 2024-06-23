// ignore_for_file: public_member_api_docs, sort_constructors_first
// the whole course model including with pdfs videos and assignments
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:course_admin/models/category_model.dart';
import 'package:course_admin/models/gallery_model.dart';
import 'package:course_admin/providers/course_provider.dart';

class Course {
  int id;
  String title;
  GalleryImage img;
  Category category;
  String description;
  DateTime creationTime;
  double price;
  double discount;
  List<Subject> subjects;
  List<FAQModel> faq;
  List<Teacher> teachers;
  List<AnnouncementsModel> announcements = [];

  // constructor for course model
  Course({
    required this.id,
    required this.title,
    required this.img,
    required this.faq,
    required this.category,
    required this.subjects,
    required this.creationTime,
    required this.description,
    required this.teachers,
    required this.price,
    required this.discount,
    required this.announcements,
  });
  // function to Course Model this from json
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        id: json['id'],
        title: json['title'],
        img: GalleryImage.fromJson(json['img']),
        price: json['price'],
        faq: json['faq'] != null
            ? (json['faq'] as List)
                .map((item) => FAQModel.fromJson(item))
                .toList()
            : [],
        discount: json['discount'],
        category: Category.fromJson(json['category']),
        subjects: json['subjects'] != null
            ? (json['subjects'] as List)
                .map((i) => Subject.fromJson(i))
                .toList()
            : [],
        creationTime: DateTime.parse(json['creationTime']),
        description: json['description'],
        teachers:
            (json['teachers'] as List).map((i) => Teacher.fromJson(i)).toList(),
        announcements: json['announcements'] != null
            ? (json['announcements'] as List)
                .map((e) => AnnouncementsModel.fromJson(e))
                .toList()
            : []);
  }
// function to convert Course Model to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'img': img.toJson(),
      'price': price,
      'faq': faq.map((item) => item.toJson()),
      'discount': discount,
      'category': category.toJson(),
      'subjects': subjects.map((subject) => subject.toJson()).toList(),
      'description': description,
      'creationTime': creationTime.toIso8601String(),
      'teachers': teachers.map((teacher) => teacher.toJson()).toList(),
      'announcements':
          announcements.map((announcement) => announcement.toJson()).toList()
    };
  }

 

  factory Course.fromId(int id, BuildContext context) {
    return context
        .read<CourseProvider>()
        .courses
        .firstWhere((element) => element.id == id);
  }

  Course copyWith({
    int? id,
    String? title,
    GalleryImage? img,
    Category? category,
    String? description,
    DateTime? creationTime,
    double? price,
    double? discount,
    List<Subject>? subjects,
    List<FAQModel>? faq,
    List<Teacher>? teachers,
    List<AnnouncementsModel>? announcements,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      img: img ?? this.img,
      category: category ?? this.category,
      description: description ?? this.description,
      creationTime: creationTime ?? this.creationTime,
      price: price ?? this.price,
      discount: discount ?? this.discount,
      subjects: subjects ?? this.subjects,
      faq: faq ?? this.faq,
      teachers: teachers ?? this.teachers,
      announcements: announcements ?? this.announcements,
    );
  }
}

class Teacher {
  String name;
  String img;
  String desc;
  String subject;
  int experience;

  Teacher({
    required this.desc,
    required this.img,
    required this.name,
    required this.experience,
    required this.subject,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
        desc: json['desc'],
        img: json['img'],
        name: json['name'],
        experience: json['exp'],
        subject: json['subject']);
  }

  toJson() {
    return {
      'name': name,
      'img': img,
      'desc': desc,
      'exp': experience,
      'subject': subject,
    };
  }
}

// model for subjects including with chapters in it

class Subject {
  //
  String name;
  List<Chapter>? chapters;
  GalleryImage image;
  Subject({
    required this.name,
    required this.chapters,
    required this.image,
  });

  factory Subject.fromJson(Map<String, dynamic> json) {
    return Subject(
      name: json['name'],
      image: GalleryImage.fromJson(json['image']),
      chapters:
          (json['chapters'] as List).map((i) => Chapter.fromJson(i)).toList(),
    );
  }

  toJson() {
    return {
      'image': image.toJson(),
      'name': name,
      'chapters': chapters?.map((chapter) => chapter.toJson()).toList(),
    };
  }
}

// model for chapters including with a list of lectures

class Chapter {
  //
  String name;
  List<LectureVideo>? lectures;
  List<PDF>? notes;
  List<PDF>? assignments;

  Chapter(
      {required this.assignments,
      required this.lectures,
      required this.name,
      required this.notes});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      assignments:
          (json['assignments'] as List).map((i) => PDF.fromJson(i)).toList(),
      lectures: (json['lectures'] as List)
          .map((i) => LectureVideo.fromJson(i))
          .toList(),
      name: json['name'],
      notes: (json['notes'] as List).map((i) => PDF.fromJson(i)).toList(),
    );
  }

  toJson() {
    return {
      'name': name,
      'lectures': lectures?.map((lecture) => lecture.toJson()).toList(),
      'notes': notes?.map((note) => note.toJson()).toList(),
      'assignments':
          assignments?.map((assignment) => assignment.toJson()).toList(),
    };
  }
}

// class for a pdf
class PDF {
  String? name;
  String? url;
  DateTime time;

  PDF({required this.name, required this.url, required this.time});

  factory PDF.fromJson(Map<String, dynamic> json) {
    return PDF(
        name: json['name'],
        url: json['url'],
        time: DateTime.parse(json['time']));
  }

  toJson() {
    return {'name': name, 'url': url, 'time': time.toIso8601String()};
  }
}

class LectureVideo {
  String name;
  String url;
  String thumbnail;
  DateTime time;
  LectureVideo({
    required this.name,
    required this.url,
    required this.thumbnail,
    required this.time,
  });

  factory LectureVideo.fromJson(Map<String, dynamic> json) {
    return LectureVideo(
        name: json['name'],
        url: json['url'],
        thumbnail: json['thumbnail'],
        time: DateTime.parse(json['time']));
  }

  toJson() {
    return {
      'name': name,
      'url': url,
      'thumbnail': thumbnail,
      'time': time.toIso8601String()
    };
  }
}

class FAQModel {
  final String question;
  final String answer;

  FAQModel({
    required this.answer,
    required this.question,
  });

  factory FAQModel.fromJson(Map<String, dynamic> json) {
    return FAQModel(answer: json['answer'], question: json['question']);
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}

class AnnouncementsModel {
  String adminName;
  String text;
  String? image;
  DateTime time;

  AnnouncementsModel({
    required this.adminName,
    required this.text,
    required this.time,
    this.image,
  });

  factory AnnouncementsModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementsModel(
        adminName: json['adminName'],
        text: json['text'],
        image: json['image'],
        time: DateTime.parse(json['time']));
  }

  Map<String, dynamic> toJson() {
    return {
      'adminName': adminName,
      'text': text,
      'image': image ?? 'N/A',
      'time': time.toIso8601String(),
    };
  }
}
