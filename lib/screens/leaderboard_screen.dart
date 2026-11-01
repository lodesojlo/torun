import 'package:flutter/material.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/score_service.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scoreService = ScoreService();
    final highScore = scoreService.highScore;
    final leaderboard = scoreService.leaderboard;

    return Scaffold(
      backgroundColor: GameConstants.darkColor,
      appBar: AppBar(
        backgroundColor: GameConstants.darkColor,
        foregroundColor: Colors.white,
        title: Text(
          '🏆 ${l10n.leaderboard}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =============================================
            // ✅ أعلى نتيجة
            // =============================================
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: GameConstants.secondaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: GameConstants.secondaryColor),
              ),
              child: Column(
                children: [
                  Text(
                    '🥇 ${l10n.highScore}',
                    style: const TextStyle(
                      color: GameConstants.secondaryColor,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$highScore ${l10n.seconds}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // =============================================
            // ✅ القائمة
            // =============================================
            Expanded(
              child: leaderboard.isEmpty
                  ? Center(
                      child: Text(
                        '${l10n.noResultsYet}\n\n${l10n.startPlaying}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFFADB5BD),
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: leaderboard.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (ctx, i) {
                        final entry = leaderboard[i];
                        final rankEmoji = i < 5
                            ? ['🥇', '🥈', '🥉', '4️⃣', '5️⃣'][i]
                            : '${i + 1}.';
                        final dateStr =
                            _formatDate(entry['date'] as String? ?? '');
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0F3460),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: i == 0
                                  ? GameConstants.secondaryColor
                                  : const Color(0xFF1E5A96),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                rankEmoji,
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${entry['score']} ${l10n.seconds}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  color: Color(0xFFADB5BD),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final date = DateTime.parse(iso);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return '';
    }
  }
}