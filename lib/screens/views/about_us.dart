// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutusScreen extends StatelessWidget {
  const AboutusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () async {
                await launchUrl(
                  Uri.parse('https://www.instagram.com/codewithvenom/'),
                );
              },
              icon: Icon(LineIcons.instagram, size: 26, color: Colors.pink))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Center(
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/notepediax_black.png',
                        height: context.width * 0.75,
                        width: context.width * 0.75,
                      ))),
              SizedBox(height: 30),
              Text(
                'About Notepediax',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                "Notepediax is an ed-tech startup that offers a comprehensive online platform for learners of all ages and backgrounds. It provides a wide range of educational resources, including interactive courses, video tutorials, study materials, and practice quizzes, covering various subjects and topics. Notepediax leverages advanced technology to personalize the learning experience, allowing users to learn at their own pace and according to their individual learning styles. The platform also fosters a sense of community among learners, facilitating collaboration and knowledge sharing.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 15),
              Text(
                'Our vision',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                "The vision of Notepediax is to transform education by leveraging technology to make learning accessible, personalized, and engaging for everyone. We envision a future where learners from all walks of life can access high-quality educational resources anytime, anywhere, breaking down barriers to education and empowering individuals to reach their full potential. Through innovation, collaboration, and a commitment to excellence, we strive to create a global community of lifelong learners who are equipped with the knowledge and skills needed to succeed in the 21st century.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 15),
              SizedBox(height: 15),
              Text(
                'Our commitment',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text(
                """The commitment of Notepediax is to provide unparalleled educational support and resources to our users. We are dedicated to:

1. Quality: Offering high-quality educational content curated by experts to ensure accuracy and relevance.\n
2. Accessibility: Ensuring that our platform is accessible to learners from diverse backgrounds, regardless of geographical location or socio-economic status.\n
3. Innovation: Continuously innovating and integrating the latest technologies to enhance the learning experience and stay ahead of the curve.\n
4. Personalization: Tailoring our resources and features to meet the individual needs and preferences of each learner, fostering a personalized learning journey.\n
5. Community: Cultivating a supportive and collaborative learning community where users can interact, share knowledge, and support each other’s learning goals.\n
6. Ethical Practices: Upholding the highest standards of integrity, transparency, and ethical conduct in all aspects of our operations and interactions with users. \n\n
Through these commitments, Notepediax aims to empower learners to achieve academic success and personal growth, making a positive impact on education globally.""",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
