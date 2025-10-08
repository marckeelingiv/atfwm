import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/state/character_form_controller.dart';
import 'src/ui/character_sheet_page.dart';

void main() {
  runApp(const CharacterApp());
}

class CharacterApp extends StatelessWidget {
  const CharacterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CharacterFormController(),
      child: MaterialApp(
        title: 'Essence Character Forge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: const Color(0xFFF7F7F9),
        ),
        home: const CharacterSheetPage(),
      ),
    );
  }
}
