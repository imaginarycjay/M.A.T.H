import 'topic.dart';

class Module {
  final String id;
  final String title;
  final String description;
  final List<Topic> topics;

  const Module({
    required this.id,
    required this.title,
    required this.description,
    required this.topics,
  });
}

