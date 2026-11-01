import 'dart:math' as math;
import 'package:flutter/material.dart';

/// الواجهة الأساسية لأي هيكل عظمي للشخصية
/// كل هيكل بيوفر update() للحركة و draw() للرسم
abstract class CharacterRig {
  void update({
    required double runPhase,
    required double jumpPhase,
    required bool isJumping,
    required bool isDucking,
    required bool isDead,
  });

  void draw(
    Canvas canvas,
    Rect bounds,
    Color primaryColor,
    Color secondaryColor,
    Color skinColor,
  );
}

/// هيكل بشري كامل (رأس + جسم + ذراعين + رجلين)
/// - انتقالات سلسة عبر Linear Interpolation (Lerp)
/// - Paint objects مخزنة مسبقاً (تحسين أداء ضخم)
/// - ظل أرضي تلقائي
/// - دعم تنورة اختيارية (للنساء)
class HumanRig extends CharacterRig {
  final double headRatio;
  final double torsoRatio;
  final double legRatio;
  final bool hasSkirt;
  final double lerpSpeed;

  // القيم الحالية (بتتحرك تدريجياً)
  double _leftArmAngle = 0;
  double _rightArmAngle = 0;
  double _leftLegAngle = 0;
  double _rightLegAngle = 0;
  double _bodyLean = 0;
  double _bodyBob = 0;
  double _headTilt = 0;

  // القيم المستهدفة (بتتحدد كل frame)
  double _tLeftArm = 0;
  double _tRightArm = 0;
  double _tLeftLeg = 0;
  double _tRightLeg = 0;
  double _tBodyLean = 0;
  double _tBodyBob = 0;
  double _tHeadTilt = 0;

