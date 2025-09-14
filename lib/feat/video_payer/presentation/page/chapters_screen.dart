import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/courses_list_model.dart';
import '../widgets/chatper_widgets.dart';

class ChaptersScreen extends ConsumerWidget {
  final Subject subject;

  const ChaptersScreen({super.key, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          subject.title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blue[600],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ChapterWidget(subject: subject),
    );
  }
}
