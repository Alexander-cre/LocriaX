import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibe_ai/pages/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeController>(context);
    final isDarkMode = theme.isDarkMode;
    final bg = isDarkMode ? const Color(0xFF0D0D12) : Colors.white;
    final text = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(color: text, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: text),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _settingsTile(
              icon: isDarkMode ? Icons.dark_mode : Icons.light_mode,
              text: "Night Mode",
              textColor: text,
              child: Switch(
                value: isDarkMode,
                onChanged: (_) => theme.toggleTheme(),
              ),
            ),
            const SizedBox(height: 20),
            _settingsTile(
              icon: Icons.info_outline,
              text: "About This App",
              textColor: text,
            ),
            const SizedBox(height: 20),
            _settingsTile(
              icon: Icons.person,
              text: "Contact Developer",
              textColor: text,
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsTile({
    required IconData icon,
    required String text,
    required Color textColor,
    Widget? child,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: textColor.withOpacity(0.05),
        border: Border.all(color: textColor.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(icon, size: 26, color: textColor),
            const SizedBox(width: 12),
            Text(text, style: TextStyle(fontSize: 18, color: textColor)),
          ]),
          if (child != null) child,
        ],
      ),
    );
  }
}
