import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/theme/AppColors.dart';
import 'package:go_router/go_router.dart';

class AppLicensePage extends StatelessWidget {
  const AppLicensePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Application License",style: TextStyle(
          color: theme.textTheme.titleLarge?.color
        ),),
        centerTitle: true,
        leading: IconButton(
          onPressed: ()=>context.go('/settings'),
          icon:Icon(Icons.arrow_back_ios,color: theme.iconTheme.color),

        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Card container
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.dividerColor),
                ),
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    _licenseText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Open source licenses button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showLicensePage(context: context);
                },
                icon:Icon(Icons.description_outlined,color: theme.iconTheme.color,),
                label: Text(
                  "View Open Source Licenses",
                  style: TextStyle(fontWeight: FontWeight.bold,color: AppColors.bgDark),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.tertiary,
                  foregroundColor: theme.colorScheme.onTertiary,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String _licenseText = """
TRAVELON APPLICATION LICENSE AGREEMENT

Last updated: 2026

This Application License Agreement (“Agreement”) governs your use of the Travelon mobile application (“App”). By installing, accessing, or using the App, you agree to be bound by this Agreement.

1. License Grant

Travelon grants you a limited, non-exclusive, non-transferable, revocable license to use this App for personal or authorized tourism-related purposes, including trip management, guide interaction, itinerary viewing, and feedback submission.

2. Restrictions

You agree not to:
- Copy, modify, or distribute the App without permission
- Reverse engineer, decompile, or attempt to extract source code
- Use the App for unlawful, fraudulent, or abusive activities
- Resell, rent, lease, or sublicense the App or its services
- Disrupt or misuse tourism services, guides, agencies, or other users

3. Tourism Services Disclaimer

Travelon is a digital platform that facilitates trip planning, guide assignment, itinerary display, and feedback collection. Travelon does not itself provide travel, transportation, or guiding services. These services are provided by independent agencies and guides, who are solely responsible for their conduct and service quality.

4. Safety & Risk Acknowledgment

Tourism and travel activities involve inherent risks, including delays, weather conditions, and unforeseen events. You acknowledge that you use the App at your own risk, and Travelon is not responsible for incidents occurring during trips or activities arranged through the App.

5. Ratings & Feedback

You agree that ratings and feedback must be honest and lawful. Travelon may moderate or remove content that violates policies or applicable laws.

6. Data & Privacy

The App may process trip details, guide assignments, usage data, and ratings. All data is handled in accordance with the Travelon Privacy Policy and applicable data protection laws.

7. Ownership

The App, including its design, features, and content, is owned by Travelon and its licensors. This Agreement does not grant you ownership of any intellectual property.

8. Termination

Travelon may suspend or terminate access if you violate this Agreement or misuse the platform.

9. Limitation of Liability

To the maximum extent permitted by law, Travelon shall not be liable for damages arising from travel activities, third-party services, or use of the App.

10. Changes to This Agreement

Travelon may update this Agreement from time to time. Continued use of the App means you accept the updated terms.

11. Contact

For questions about this license, contact the Travelon team.

© Travelon. All rights reserved.
""";
