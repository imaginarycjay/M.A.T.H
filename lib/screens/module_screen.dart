import 'package:flutter/material.dart';
import 'package:knhs_math_learning_app/data/mock_modules.dart';
import 'package:knhs_math_learning_app/theme/app_theme.dart';
import 'package:knhs_math_learning_app/screens/topic_detail_screen.dart';

class ModuleScreen extends StatelessWidget {
  const ModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final module = appModules[0];

    return Scaffold(
      appBar: AppBar(title: Text(module.title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            module.description,
            style: const TextStyle(color: AppTheme.muted, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...module.topics.map((topic) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Card(
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TopicDetailScreen(topic: topic))),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(topic.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                                const SizedBox(height: 4),
                                Text(topic.shortDesc, style: const TextStyle(color: AppTheme.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppTheme.muted),
                        ],
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
