import 'package:fluent_ui/fluent_ui.dart';

class AppColors {
  final Color backgroundOverlay;
  final Color borderColor;
  final Color cardBackground;
  final Color cardBorder;
  final Color shadowColor;
  final Color textPrimary;
  final Color textSecondary;
  final Color accent;
  final Color iconPrimary;
  final Color playButtonColor;
  final Color micaColor;
  final Color micaBorder;
  final Color hoverBackdropColor;
  final Color hoverButtonBg;
  final Color hoverButtonBorder;

  const AppColors({
    required this.backgroundOverlay,
    required this.borderColor,
    required this.cardBackground,
    required this.cardBorder,
    required this.shadowColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.iconPrimary,
    required this.playButtonColor,
    required this.micaColor,
    required this.micaBorder,
    required this.hoverBackdropColor,
    required this.hoverButtonBg,
    required this.hoverButtonBorder,
  });
}

class AppTheme extends ThemeExtension<AppTheme> {
  final AppColors colors;

  const AppTheme({required this.colors});

  static AppColors lightColors = const AppColors(
    // Make the light theme more legible over light mica/backdrops by
    // using slightly stronger borders, darker hover overlays and a
    // whiter card background so text and subtext remain readable.
    backgroundOverlay: Color(0x66FFFFFF), // Light overlay (40% white)
    borderColor: Color(0xFFDDDDDD), // Slightly stronger light border
    cardBackground: Color(0xFFFFFFFF), // Pure white card background
    cardBorder: Color(0x20000000), // Subtle dark border on cards (12% black)
    shadowColor: Color(0x14000000), // Soft shadow (8% black)
    textPrimary: Colors.black,
    textSecondary: Color(0xFF666666), // Grey (kept readable)
    accent: Color(0xFF60CDFF),
    iconPrimary: Colors.black,
    playButtonColor: Colors.black,
    micaColor: Color(0x33FFFFFF), // stronger mica tint for light mode
    micaBorder: Color(0x22000000), // subtle mica border (black tint)
    // Use dark (black) overlays with low alpha so hover/highlight shows
    // up on light backgrounds instead of being invisible.
    hoverBackdropColor: Color(0x14000000), // ~8% black
    hoverButtonBg: Color(0x0F000000), // ~6% black
    hoverButtonBorder: Color(0x22000000), // ~13% black
  );

  static AppColors darkColors = const AppColors(
    backgroundOverlay: Color(0x4D333333), // Dark overlay
    borderColor: Color(0xFF3A3A3A), // Dark border
    cardBackground: Color(0xFF2B2B2B), // Dark card
    cardBorder: Color(0x33FFFFFF), // White border
    shadowColor: Color(0x4D000000), // Shadow
    textPrimary: Colors.white,
    textSecondary: Color(0xFFCCCCCC), // Light grey
    accent: Color(0xFF60CDFF),
    iconPrimary: Colors.white,
    playButtonColor: Colors.white,
    micaColor: Color(0x22FFFFFF),
    micaBorder: Color(0x33FFFFFF),
    hoverBackdropColor: Color(0x0A000000), // Black with alpha 0.04
    hoverButtonBg: Color(0x19000000), // Black with alpha 0.1
    hoverButtonBorder: Color(0x33FFFFFF), // White with alpha 0.2
  );

  static AppTheme of(BuildContext context) {
    return FluentTheme.of(context).extension<AppTheme>()!;
  }

  @override
  ThemeExtension<AppTheme> copyWith({AppColors? colors}) {
    return AppTheme(colors: colors ?? this.colors);
  }

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) {
    if (other is! AppTheme) return this;
    return AppTheme(
      colors: AppColors(
        backgroundOverlay: Color.lerp(colors.backgroundOverlay, other.colors.backgroundOverlay, t)!,
        borderColor: Color.lerp(colors.borderColor, other.colors.borderColor, t)!,
        cardBackground: Color.lerp(colors.cardBackground, other.colors.cardBackground, t)!,
        cardBorder: Color.lerp(colors.cardBorder, other.colors.cardBorder, t)!,
        shadowColor: Color.lerp(colors.shadowColor, other.colors.shadowColor, t)!,
        textPrimary: Color.lerp(colors.textPrimary, other.colors.textPrimary, t)!,
        textSecondary: Color.lerp(colors.textSecondary, other.colors.textSecondary, t)!,
        accent: Color.lerp(colors.accent, other.colors.accent, t)!,
        iconPrimary: Color.lerp(colors.iconPrimary, other.colors.iconPrimary, t)!,
        playButtonColor: Color.lerp(colors.playButtonColor, other.colors.playButtonColor, t)!,
        micaColor: Color.lerp(colors.micaColor, other.colors.micaColor, t)!,
        micaBorder: Color.lerp(colors.micaBorder, other.colors.micaBorder, t)!,
        hoverBackdropColor: Color.lerp(colors.hoverBackdropColor, other.colors.hoverBackdropColor, t)!,
        hoverButtonBg: Color.lerp(colors.hoverButtonBg, other.colors.hoverButtonBg, t)!,
        hoverButtonBorder: Color.lerp(colors.hoverButtonBorder, other.colors.hoverButtonBorder, t)!,
      ),
    );
  }
}