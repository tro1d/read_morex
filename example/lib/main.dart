import 'package:flutter/material.dart';
import 'package:read_morex_example/post_card.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: Scaffold(
        appBar: AppBar(title: const Text('Read MoreX Example')),
        body: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              PostCard(
                userName: 'Read More',
                content:
                    'This is a very long text. You can tap the "Read More" button to see more text. Suspendisse interdum consectetur libero id faucibus nisl tincidunt eget nullam. Eu nisl nunc mi ipsum faucibus vitae aliquet nec. Suspendisse interdum consectetur libero id faucibus nisl tincidunt eget nullam. Eu nisl nunc mi ipsum faucibus vitae aliquet nec.',
              ),
              PostCard(
                userName: 'Read More with Filter',
                content: 'Link: https://github.com/tro1d\nAlternative link: https://flutter.dev\n\nEmail: readmorex@demo.com\nPhone: 0808080889',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
