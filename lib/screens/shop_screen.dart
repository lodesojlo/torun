import 'package:flutter/material.dart';
import '../constants.dart';
import '../generated/l10n/app_localizations.dart';
import '../l10n/item_translations.dart';
import '../services/score_service.dart';
import '../services/sound_service.dart';
import '../services/shop_catalog.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen>
    with SingleTickerProviderStateMixin {
  final ScoreService _scoreService = ScoreService();
  final SoundService _soundService = SoundService();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    final categories = ShopCatalog.allCategories.keys.toList();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ✅ تنسيق الأسعار (K/M)
  String _formatPrice(int price) {
    if (price >= 1000000) {
      final millions = price / 1000000;
      if (millions == millions.roundToDouble()) {
        return '${millions.toInt()}M';
      }
      return '${millions.toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      final thousands = price / 1000;
      if (thousands == thousands.roundToDouble()) {
        return '${thousands.toInt()}K';
      }
      return '${thousands.toStringAsFixed(1)}K';
    }
    return price.toString();
  }

  String _translateCategory(String key, AppLocalizations l10n) {
    switch (key) {
      case 'character':
        return l10n.categoryCharacters;
      case 'skin':
        return l10n.categorySkins;
      case 'background':
        return l10n.categoryBackgrounds;
      case 'obstacles':
        return l10n.categoryObstacles;
      case 'particles':
        return l10n.categoryParticles;
      case 'sounds':
        return l10n.categorySounds;
      case 'badge':
        return l10n.categoryBadges;
      case 'weapons':
        return l10n.categoryWeapons;
      case 'achievements':
        return l10n.categoryAchievements;
      default:
        return key;
    }
  }

  Future<void> _buyItem(String itemId, String catKey, int price) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: GameConstants.darkColor,
        title: Text(
          l10n.confirmPurchase,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.buyConfirm(_formatPrice(price)), // ✅ تنسيق السعر
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
              backgroundColor: GameConstants.successColor,
            ),
            child: Text(l10n.buy),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    final result = await _scoreService.buyItem(itemId, price);
    if (!mounted) return;

    if (result['success'] == true) {
      await _scoreService.equipItem(catKey, itemId);
      _soundService.play('new_high_score');
      if (!mounted) return;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.purchaseSuccess),
          backgroundColor: GameConstants.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.insufficientCoins),
          backgroundColor: GameConstants.dangerColor,
        ),
      );
    }
  }

  Future<void> _equipItem(String catKey, String itemId) async {
    final l10n = AppLocalizations.of(context);
    final result = await _scoreService.equipItem(catKey, itemId);
    if (!mounted) return;

    if (result['success'] == true) {
      _soundService.play('click');
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.equipFailed),
          backgroundColor: GameConstants.dangerColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final categories = ShopCatalog.allCategories.entries.toList();
    final coins = _scoreService.coins;

    return Scaffold(
      backgroundColor: GameConstants.darkColor,
      appBar: AppBar(
        backgroundColor: GameConstants.darkColor,
        foregroundColor: Colors.white,
        title: Text(
          '🛒 ${l10n.shop}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(left: 16),
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: GameConstants.secondaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: GameConstants.secondaryColor),
              ),
              child: Text(
                '💰 ${_formatPrice(coins)}', // ✅ تنسيق العملات
                style: const TextStyle(
                  color: GameConstants.secondaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: GameConstants.primaryColor,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF6C757D),
          tabs: categories
              .map((e) => Tab(text: _translateCategory(e.key, l10n)))
              .toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: categories.map((entry) {
          final catKey = entry.key;
          final items =
              entry.value['items'] as Map<String, Map<String, dynamic>>;
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.82,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: items.length,
            itemBuilder: (ctx, i) {
              final itemId = items.keys.elementAt(i);
              final itemData = items[itemId]!;
              return _buildItemCard(
                l10n,
                locale,
                catKey,
                itemId,
                itemData,
              );
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemCard(
    AppLocalizations l10n,
    String locale,
    String catKey,
    String itemId,
    Map<String, dynamic> itemData,
  ) {
    final owned = _scoreService.ownsItem(itemId);
    final equipped = _scoreService.getEquipped(catKey) == itemId;
    final price = itemData['price'] as int? ?? 0;

    final rawName = itemData['name'] as String? ?? '';
    final rawDesc = itemData['description'] as String? ?? '';
    final name = ItemTranslations.getName(itemId, locale, rawName);
    final desc = ItemTranslations.getDescription(itemId, locale, rawDesc);

    final preview = _buildPreview(catKey, itemData);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F3460),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: equipped
              ? GameConstants.successColor
              : const Color(0xFF1E5A96),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Center(child: preview)),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFADB5BD),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          if (equipped)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              decoration: BoxDecoration(
                color: GameConstants.successColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '✅ ${l10n.equipped}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: GameConstants.successColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else if (owned)
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () => _equipItem(catKey, itemId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameConstants.successColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  '🎯 ${l10n.equip}',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            )
          else
            SizedBox(
              height: 32,
              child: ElevatedButton(
                onPressed: () => _buyItem(itemId, catKey, price),
                style: ElevatedButton.styleFrom(
                  backgroundColor: GameConstants.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  price == 0
                      ? '🆓 ${l10n.free}'
                      : '🛒 ${_formatPrice(price)}', // ✅ تنسيق السعر
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ✅ معاينة العنصر حسب النوع
  Widget _buildPreview(String catKey, Map<String, dynamic> itemData) {
    if (catKey == 'character') {
      if (itemData['image'] != null) {
        return Image.asset(
          itemData['image'] as String,
          height: 70,
          fit: BoxFit.contain,
        );
      }

      if (itemData['spritePrefix'] != null) {
        final prefix = itemData['spritePrefix'] as String;
        final path = itemData['spritePath'] as String;
        // ✅ دعم poseMap عشان الأسماء تختلف من pack لـ pack
        final poseMap = itemData['poseMap'] as Map<String, dynamic>? ?? {};
        final idleName = poseMap['idle'] as String? ?? 'idle';
        return Image.asset(
          '$path${prefix}_$idleName.png',
          height: 70,
          fit: BoxFit.contain,
        );
      }

      if (itemData['rig'] != null) {
        final rigType = itemData['rig'] as String? ?? 'human';
        final colorHex = itemData['colorPrimary'] as String? ?? '#0d6efd';
        final color = Color(
          int.parse('FF${colorHex.replaceFirst('#', '')}', radix: 16),
        );

        IconData iconData;
        switch (rigType) {
          case 'car':
            iconData = Icons.directions_car;
            break;
          default:
            iconData = Icons.directions_run;
        }

        return Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, size: 45, color: color),
        );
      }

      return const Icon(Icons.person, size: 50, color: Color(0xFFADB5BD));
    }

    if (catKey == 'skin' && itemData['colorPrimary'] != null) {
      final hex = (itemData['colorPrimary'] as String).replaceFirst('#', '');
      final color = Color(int.parse('FF$hex', radix: 16));
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: itemData['glow'] == true
              ? [
                  BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: itemData['glow'] == true
            ? const Icon(Icons.auto_awesome, color: Colors.white, size: 20)
            : null,
      );
    }

    if (catKey == 'background' &&
        itemData['topColor'] != null &&
        itemData['bottomColor'] != null) {
      final top = itemData['topColor'] as List<int>;
      final bottom = itemData['bottomColor'] as List<int>;
      return Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, top[0], top[1], top[2]),
              Color.fromARGB(255, bottom[0], bottom[1], bottom[2]),
            ],
          ),
        ),
      );
    }

    if (catKey == 'obstacles') {
      final type = itemData['type'] as String? ?? 'cactus';
      IconData iconData;
      switch (type) {
        case 'rocks':
          iconData = Icons.landscape;
          break;
        case 'cars':
          iconData = Icons.directions_car;
          break;
        case 'drones':
          iconData = Icons.flight;
          break;
        default:
          iconData = Icons.park;
      }
      return Icon(iconData, size: 45, color: const Color(0xFFADB5BD));
    }

    if (['particles', 'sounds', 'badge', 'weapons'].contains(catKey)) {
      final emoji = (itemData['name'] as String).split(' ').first;
      return Text(emoji, style: const TextStyle(fontSize: 40));
    }

    if (catKey == 'achievements') {
      final emoji = (itemData['badgeIcon'] as String?) ?? '🏆';
      return Text(emoji, style: const TextStyle(fontSize: 40));
    }

    return const SizedBox(height: 40);
  }
}