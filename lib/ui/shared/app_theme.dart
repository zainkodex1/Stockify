import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Stockify Design System
/// One consistent premium palette. Every screen references this — no hardcoded colors.
class AppTheme {
  AppTheme._();

  // ── Core Palette ─────────────────────────────────────────────────────────
  static const Color primaryNavy   = Color(0xFF111827);
  static const Color deepIndigo    = Color(0xFF1E1B4B);
  static const Color royalBlue     = Color(0xFF2563EB);
  static const Color tealAccent    = Color(0xFF14B8A6);

  // ── Status Colors ─────────────────────────────────────────────────────────
  static const Color emeraldSuccess = Color(0xFF10B981);
  static const Color amberWarning   = Color(0xFFF59E0B);
  static const Color redDanger      = Color(0xFFEF4444);

  // ── Backgrounds ───────────────────────────────────────────────────────────
  static const Color appBackground  = Color(0xFFF4F7FB);
  static const Color surface        = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF9FAFB);
  static const Color tableRowHover  = Color(0xFFF1F5F9);
  static const Color selectedRow    = Color(0xFFEFF6FF);  // in-cart / selected
  static const Color inCartRow      = Color(0xFFECFDF5);

  // ── Borders ───────────────────────────────────────────────────────────────
  static const Color border         = Color(0xFFE5E7EB);
  static const Color borderMuted    = Color(0xFFCBD5E1);

  // ── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary    = Color(0xFF111827);
  static const Color textSecondary  = Color(0xFF6B7280);
  static const Color textMuted      = Color(0xFF9CA3AF);
  static const Color textInverted   = Color(0xFFFFFFFF);

  // ── Sidebar ───────────────────────────────────────────────────────────────
  static const Color sidebarBg           = Color(0xFF0F172A);
  static const Color sidebarActive       = Color(0xFF1E293B);
  static const Color sidebarText         = Color(0xFFCBD5E1);
  static const Color sidebarActiveText   = Color(0xFFFFFFFF);
  static const Color sidebarActiveBorder = tealAccent;

  // ── Status surfaces ────────────────────────────────────────────────────────
  static const Color successSurface = Color(0xFFECFDF5);
  static const Color warningSurface = Color(0xFFFFFBEB);
  static const Color dangerSurface  = Color(0xFFFEF2F2);
  static const Color infoSurface    = Color(0xFFEFF6FF);
  static const Color totalSurface   = Color(0xFFEEF2FF);  // total row bg

  // ── Border Radius ─────────────────────────────────────────────────────────
  static const double r4   = 4;
  static const double r6   = 6;
  static const double r8   = 8;
  static const double r10  = 10;
  static const double r12  = 12;
  static const double r16  = 16;
  static const double r20  = 20;
  static const double rPill = 999;

  // ── Gradients ─────────────────────────────────────────────────────────────

  /// POS header & dashboard hero — navy → indigo → blue
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.45, 1.0],
    colors: [primaryNavy, deepIndigo, royalBlue],
  );

  /// Sidebar background — dark slate to deep indigo
  static const LinearGradient sidebarGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.55, 1.0],
    colors: [sidebarBg, primaryNavy, deepIndigo],
  );

  /// Primary CTA — blue to teal (checkout, save, etc.)
  static const LinearGradient primaryButtonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [royalBlue, tealAccent],
  );

  /// Accent CTA — teal to indigo (Used for categories, etc.)
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [tealAccent, deepIndigo],
  );

  /// Success / paid state
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF059669), emeraldSuccess],
  );

  /// Warning / low stock badge
  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [amberWarning, Color(0xFFF97316)],
  );

  /// Danger / delete / cancel
  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFDC2626), redDanger],
  );

  // ── Shadows ───────────────────────────────────────────────────────────────
  /// Soft premium card shadow — use sparingly
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.06),
          blurRadius: 30,
          offset: const Offset(0, 10),
        ),
      ];

  /// Panel divider shadow (right-side cart panel)
  static List<BoxShadow> get panelShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(-4, 0),
        ),
      ];

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: royalBlue,
        secondary: tealAccent,
        surface: surface,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: appBackground,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: border,
        centerTitle: false,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textSecondary, size: 20),
      ),

      // Card
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(r16),
          side: const BorderSide(color: border),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        color: surface,
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r12),
          borderSide: const BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r12),
          borderSide: const BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r12),
          borderSide: const BorderSide(color: royalBlue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(r12),
          borderSide: const BorderSide(color: redDanger),
        ),
        filled: true,
        fillColor: surface,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        labelStyle: const TextStyle(color: textSecondary, fontSize: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
        prefixIconColor: textSecondary,
        isDense: true,
      ),

      // Elevated Button (default — plain blue)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: royalBlue,
          foregroundColor: Colors.white,
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r12)),
          elevation: 0,
          textStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: royalBlue,
          side: const BorderSide(color: royalBlue),
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(r12)),
          textStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: royalBlue,
          textStyle: GoogleFonts.outfit(
              fontWeight: FontWeight.w500, fontSize: 14),
        ),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: royalBlue,
        foregroundColor: Colors.white,
        elevation: 2,
      ),

      // DataTable
      dataTableTheme: DataTableThemeData(
        headingRowColor:
            WidgetStateProperty.all(surfaceVariant),
        headingTextStyle: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: textSecondary,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
        dataRowColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered))
            return tableRowHover;
          return surface;
        }),
        dividerThickness: 1,
        columnSpacing: 16,
        headingRowHeight: 44,
        dataRowMinHeight: 52,
        dataRowMaxHeight: 52,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
          color: border, thickness: 1, space: 1),

      // Text
      textTheme: GoogleFonts.outfitTextTheme().copyWith(
        headlineLarge: GoogleFonts.outfit(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary),
        headlineMedium: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textPrimary),
        titleLarge: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textPrimary),
        titleMedium: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary),
        bodyLarge:
            GoogleFonts.outfit(fontSize: 15, color: textPrimary),
        bodyMedium:
            GoogleFonts.outfit(fontSize: 14, color: textPrimary),
        bodySmall: GoogleFonts.outfit(
            fontSize: 12, color: textSecondary),
        labelLarge: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textPrimary),
      ),
    );
  }
}
