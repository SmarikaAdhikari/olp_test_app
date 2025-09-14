import 'package:flutter/material.dart';
import '../../domain/courses_list_model.dart';
import 'chapters_screen.dart';
import 'package:flutter/material.dart';
import '../../domain/courses_list_model.dart';
import 'chapters_screen.dart';

class SubjectsScreen extends StatelessWidget {
  final Course course;

  const SubjectsScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          course.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: course.subjects.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final subject = course.subjects[index];
          return _SubjectCard(subject: subject);
        },
      ),
    );
  }
}

class _SubjectCard extends StatelessWidget {
  final Subject subject;

  const _SubjectCard({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getSubjectIcon(subject.title),
            color: Colors.blue[600],
            size: 24,
          ),
        ),
        title: Text(
          subject.title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subject.description,
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                '${subject.chapters.length} chapters',
                style: TextStyle(
                  color: Colors.blue[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChaptersScreen(subject: subject),
            ),
          );
        },
      ),
    );
  }

  IconData _getSubjectIcon(String title) {
    final lower = title.toLowerCase();
    if (lower.contains('knowledge')) return Icons.psychology;
    if (lower.contains('math')) return Icons.calculate;
    if (lower.contains('geography')) return Icons.public;
    return Icons.book;
  }
}
