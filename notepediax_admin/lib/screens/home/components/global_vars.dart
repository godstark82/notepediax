import 'package:course_admin/models/category_model.dart';
import 'package:course_admin/models/course_model.dart';
import 'package:course_admin/models/gallery_model.dart';

class AddCourseVariables {
  // static List<Subject> subjects = [];
  // static GalleryImage? image;
  // static String name = '';
  // static String description = '';
  // static String price = '';
  // static String discount = '';
  // static String selectedCategory = '';
  // static List<Teacher> teachers = [];
  // static List<FAQModel> faqs = [];
  // static List<AnnouncementsModel> announcements = [];

  // static void clear() {
  //   subjects = [];
  //   image = null;
  //   name = '';
  //   description = '';
  //   price = '';
  //   discount = '';
  //   selectedCategory = '';
  //   teachers = [];
  //   faqs = [];
  //   announcements = [];
  // }
}

Course tempCourse = Course(
    id: 0,
    title: '',
    img: GalleryImage(url: '', ref: ''),
    faq: [],
    category: Category(),
    subjects: [],
    creationTime: DateTime.now(),
    description: '',
    teachers: [],
    price: 0,
    discount: 0,
    announcements: []);

void clearTempCourse() {
  tempCourse = Course(
      id: 0,
      title: '',
      img: GalleryImage(url: '', ref: ''),
      faq: [],
      category: Category(),
      subjects: [],
      creationTime: DateTime.now(),
      description: '',
      teachers: [],
      price: 0,
      discount: 0,
      announcements: []);
}

final tempSubject =
    Subject(name: '', chapters: [], image: GalleryImage(ref: '', url: ''));

void removeTempSubject() {
  if (tempCourse.subjects.contains(tempSubject)) {
    tempCourse.subjects.remove(tempSubject);
  }
}