  // ✅ Paint objects مخزنة (لا تخصيص جديد في كل frame)
  final Paint _limbPaint = Paint();
  final Paint _torsoPaint = Paint();
  final Paint _headPaint = Paint();
  final Paint _eyePaint = Paint()..color = Colors.black87;
  final Paint _smilePaint = Paint()
    ..color = Colors.black87
    ..style = PaintingStyle.stroke;
  final Paint _shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.15);

  HumanRig({
    this.headRatio = 0.24,
    this.torsoRatio = 0.38,
    this.legRatio = 0.38,
    this.hasSkirt = false,
    this.lerpSpeed = 0.35,
  });

  @override
  void update({
    required double runPhase,
    required double jumpPhase,
    required bool isJumping,
    required bool isDucking,
    required bool isDead,
  }) {
    if (isDead) {
      _tLeftArm = 1.5;
      _tRightArm = -1.5;
      _tLeftLeg = 0.8;
      _tRightLeg = -0.8;
      _tBodyLean = 1.2;
      _tBodyBob = 0;
      _tHeadTilt = 0.5;
    } else if (isJumping) {
      _tLeftArm = -1.0 + math.sin(jumpPhase) * 0.15;
      _tRightArm = -1.0 + math.cos(jumpPhase) * 0.15;
      _tLeftLeg = 0.6;
      _tRightLeg = -0.4;
      _tBodyLean = -0.2;
      _tBodyBob = 0;
      _tHeadTilt = -0.1;
    } else if (isDucking) {
      _tLeftArm = 0.9;
      _tRightArm = -0.9;
      _tLeftLeg = 1.3;
      _tRightLeg = -1.3;
      _tBodyLean = 0.6;
      _tBodyBob = 0;
      _tHeadTilt = 0.4;
    } else {
      final s = math.sin(runPhase);
      final c = math.cos(runPhase * 2);
      _tLeftArm = s * 0.9;
      _tRightArm = -s * 0.9;
      _tLeftLeg = -s * 1.0;
      _tRightLeg = s * 1.0;
      _tBodyLean = 0.1;
      _tBodyBob = c * 1.8;
      _tHeadTilt = s * 0.05;
    }

    // ✅ انتقال سلس بدل الانتقال الفوري (يخلي الحركة طبيعية جداً)
    _leftArmAngle += (_tLeftArm - _leftArmAngle) * lerpSpeed;
    _rightArmAngle += (_tRightArm - _rightArmAngle) * lerpSpeed;
    _leftLegAngle += (_tLeftLeg - _leftLegAngle) * lerpSpeed;
    _rightLegAngle += (_tRightLeg - _rightLegAngle) * lerpSpeed;
    _bodyLean += (_tBodyLean - _bodyLean) * lerpSpeed;
    _bodyBob += (_tBodyBob - _bodyBob) * lerpSpeed;
    _headTilt += (_tHeadTilt - _headTilt) * lerpSpeed;
  }

  @override
  void draw(
    Canvas canvas,
    Rect bounds,
    Color primary,
    Color secondary,
    Color skin,
  ) {
    final w = bounds.width;
    final h = bounds.height;
    final cx = bounds.center.dx;

    final headD = h * headRatio;
    final torsoH = h * torsoRatio;
    final legH = h * legRatio;
    final torsoW = w * 0.55;
    final torsoTop = bounds.top + headD + _bodyBob * 0.3;
    final torsoBottom = torsoTop + torsoH;
    final torsoLeft = cx - torsoW / 2;

    // ✅ ظل أرضي
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx, bounds.bottom - 2),
        width: w * 0.7,
        height: h * 0.08,
      ),
      _shadowPaint,
    );

    // دوران الجسم
    canvas.save();
    canvas.translate(cx, torsoBottom);
    canvas.rotate(_bodyLean);
    canvas.translate(-cx, -torsoBottom);

    // ✅ الساقان
    _limbPaint.color = secondary;
    _drawLimb(
      canvas,
      pivot: Offset(cx - torsoW * 0.28, torsoBottom - 2),
      length: legH,
      width: w * 0.14,
      angle: _leftLegAngle,
    );
    _drawLimb(
      canvas,
      pivot: Offset(cx + torsoW * 0.28, torsoBottom - 2),
      length: legH,
      width: w * 0.14,
      angle: _rightLegAngle,
    );

    // ✅ الجسم
    _torsoPaint.color = primary;
    final torsoRect = Rect.fromLTWH(torsoLeft, torsoTop, torsoW, torsoH);
    canvas.drawRRect(
      RRect.fromRectAndRadius(torsoRect, Radius.circular(w * 0.12)),
      _torsoPaint,
    );

    // ✅ تنورة (للنساء)
    if (hasSkirt) {
      final skirtPath = Path()
        ..moveTo(torsoLeft - w * 0.05, torsoBottom - torsoH * 0.3)
        ..lineTo(torsoLeft + torsoW + w * 0.05, torsoBottom - torsoH * 0.3)
        ..lineTo(torsoLeft + torsoW + w * 0.15, torsoBottom)
        ..lineTo(torsoLeft - w * 0.15, torsoBottom)
        ..close();
      canvas.drawPath(skirtPath, _torsoPaint);
    }

    // ✅ الذراعان
    _limbPaint.color = skin;
    _drawLimb(
      canvas,
      pivot: Offset(torsoLeft + torsoW * 0.1, torsoTop + torsoH * 0.15),
      length: torsoH * 0.85,
      width: w * 0.11,
      angle: _leftArmAngle - _bodyLean,
    );
    _drawLimb(
      canvas,
      pivot: Offset(torsoLeft + torsoW * 0.9, torsoTop + torsoH * 0.15),
      length: torsoH * 0.85,
      width: w * 0.11,
      angle: _rightArmAngle - _bodyLean,
    );

    canvas.restore();

    // ✅ الرأس (خارج دوران الجسم ليبقى مستقيماً)
    _headPaint.color = skin;
    final headCx = cx + math.sin(_headTilt) * headD * 0.15;
    final headCy = bounds.top + headD / 2 + _bodyBob;
    canvas.drawCircle(Offset(headCx, headCy), headD / 2, _headPaint);

    // ✅ العينان
    final eyeR = headD * 0.09;
    canvas.drawCircle(
      Offset(headCx - headD * 0.16, headCy - headD * 0.08),
      eyeR,
      _eyePaint,
    );
    canvas.drawCircle(
      Offset(headCx + headD * 0.16, headCy - headD * 0.08),
      eyeR,
      _eyePaint,
    );

    // ✅ الابتسامة
    _smilePaint.strokeWidth = headD * 0.05;
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(headCx, headCy + headD * 0.15),
        width: headD * 0.4,
        height: headD * 0.3,
      ),
      0,
      math.pi,
      false,
      _smilePaint,
    );
  }

  /// رسم طرف واحد (ذراع أو رجل) - يستخدم Paint مخزن
  void _drawLimb(
    Canvas canvas, {
    required Offset pivot,
    required double length,
    required double width,
    required double angle,
  }) {
    canvas.save();
    canvas.translate(pivot.dx, pivot.dy);
    canvas.rotate(angle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-width / 2, 0, width, length),
        Radius.circular(width / 2),
      ),
      _limbPaint,
    );
    canvas.restore();
  }
}

