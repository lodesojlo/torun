import 'package:flutter/material.dart';
import '../constants.dart';
import '../main.dart';
import '../generated/l10n/app_localizations.dart';
import '../services/score_service.dart';
import '../services/sound_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final ScoreService _scoreService = ScoreService();
  final SoundService _soundService = SoundService();
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _soundEnabled = _soundService.enabled;
  }

  Future<void> _resetStats() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameConstants.darkColor,
        title: Text(l10n.confirm,
            style: const TextStyle(color: Colors.white)),
        content: Text(
          l10n.resetStatsConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: GameConstants.dangerColor),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _scoreService.resetStats();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).statsReset),
          backgroundColor: GameConstants.successColor,
        ),
      );
    }
  }

  Future<void> _resetAll() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameConstants.darkColor,
        title: Text(
          '⚠️ ${l10n.dangerZone}',
          style: const TextStyle(color: GameConstants.dangerColor),
        ),
        content: Text(
          l10n.resetAllConfirm,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
                backgroundColor: GameConstants.dangerColor),
            child: Text(l10n.deleteAll),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await _scoreService.resetAll();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).allReset),
          backgroundColor: GameConstants.successColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLang =
        TorunApp.of(context)?.currentLocale.languageCode ?? 'ar';

    return Scaffold(
      backgroundColor: GameConstants.darkColor,
      appBar: AppBar(
        backgroundColor: GameConstants.darkColor,
        foregroundColor: Colors.white,
        title: Text('⚙️ ${l10n.settings}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // =============================================
          // ✅ اللغة (جديد)
          // =============================================
          _buildSectionTitle('🌍 ${l10n.language}'),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0F3460),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                _buildLanguageOption(
                    '🇸🇦 ${l10n.arabic}', 'ar', currentLang),
                const Divider(color: Colors.white24, height: 1),
                _buildLanguageOption(
                    '🇬🇧 ${l10n.english}', 'en', currentLang),
                const Divider(color: Colors.white24, height: 1),
                _buildLanguageOption(
                    '🇫🇷 ${l10n.french}', 'fr', currentLang),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // =============================================
          // ✅ الصوت
          // =============================================
          _buildSectionTitle('🔊 ${l10n.sound}'),
          _buildSwitchTile(
            title: l10n.soundOn,
            value: _soundEnabled,
            onChanged: (value) {
              setState(() => _soundEnabled = value);
              _soundService.setEnabled(value);
            },
          ),
          const SizedBox(height: 20),

          // =============================================
          // ✅ الإحصائيات
          // =============================================
          _buildSectionTitle('📊 ${l10n.gamesPlayed}'),
          _buildStatTile(
            l10n.gamesPlayed,
            '${_scoreService.stats['total_deaths'] ?? 0}',
          ),
          _buildStatTile(
            l10n.highScore,
            '${_scoreService.highScore}',
          ),
          _buildStatTile(
            l10n.totalCoins,
            '${_scoreService.totalCoinsEarned}',
          ),
          const SizedBox(height: 20),

          // =============================================
          // ✅ منطقة الخطر
          // =============================================
          _buildSectionTitle('⚠️ ${l10n.dangerZone}'),
          _buildDangerButton(
            label: '🗑️ ${l10n.resetStats}',
            onTap: _resetStats,
          ),
          const SizedBox(height: 8),
          _buildDangerButton(
            label: '💥 ${l10n.resetAll}',
            onTap: _resetAll,
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '${l10n.version} 1.0.0',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ خيار اللغة
  Widget _buildLanguageOption(String label, String code, String current) {
    final isSelected = current == code;

    return InkWell(
      onTap: () {
        _soundService.play('click');
        TorunApp.of(context)?.changeLanguage(code);
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color:
                      isSelected ? GameConstants.primaryColor : Colors.white,
                  fontSize: 15,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: GameConstants.successColor,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: GameConstants.primaryColor,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        value: value,
        onChanged: onChanged,
        activeThumbColor: GameConstants.primaryColor,
      ),
    );
  }

  Widget _buildStatTile(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7))),
          Text(value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildDangerButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: GameConstants.dangerColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}