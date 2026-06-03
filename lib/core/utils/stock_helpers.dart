// ─── Stock & Date Helpers ─────────────────────────────────────────────────────
//
// Centralized helper functions for stock validation, expiry date display,
// and decimal quantity control.

/// Sentinel date used internally when expiry tracking is disabled.
/// Any date where year >= 2090 is treated as "No Expiry Set".
///
/// TODO(future): When Batches/SaleItems columns are migrated from integer to
/// real (double) for decimal quantity support, add a `validateDecimalQty`
/// helper here and remove the decimal-blocking UI in the POS screen.
const int _kNoExpiryYear = 2090;

/// Returns true if the given [date] is a dummy/sentinel expiry date
/// (i.e. expiry tracking was disabled and DateTime(2099) was stored).
bool isDummyExpiry(DateTime date) => date.year >= _kNoExpiryYear;

/// Returns a display string for an expiry date.
/// If the date is a dummy sentinel, returns null (caller should hide it).
String? formatExpiryForDisplay(DateTime? date) {
  if (date == null) return null;
  if (isDummyExpiry(date)) return null;
  // Format: MMM yyyy  e.g. "Jun 2026"
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[date.month - 1]} ${date.year}';
}

/// Returns true if [stockLevel] is below [minStock] and stock-tracking
/// features are enabled.
///
/// [stockTrackingEnabled] — Master switch (from setting `pos_block_oos`)
/// [showLowStockBadge]    — From setting `form_show_min_stock`
bool shouldShowLowStockBadge({
  required int stockLevel,
  required int minStock,
  required bool stockTrackingEnabled,
  required bool showLowStockBadge,
}) {
  if (!stockTrackingEnabled) return false;
  if (!showLowStockBadge) return false;
  return stockLevel < minStock;
}

/// Returns true if the POS should block a sale because stock is zero.
/// Only active when [posBlockOOS] setting is true.
bool shouldBlockOutOfStock({
  required int available,
  required bool posBlockOOS,
}) {
  return posBlockOOS && available <= 0;
}
