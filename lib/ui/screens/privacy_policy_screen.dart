import 'package:flutter/material.dart';
import 'package:cozygame/ui/theme.dart';
import 'package:cozygame/ui/widgets/cozy_button.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CozyTheme.paperCream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text('Privacy Policy', style: CozyTheme.headingStyle),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: CozyTheme.outlineGrey, width: 2),
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Updated: January 18, 2026',
                        style: CozyTheme.captionStyle,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '1. Data Collection',
                        style: CozyTheme.subheadingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'The Cozy Courier is designed with your privacy in mind. We do not collect, store, or share any personal information, location data, or device identifiers.',
                        style: CozyTheme.bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '2. Local Storage',
                        style: CozyTheme.subheadingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'All game progress (levels unlocked, stars earned, settings) is stored locally on your device. Uninstalling the app may result in the loss of this data.',
                        style: CozyTheme.bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '3. Children\'s Privacy',
                        style: CozyTheme.subheadingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We do not knowingly collect any data from children. The game is safe for all ages.',
                        style: CozyTheme.bodyStyle,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '4. Contact Us',
                        style: CozyTheme.subheadingStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'If you have any questions about this privacy policy, please contact us at support@cozycourier.game.',
                        style: CozyTheme.bodyStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CozyButton(
                text: 'CLOSE',
                type: CozyButtonType.secondary,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
