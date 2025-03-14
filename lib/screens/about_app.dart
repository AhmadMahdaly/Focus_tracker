import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:focus_tracker/widgets/leading_icon.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About App'.tr(),
          style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
        ),
        automaticallyImplyLeading: false,
        leading: const LeadingIcon(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView(
          children: [
            const SizedBox(height: 24),
            Text(
              'How to Improve Your Focus Using the Focused Work Sessions Technique?'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              '📌 Introduction'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Text(
              'In a world full of distractions, focus has become a rare skill.\nDo you find yourself starting a task only to stop because of phone notifications?\nOr do you feel like your day slips away without accomplishing what you planned?\n💡 The solution lies in the Focused Work Sessions technique, an effective method to boost productivity and minimize distractions in a scientifically proven way.'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🔹 What Is the Focused Work Sessions Technique?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Text(
              'This technique involves dividing your work time into set periods of deep focus, followed by short breaks to refresh your mind. During these sessions, you concentrate on one task only, which helps you achieve more in less time.'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🧠 Why does this technique work?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            Text(
              'The brain cannot maintain focus for extended periods without rest. By working in structured focus sessions, your mind gets time to recharge, leading to better concentration and increased productivity without burnout.'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🔹 How Does This Technique Work?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            const SizedBox(height: 8),

            Text(
              'The method is simple and consists of 5 clear steps:'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
            ),
            Text(
              '1️⃣ Choose the task you want to complete 🎯\n2️⃣ Set a timer for 25 minutes ⏳\n3️⃣ Work with full focus during this period 🔥\n4️⃣ When the time is up, take a short break (5 minutes) 🛑\n5️⃣ Repeat the process 4 times, then take a longer break (20-30 minutes) 🏖'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🎯 Why 25 Minutes?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Text(
              '🔹 An optimal duration to maintain focus without exhausting the brain.\n🔹 Creates a sense of urgency, making you work more efficiently.\n🔹 Reduces resistance to starting a task, as 25 minutes feels manageable compared to working for hours.'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🔹 Why Is This Technique Effective?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Text(
              "✅ Reduces distractions: When you know you only have 25 minutes, it's easier to ignore notifications and distractions.\n✅ Improves work quality: Short, focused sessions help maintain a high level of mental performance.\n✅ Prevents burnout: Regular breaks keep your brain active and prevent mental fatigue.\n✅ Boosts motivation: Completing each session gives you a sense of accomplishment, making you more productive."
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🔹 How Can You Apply This Technique in Your Daily Life?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Text(
              "📖 For students: Use focused work sessions to study effectively without boredom.\n💼 For professionals: Break down your daily tasks into short work sessions to boost productivity.\n🎨 For creatives: Whether you're a writer or designer, this method helps you achieve more without feeling overwhelmed."
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),
            const SizedBox(height: 8),

            Text(
              '🚀 Ready to Try This Technique?'.tr(),
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
            ),
            Text(
              'Start today and watch how your focus and productivity improve for the better! 😊'
                  .tr(),
              style: const TextStyle(fontWeight: FontWeight.w200, fontSize: 14),
            ),

            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }
}
