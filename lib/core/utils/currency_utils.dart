import 'package:intl/intl.dart';

/// Currency formatting & data.
class CurrencyUtils {
  CurrencyUtils._();

  /// Supported currencies.
  static const List<CurrencyInfo> currencies = [
    CurrencyInfo(code: 'USD', symbol: '\$', name: 'US Dollar'),
    CurrencyInfo(code: 'EUR', symbol: '€', name: 'Euro'),
    CurrencyInfo(code: 'GBP', symbol: '£', name: 'British Pound'),
    CurrencyInfo(code: 'CAD', symbol: 'CA\$', name: 'Canadian Dollar'),
    CurrencyInfo(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar'),
    CurrencyInfo(code: 'JPY', symbol: '¥', name: 'Japanese Yen'),
    CurrencyInfo(code: 'CNY', symbol: '¥', name: 'Chinese Yuan'),
    CurrencyInfo(code: 'INR', symbol: '₹', name: 'Indian Rupee'),
    CurrencyInfo(code: 'BRL', symbol: 'R\$', name: 'Brazilian Real'),
    CurrencyInfo(code: 'MXN', symbol: 'MX\$', name: 'Mexican Peso'),
    CurrencyInfo(code: 'KRW', symbol: '₩', name: 'South Korean Won'),
    CurrencyInfo(code: 'TRY', symbol: '₺', name: 'Turkish Lira'),
    CurrencyInfo(code: 'PLN', symbol: 'zł', name: 'Polish Zloty'),
    CurrencyInfo(code: 'UAH', symbol: '₴', name: 'Ukrainian Hryvnia'),
    CurrencyInfo(code: 'SEK', symbol: 'kr', name: 'Swedish Krona'),
    CurrencyInfo(code: 'CHF', symbol: 'CHF', name: 'Swiss Franc'),
  ];

  /// Format a monetary value with the given currency code.
  static String format(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(
      symbol: symbolFor(currencyCode),
      decimalDigits: currencyCode == 'JPY' || currencyCode == 'KRW' ? 0 : 2,
    );
    return formatter.format(amount);
  }

  /// Get the symbol for a currency code.
  static String symbolFor(String code) {
    return currencies
        .firstWhere(
          (c) => c.code == code,
          orElse: () => currencies.first,
        )
        .symbol;
  }
}

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;

  const CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
  });
}