/// هيكل سيارة (جسم + عجلات دوارة)
/// - عجلات تدور باستمرار
/// - اهتزاز خفيف للجسم
class CarRig extends CharacterRig {
  double _wheelPhase = 0;
  double _bodyBob = 0;

  // ✅ Paint objects مخزنة
  final Paint _tirePaint = Paint()..color = const Color(0xFF111111);
  final Paint _rimPaint = Paint()..color = const Color(0xFF666666);
  final Paint _spokePaint = Paint()
    ..color = const Color(0xFFAAAAAA)
    ..strokeCap = StrokeCap.round;
  final Paint _bodyPaint = Paint();
  final Paint _roofPaint = Paint();
  final Paint _glassPaint = Paint()..color = const Color(0xFFA8DADC);
  final Paint _lightPaint = Paint()..color = const Color(0xFFFFEB3B);
  final Paint _shadowPaint = Paint()
    ..color = Colors.black.withValues(alpha: 0.15);

  @override
  void update({
    required double runPhase,
    required double jumpPhase,
    required bool isJumping,
    required bool isDucking,
    required bool isDead,
  }) {
    _wheelPhase = isJumping ? jumpPhase * 0.5 : runPhase;
    _bodyBob = math.sin(runPhase * 2) * 1.5;
    if (isDead) {
      _wheelPhase = 0;
      _bodyBob = 5;
    }
  }

  @override
  void draw(
    Canvas canvas,
    Rect bounds,
    Color primary,
    Color secondary,
    Color skin,
  ) {
    final w = bounds.width;
    final h = bounds.height;
    final bodyH = h * 0.45;
    final bodyY = bounds.top + h * 0.35 + _bodyBob;

    // ✅ ظل أرضي
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(bounds.center.dx, bounds.bottom - 2),
        width: w * 0.9,
        height: h * 0.1,
      ),
      _shadowPaint,
    );

    // ✅ العجلات (خلف الجسم)
    _drawWheel(
      canvas,
      Offset(bounds.left + w * 0.22, bodyY + bodyH + h * 0.1),
      h * 0.18,
    );
    _drawWheel(
      canvas,
      Offset(bounds.left + w * 0.78, bodyY + bodyH + h * 0.1),
      h * 0.18,
    );

    // ✅ جسم السيارة
    _bodyPaint.color = primary;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(bounds.left + w * 0.05, bodyY, w * 0.9, bodyH),
        Radius.circular(w * 0.08),
      ),
      _bodyPaint,
    );

    // ✅ السقف
    _roofPaint.color = secondary;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          bounds.left + w * 0.25,
          bodyY - h * 0.22,
          w * 0.5,
          h * 0.25,
        ),
        Radius.circular(w * 0.05),
      ),
      _roofPaint,
    );

    // ✅ الزجاج الأمامي والخلفي
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left + w * 0.29,
        bodyY - h * 0.18,
        w * 0.18,
        h * 0.18,
      ),
      _glassPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        bounds.left + w * 0.53,
        bodyY - h * 0.18,
        w * 0.18,
        h * 0.18,
      ),
      _glassPaint,
    );

    // ✅ المصباح الأمامي
    canvas.drawCircle(
      Offset(bounds.left + w * 0.9, bodyY + bodyH * 0.4),
      w * 0.04,
      _lightPaint,
    );
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, _tirePaint);
    canvas.drawCircle(center, radius * 0.55, _rimPaint);

    _spokePaint.strokeWidth = radius * 0.15;
    for (int i = 0; i < 4; i++) {
      final a = _wheelPhase + i * math.pi / 2;
      canvas.drawLine(
        center,
        center +
            Offset(math.cos(a) * radius * 0.5, math.sin(a) * radius * 0.5),
        _spokePaint,
      );
    }
  }
}