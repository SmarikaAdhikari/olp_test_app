import 'package:flutter/material.dart';
import '../../domain/courses_list_model.dart';
import 'chapters_screen.dart';

class SubjectsScreen extends StatelessWidget {
  final Course course;

  const SubjectsScreen({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          course.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: course.subjects.length,
          itemBuilder: (context, index) {
            final subject = course.subjects[index];
            return _buildSubjectCard(context, subject);
          },
        ),
      ),
    );
  }

  Widget _buildSubjectCard(BuildContext context, Subject subject) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              subject.description,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
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
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[400],
          size: 16,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChaptersScreen(subject: subject),
            ),
          );
        },
      ),
    );
  }

  IconData _getSubjectIcon(String subjectTitle) {
    if (subjectTitle.toLowerCase().contains('knowledge')) {
      return Icons.psychology;
    } else if (subjectTitle.toLowerCase().contains('math')) {
      return Icons.calculate;
    } else if (subjectTitle.toLowerCase().contains('geography')) {
      return Icons.public;
    }
    return Icons.book;
  }
}