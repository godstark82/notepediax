// the whole course model including with PDFModels videos and assignments

import 'package:course_app/models/category_model.dart';
import 'package:course_app/models/gallery_model.dart';
import 'package:course_app/provider/non_state_var.dart';

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
  List<AnnounmentsModel>? announcements;

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
    this.announcements,
  });
  // function to Course Model this from json
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        id: json['id'],
        title: json['title'],
        img: GalleryImage.fromJson(json['img']),
        price: double.parse(json['price'].toString()),
        faq: json['faq'] != null
            ? (json['faq'] as List)
                .map((item) => FAQModel.fromJson(item))
                .toList()
            : [],
        discount: double.parse(json['discount'].toString()),
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
                .map((e) => AnnounmentsModel.fromJson(e))
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
          announcements?.map((announcement) => announcement.toJson()).toList()
    };
  }

  factory Course.fromId(int id) {
    late Course course;
    for (int i = 0; i < LocalVariables.allCourses.length; i++) {
      if (id == LocalVariables.allCourses[i].id) {
        course = LocalVariables.allCourses[i];
        break;
      } else {
        course = dummyCourse;
      }
    }
    return course;
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
  List<PDFModel>? notes;
  List<PDFModel>? assignments;

  Chapter(
      {required this.assignments,
      required this.lectures,
      required this.name,
      required this.notes});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      assignments: (json['assignments'] as List)
          .map((i) => PDFModel.fromJson(i))
          .toList(),
      lectures: (json['lectures'] as List)
          .map((i) => LectureVideo.fromJson(i))
          .toList(),
      name: json['name'],
      notes: (json['notes'] as List).map((i) => PDFModel.fromJson(i)).toList(),
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

// class for a PDFModel
class PDFModel {
  String? name;
  String? url;
  DateTime time;

  PDFModel({required this.name, required this.url, required this.time});

  factory PDFModel.fromJson(Map<String, dynamic> json) {
    return PDFModel(
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

class AnnounmentsModel {
  String adminName;
  String text;
  String? image;
  DateTime time;

  AnnounmentsModel({
    required this.adminName,
    required this.text,
    required this.time,
    this.image,
  });

  factory AnnounmentsModel.fromJson(Map<String, dynamic> json) {
    return AnnounmentsModel(
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

Course dummyCourse = Course(
    id: 019283102,
    title: 'Dummy Course',
    img: GalleryImage(url: '', ref: ''),
    faq: [],
    category: Category(name: '', img: ''),
    subjects: [],
    creationTime: DateTime.now(),
    description:
        'This is a Dummy Course, It means the course you are trying to find is no longer available',
    teachers: [],
    price: 0,
    discount: 0);
