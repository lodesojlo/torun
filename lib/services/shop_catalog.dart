class ShopCatalog {
  // =============================================
  // ✅ Characters (كل الشخصيات - القديمة والجديدة)
  // =============================================
  static const Map<String, Map<String, dynamic>> characters = {
    // ✅ الافتراضي (الشعار)
    'char_default': {
      'name': 'Talvo',
      'price': 0,
      'description': 'الشعار الافتراضي',
      'image': 'assets/images/logo.png',
    },

    // ✅ Rigs القديمة (رسم بالكود)
    'char_man': {
      'name': 'رجل (رسم قديم)',
      'price': 500,
      'description': 'عداء نحيف وسريع',
      'rig': 'human',
      'rigParams': {
        'headRatio': 0.22,
        'torsoRatio': 0.40,
        'legRatio': 0.38,
      },
      'colorPrimary': '#E63946',
      'colorSecondary': '#1D3557',
      'colorSkin': '#FFCDB2',
    },
    'char_child': {
      'name': 'طفل (رسم قديم)',
      'price': 800,
      'description': 'طفل صغير مرح',
      'rig': 'human',
      'rigParams': {
        'headRatio': 0.30,
        'torsoRatio': 0.35,
        'legRatio': 0.35,
      },
      'colorPrimary': '#2A9D8F',
      'colorSecondary': '#E9C46A',
      'colorSkin': '#FFCDB2',
    },
    'char_woman': {
      'name': 'امرأة (رسم قديم)',
      'price': 1200,
      'description': 'عداءة رشيقة',
      'rig': 'human',
      'rigParams': {
        'headRatio': 0.22,
        'torsoRatio': 0.38,
        'legRatio': 0.40,
        'hasSkirt': true,
      },
      'colorPrimary': '#F72585',
      'colorSecondary': '#7209B7',
      'colorSkin': '#FFDBB4',
    },

    // ✅ Kenney Toon Characters 1
    'char_male_person': {
      'name': 'رجل',
      'price': 5000,
      'description': 'رجل عادي',
      'spritePrefix': 'character_malePerson',
      'spritePath': 'assets/images/characters/kenney/male_person/',
      'spriteScale': 1.2,
    },
    'char_female_person': {
      'name': 'امرأة',
      'price': 10000,
      'description': 'امرأة عادية',
      'spritePrefix': 'character_femalePerson',
      'spritePath': 'assets/images/characters/kenney/female_person/',
      'spriteScale': 1.2,
    },
    'char_male_adventurer': {
      'name': 'مغامر',
      'price': 25000,
      'description': 'مغامر شجاع',
      'spritePrefix': 'character_maleAdventurer',
      'spritePath': 'assets/images/characters/kenney/male_adventurer/',
      'spriteScale': 1.2,
    },
    'char_female_adventurer': {
      'name': 'مغامرة',
      'price': 25000,
      'description': 'مغامرة شجاعة',
      'spritePrefix': 'character_femaleAdventurer',
      'spritePath': 'assets/images/characters/kenney/female_adventurer/',
      'spriteScale': 1.2,
    },
    'char_robot': {
      'name': 'روبوت',
      'price': 50000,
      'description': 'روبوت آلي',
      'spritePrefix': 'character_robot',
      'spritePath': 'assets/images/characters/kenney/robot/',
      'spriteScale': 1.1,
    },
    'char_zombie': {
      'name': 'زومبي',
      'price': 75000,
      'description': 'زومبي مخيف',
      'spritePrefix': 'character_zombie',
      'spritePath': 'assets/images/characters/kenney/zombie/',
      'spriteScale': 1.1,
    },

    // ✅ Rigs المميزة (بأسعار عالية)
    'char_car': {
      'name': 'سيارة رياضية',
      'price': 150000,
      'description': 'سيارة بعجلات دوارة',
      'rig': 'car',
      'widthMultiplier': 1.5,
      'heightMultiplier': 0.9,
      'colorPrimary': '#E63946',
      'colorSecondary': '#1D3557',
      'colorSkin': '#000000',
    },
    'char_superhero': {
      'name': 'بطل خارق',
      'price': 500000,
      'description': 'بطل بزي أسود',
      'rig': 'human',
      'rigParams': {
        'headRatio': 0.20,
        'torsoRatio': 0.42,
        'legRatio': 0.38,
      },
      'colorPrimary': '#1A1A1A',
      'colorSecondary': '#0D0D0D',
      'colorSkin': '#FFCDB2',
      'glow': true,
    },

    // ✅ Platformer Pack (الجديدة - بأسعار مليونية)
    'char_platformer_zombie': {
      'name': 'زومبي بلاتفورمر',
      'price': 1000000,
      'description': 'زومبي كلاسيكي',
      'spritePrefix': 'zombie',
      'spritePath': 'assets/images/characters/kenney/platformer/zombie/',
      'spriteScale': 1.3,
      'poseMap': {
        'idle': 'idle',
        'run0': 'walk1',
        'run1': 'walk2',
        'run2': 'walk1',
        'jump': 'jump',
        'duck': 'duck',
        'hurt': 'hurt',
      },
    },
    'char_platformer_player': {
      'name': 'لاعب بلاتفورمر',
      'price': 2500000,
      'description': 'لاعب أساسي',
      'spritePrefix': 'player',
      'spritePath': 'assets/images/characters/kenney/platformer/player/',
      'spriteScale': 1.3,
      'poseMap': {
        'idle': 'idle',
        'run0': 'walk1',
        'run1': 'walk2',
        'run2': 'walk1',
        'jump': 'jump',
        'duck': 'duck',
        'hurt': 'hurt',
      },
    },
    'char_platformer_female': {
      'name': 'امرأة بلاتفورمر',
      'price': 5000000,
      'description': 'امرأة مقاتلة',
      'spritePrefix': 'female',
      'spritePath': 'assets/images/characters/kenney/platformer/female/',
      'spriteScale': 1.3,
      'poseMap': {
        'idle': 'idle',
        'run0': 'walk1',
        'run1': 'walk2',
        'run2': 'walk1',
        'jump': 'jump',
        'duck': 'duck',
        'hurt': 'hurt',
      },
    },
    'char_platformer_adventurer': {
      'name': 'مغامر بلاتفورمر',
      'price': 7500000,
      'description': 'مغامر شجاع',
      'spritePrefix': 'adventurer',
      'spritePath': 'assets/images/characters/kenney/platformer/adventurer/',
      'spriteScale': 1.3,
      'poseMap': {
        'idle': 'idle',
        'run0': 'walk1',
        'run1': 'walk2',
        'run2': 'walk1',
        'jump': 'jump',
        'duck': 'duck',
        'hurt': 'hurt',
      },
    },
    'char_platformer_soldier': {
      'name': 'جندي بلاتفورمر',
      'price': 10000000,
      'description': 'جندي محترف (الأغلى!)',
      'spritePrefix': 'soldier',
      'spritePath': 'assets/images/characters/kenney/platformer/soldier/',
      'spriteScale': 1.3,
      'poseMap': {
        'idle': 'idle',
        'run0': 'walk1',
        'run1': 'walk2',
        'run2': 'walk1',
        'jump': 'jump',
        'duck': 'duck',
        'hurt': 'hurt',
      },
    },
  };

  // =============================================
  // ✅ Skins (المظاهر - طبقة توهج لونية)
  // =============================================
  static const Map<String, Map<String, dynamic>> skins = {
    'skin_classic': {
      'name': '🔵 Talvo Classic',
      'price': 0,
      'description': 'المظهر الأساسي',
      'colorPrimary': '#0d6efd',
      'colorSecondary': '#0b5ed7',
      'glow': false,
    },
    'skin_golden': {
      'name': '🟡 Golden Talvo',
      'price': 100000,
      'description': 'مظهر ذهبي فاخر',
      'colorPrimary': '#ffc107',
      'colorSecondary': '#ff9800',
      'glow': true,
    },
    'skin_neon': {
      'name': '💚 Neon Talvo',
      'price': 250000,
      'description': 'مظهر نيون متوهج',
      'colorPrimary': '#00ff88',
      'colorSecondary': '#00cc66',
      'glow': true,
    },
    'skin_fire': {
      'name': '🔥 Fire Talvo',
      'price': 500000,
      'description': 'مظهر ناري',
      'colorPrimary': '#ff5722',
      'colorSecondary': '#d32f2f',
      'glow': true,
    },
    'skin_ice': {
      'name': '❄️ Ice Talvo',
      'price': 500000,
      'description': 'مظهر ثلجي',
      'colorPrimary': '#00bcd4',
      'colorSecondary': '#0288d1',
      'glow': true,
    },
    'skin_rainbow': {
      'name': '🌈 Rainbow Talvo',
      'price': 2000000,
      'description': 'مظهر قوس قزح (نادر)',
      'colorPrimary': '#ff00ff',
      'colorSecondary': '#00ffff',
      'glow': true,
      'animated': true,
    },
  };

  // =============================================
  // ✅ Backgrounds
  // =============================================
  static const Map<String, Map<String, dynamic>> backgrounds = {
    'bg_day': {
      'name': '☀️ نهار',
      'price': 0,
      'description': 'خلفية نهارية',
      'topColor': [240, 248, 255],
      'bottomColor': [247, 247, 247],
      'groundColor': [83, 83, 83],
    },
    'bg_night': {
      'name': '🌙 ليل',
      'price': 50000,
      'description': 'خلفية ليلية',
      'topColor': [10, 15, 40],
      'bottomColor': [20, 30, 60],
      'groundColor': [100, 100, 100],
    },
    'bg_desert': {
      'name': '🏜️ صحراء',
      'price': 100000,
      'description': 'خلفية صحراوية',
      'topColor': [255, 235, 205],
      'bottomColor': [255, 218, 185],
      'groundColor': [194, 154, 108],
    },
    'bg_forest': {
      'name': '🌲 غابة',
      'price': 100000,
      'description': 'خلفية غابة',
      'topColor': [200, 230, 201],
      'bottomColor': [165, 214, 167],
      'groundColor': [76, 175, 80],
    },
    'bg_space': {
      'name': '🚀 فضاء',
      'price': 500000,
      'description': 'خلفية فضائية',
      'topColor': [10, 10, 30],
      'bottomColor': [30, 30, 60],
      'groundColor': [150, 150, 200],
    },
    'bg_ocean': {
      'name': '🌊 محيط',
      'price': 200000,
      'description': 'خلفية محيط',
      'topColor': [179, 229, 252],
      'bottomColor': [129, 212, 250],
      'groundColor': [33, 150, 243],
    },
  };

  // =============================================
  // ✅ Obstacles
  // =============================================
  static const Map<String, Map<String, dynamic>> obstacles = {
    'obs_cactus': {
      'name': '🌵 كاكتوس (افتراضي)',
      'price': 0,
      'description': 'الأعداء الأساسيين',
      'type': 'cactus',
    },
    'obs_rocks': {
      'name': '🪨 صخور',
      'price': 100000,
      'description': 'صخور بأحجام مختلفة',
      'type': 'rocks',
    },
    'obs_platformer': {
      'name': '🦠 وحوش بلاتفورمر',
      'price': 750000,
      'description': 'وحوش من عالم البلاتفورمر',
      'type': 'platformer',
    },
    'obs_cars': {
      'name': '🚗 سيارات',
      'price': 250000,
      'description': 'سيارات مسرعة',
      'type': 'cars',
    },
    'obs_drones': {
      'name': '🛸 طائرات بدون طيار',
      'price': 500000,
      'description': 'طائرات بدون طيار',
      'type': 'drones',
    },
  };

  // =============================================
  // ✅ Particles
  // =============================================
  static const Map<String, Map<String, dynamic>> particles = {
    'particles_none': {
      'name': '❌ بدون مؤثرات',
      'price': 0,
      'description': 'بدون مؤثرات بصرية',
    },
    'particles_stars': {
      'name': '⭐ نجوم',
      'price': 50000,
      'description': 'نجوم متلألئة',
    },
    'particles_fire': {
      'name': '🔥 لهب',
      'price': 100000,
      'description': 'لهب متصاعد',
    },
    'particles_snow': {
      'name': '❄️ ثلج',
      'price': 100000,
      'description': 'ثلج متساقط',
    },
    'particles_bubbles': {
      'name': '🫧 فقاعات',
      'price': 80000,
      'description': 'فقاعات صاعدة',
    },
    'particles_lightning': {
      'name': '⚡ برق',
      'price': 250000,
      'description': 'برق عشوائي',
    },
  };

  // =============================================
  // ✅ Sounds
  // =============================================
  static const Map<String, Map<String, dynamic>> sounds = {
    'sounds_default': {
      'name': '🔊 افتراضي',
      'price': 0,
      'description': 'أصوات اللعبة الأساسية',
    },
    'sounds_classical': {
      'name': '🎻 كلاسيكي',
      'price': 100000,
      'description': 'أصوات كلاسيكية',
    },
    'sounds_arcade': {
      'name': '🎮 أركيد',
      'price': 200000,
      'description': 'أصوات أركيد 8-bit',
    },
    'sounds_synth': {
      'name': '🎹 سينث',
      'price': 400000,
      'description': 'أصوات synthwave',
    },
  };

  // =============================================
  // ✅ Badges
  // =============================================
  static const Map<String, Map<String, dynamic>> badges = {
    'badge_rookie': {
      'name': '🥉 مبتدئ',
      'price': 0,
      'description': 'أول لعبة',
    },
    'badge_pro': {
      'name': '🥈 محترف',
      'price': 100000,
      'description': 'لعبت 10 مرات',
    },
    'badge_master': {
      'name': '🥇 خبير',
      'price': 500000,
      'description': 'وصلت لـ 100 ثانية',
    },
    'badge_legend': {
      'name': '👑 أسطورة',
      'price': 2000000,
      'description': 'وصلت لـ 300 ثانية',
    },
    'badge_god': {
      'name': '⚡ إله',
      'price': 10000000,
      'description': 'وصلت لـ 1000 ثانية',
    },
  };

  // =============================================
  // ✅ Weapons
  // =============================================
  static const Map<String, Map<String, dynamic>> weapons = {
    'weapon_none': {
      'name': '❌ بدون سلاح',
      'price': 0,
      'description': 'بدون سلاح (الوضع الأساسي)',
      'damage': 0,
      'fireRate': 0,
    },
    'weapon_pistol': {
      'name': '🔫 مسدس',
      'price': 50000,
      'description': 'مسدس بسيط - طلقة واحدة',
      'damage': 1,
      'fireRate': 500,
      'bulletColor': '#ffff00',
      'bulletSpeed': 15,
    },
    'weapon_rifle': {
      'name': '🔫 رشاش',
      'price': 150000,
      'description': 'رشاش سريع - طلقات متتالية',
      'damage': 1,
      'fireRate': 150,
      'bulletColor': '#ff6600',
      'bulletSpeed': 20,
    },
    'weapon_shotgun': {
      'name': '💥 شوزن',
      'price': 400000,
      'description': 'شوزن - 3 طلقات مع بعض',
      'damage': 2,
      'fireRate': 700,
      'bulletColor': '#ff0000',
      'bulletSpeed': 18,
      'spread': 3,
    },
    'weapon_rocket': {
      'name': '🚀 صاروخ',
      'price': 2000000,
      'description': 'صاروخ قوي - يدمر أي عدو',
      'damage': 5,
      'fireRate': 1200,
      'bulletColor': '#ff00ff',
      'bulletSpeed': 12,
      'explosion': true,
    },
    'weapon_laser': {
      'name': '⚡ ليزر',
      'price': 1000000,
      'description': 'ليزر مستمر',
      'damage': 1,
      'fireRate': 100,
      'bulletColor': '#00ffff',
      'bulletSpeed': 30,
    },
  };

  // =============================================
  // ✅ Weapon Achievements
  // =============================================
  static const Map<String, Map<String, dynamic>> weaponAchievements = {
    'ach_first_kill': {
      'name': '🥇 أول قتلة',
      'description': 'اقتل أول عدو',
      'requirement': {'type': 'kills', 'value': 1},
      'rewardCoins': 20000,
      'badgeIcon': '🥇',
    },
    'ach_hunter': {
      'name': '🎯 صياد',
      'description': 'اقتل 50 عدو',
      'requirement': {'type': 'kills', 'value': 50},
      'rewardCoins': 200000,
      'badgeIcon': '🎯',
    },
    'ach_sniper': {
      'name': '🎖️ قناص',
      'description': 'اقتل 200 عدو',
      'requirement': {'type': 'kills', 'value': 200},
      'rewardCoins': 1000000,
      'badgeIcon': '🎖️',
    },
    'ach_shooter': {
      'name': '💥 رامي',
      'description': 'أطلق 500 طلقة',
      'requirement': {'type': 'bullets', 'value': 500},
      'rewardCoins': 500000,
      'badgeIcon': '💥',
    },
    'ach_terminator': {
      'name': '⚡ مدمّر',
      'description': 'اقتل 100 عدو في جلسة واحدة',
      'requirement': {'type': 'kills_in_game', 'value': 100},
      'rewardCoins': 3000000,
      'badgeIcon': '⚡',
    },
  };

  // =============================================
  // ✅ All Categories
  // =============================================
  static const Map<String, Map<String, dynamic>> allCategories = {
    'character': {'name': '🎭 الشخصيات', 'items': characters},
    'skin': {'name': '🎨 المظاهر', 'items': skins},
    'background': {'name': '🌈 الخلفيات', 'items': backgrounds},
    'obstacles': {'name': '🌟 الأعداء', 'items': obstacles},
    'particles': {'name': '✨ المؤثرات', 'items': particles},
    'sounds': {'name': '🎵 الأصوات', 'items': sounds},
    'badge': {'name': '🏆 الشارات', 'items': badges},
    'weapons': {'name': '🔫 الأسلحة', 'items': weapons},
    'achievements': {'name': '🏆 الإنجازات', 'items': weaponAchievements},
  };

  // =============================================
  // ✅ Helpers
  // =============================================

  static Map<String, dynamic>? getItem(String itemId) {
    for (final catData in allCategories.values) {
      final items = catData['items'] as Map<String, Map<String, dynamic>>;
      if (items.containsKey(itemId)) {
        return items[itemId];
      }
    }
    return null;
  }

  static String? getCategory(String itemId) {
    for (final entry in allCategories.entries) {
      final items = entry.value['items'] as Map<String, Map<String, dynamic>>;
      if (items.containsKey(itemId)) {
        return entry.key;
      }
    }
    return null;
  }
}