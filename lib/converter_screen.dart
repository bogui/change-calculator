import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Fixed exchange rate: 1 EUR = 1.95583 BGN (Bulgaria's official transition rate)
const double _exchangeRate = 1.95583;

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _totalAmountController = TextEditingController();
  final TextEditingController _amountGivenController = TextEditingController();

  /// Main working currency: true = EUR, false = BGN
  bool _mainCurrencyIsEur = true;

  /// Override flags: null = use main currency, true = EUR, false = BGN
  bool? _totalAmountCurrencyOverride;
  bool? _amountGivenCurrencyOverride;

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _totalAmountController.addListener(_debouncedUpdate);
    _amountGivenController.addListener(_debouncedUpdate);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _totalAmountController.removeListener(_debouncedUpdate);
    _amountGivenController.removeListener(_debouncedUpdate);
    _totalAmountController.dispose();
    _amountGivenController.dispose();
    super.dispose();
  }

  void _debouncedUpdate() {
    // Cancel any pending update
    _debounceTimer?.cancel();
    // Only rebuild after user stops typing for 400ms
    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {});
      }
    });
  }

  /// Checks if there are any values to clear
  bool _hasValuesToClear() {
    final hasText =
        _totalAmountController.text.isNotEmpty ||
        _amountGivenController.text.isNotEmpty;
    final hasOverrides =
        _totalAmountCurrencyOverride != null ||
        _amountGivenCurrencyOverride != null;
    final isNotDefaultCurrency = !_mainCurrencyIsEur;
    return hasText || hasOverrides || isNotDefaultCurrency;
  }

  /// Resets all fields to their default values
  void _resetAllFields() {
    _totalAmountController.clear();
    _amountGivenController.clear();
    setState(() {
      _mainCurrencyIsEur = true;
      _totalAmountCurrencyOverride = null;
      _amountGivenCurrencyOverride = null;
    });
  }

  /// Gets the effective currency for total amount field
  bool _getTotalAmountCurrency() =>
      _totalAmountCurrencyOverride ?? _mainCurrencyIsEur;

  /// Gets the effective currency for amount given field
  bool _getAmountGivenCurrency() =>
      _amountGivenCurrencyOverride ?? _mainCurrencyIsEur;

  /// Converts EUR to BGN
  double _convertEurToBgn(double eur) => eur * _exchangeRate;

  /// Converts BGN to EUR
  double _convertBgnToEur(double bgn) => bgn / _exchangeRate;

  /// Parses a string to double, returns null if invalid
  double? _parseAmount(String? value) {
    if (value == null || value.isEmpty) return null;
    final parsed = double.tryParse(value);
    return parsed;
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _parseAmount(_totalAmountController.text);
    final amountGiven = _parseAmount(_amountGivenController.text);

    final totalAmountCurrencyIsEur = _getTotalAmountCurrency();
    final amountGivenCurrencyIsEur = _getAmountGivenCurrency();

    // Calculate total amount in other currency
    double? totalInOtherCurrency;
    if (totalAmount != null) {
      if (totalAmountCurrencyIsEur) {
        totalInOtherCurrency = _convertEurToBgn(totalAmount);
      } else {
        totalInOtherCurrency = _convertBgnToEur(totalAmount);
      }
    }

    // Calculate change
    // First, convert both to the same currency (use total amount currency)
    double? changeInEur;
    double? changeInBgn;
    if (totalAmount != null && amountGiven != null) {
      double totalAmountInEur;
      double amountGivenInEur;

      // Convert total amount to EUR
      if (totalAmountCurrencyIsEur) {
        totalAmountInEur = totalAmount;
      } else {
        totalAmountInEur = _convertBgnToEur(totalAmount);
      }

      // Convert amount given to EUR
      if (amountGivenCurrencyIsEur) {
        amountGivenInEur = amountGiven;
      } else {
        amountGivenInEur = _convertBgnToEur(amountGiven);
      }

      // Calculate change in EUR
      changeInEur = amountGivenInEur - totalAmountInEur;

      // Convert change to BGN
      changeInBgn = _convertEurToBgn(changeInEur);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('EUR-BGN Converter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear all fields',
            onPressed: _hasValuesToClear() ? _resetAllFields : null,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Currency Switch Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Working Currency',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '1.95583 BGN/EUR',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'BGN',
                            style: TextStyle(
                              color: !_mainCurrencyIsEur
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                              fontWeight: !_mainCurrencyIsEur
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Switch(
                            value: _mainCurrencyIsEur,
                            onChanged: (value) {
                              setState(() {
                                _mainCurrencyIsEur = value;
                                // Reset overrides if they match the new main currency (no override needed)
                                if (_totalAmountCurrencyOverride == value) {
                                  _totalAmountCurrencyOverride = null;
                                }
                                if (_amountGivenCurrencyOverride == value) {
                                  _amountGivenCurrencyOverride = null;
                                }
                              });
                            },
                          ),
                          Text(
                            'EUR',
                            style: TextStyle(
                              color: _mainCurrencyIsEur
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                              fontWeight: _mainCurrencyIsEur
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Total Amount Input Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                'BGN',
                                style: TextStyle(
                                  color: !_getTotalAmountCurrency()
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  fontWeight: !_getTotalAmountCurrency()
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Switch(
                                value: _getTotalAmountCurrency(),
                                onChanged: (value) {
                                  setState(() {
                                    _totalAmountCurrencyOverride = value;
                                  });
                                },
                              ),
                              Text(
                                'EUR',
                                style: TextStyle(
                                  color: _getTotalAmountCurrency()
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  fontWeight: _getTotalAmountCurrency()
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _totalAmountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter total amount',
                          suffixText: _getTotalAmountCurrency() ? 'EUR' : 'BGN',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Amount Given Input Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Amount Given',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Row(
                            children: [
                              Text(
                                'BGN',
                                style: TextStyle(
                                  color: !_getAmountGivenCurrency()
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  fontWeight: !_getAmountGivenCurrency()
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                              Switch(
                                value: _getAmountGivenCurrency(),
                                onChanged: (value) {
                                  setState(() {
                                    _amountGivenCurrencyOverride = value;
                                  });
                                },
                              ),
                              Text(
                                'EUR',
                                style: TextStyle(
                                  color: _getAmountGivenCurrency()
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                  fontWeight: _getAmountGivenCurrency()
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8.0),
                      TextField(
                        controller: _amountGivenController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}'),
                          ),
                        ],
                        decoration: InputDecoration(
                          hintText: 'Enter amount given',
                          suffixText: _getAmountGivenCurrency() ? 'EUR' : 'BGN',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Results Card - extracted to separate widget for performance
              _ResultsCard(
                totalInOtherCurrency: totalInOtherCurrency,
                changeInEur: changeInEur,
                changeInBgn: changeInBgn,
                totalAmountCurrencyIsEur: totalAmountCurrencyIsEur,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Separate widget for results card to minimize rebuilds
class _ResultsCard extends StatelessWidget {
  const _ResultsCard({
    required this.totalInOtherCurrency,
    required this.changeInEur,
    required this.changeInBgn,
    required this.totalAmountCurrencyIsEur,
  });

  final double? totalInOtherCurrency;
  final double? changeInEur;
  final double? changeInBgn;
  final bool totalAmountCurrencyIsEur;

  String _formatCurrency(double? value) {
    if (value == null) return '0.00';
    return value.toStringAsFixed(2);
  }

  Widget _buildResultRow(
    BuildContext context,
    String label,
    String value,
    String currency, {
    bool isChange = false,
  }) {
    final double? numericValue = double.tryParse(value);
    final bool isNegative = numericValue != null && numericValue < 0;
    final bool isPositive = numericValue != null && numericValue > 0;

    Color? valueColor;
    if (isChange) {
      if (isNegative) {
        valueColor = Theme.of(context).colorScheme.error;
      } else if (isPositive) {
        valueColor = Theme.of(context).colorScheme.primary;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        Text(
          '$value $currency',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Results',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Total in other currency
            _buildResultRow(
              context,
              'Total Amount in ${totalAmountCurrencyIsEur ? 'BGN' : 'EUR'}',
              _formatCurrency(totalInOtherCurrency),
              totalAmountCurrencyIsEur ? 'BGN' : 'EUR',
            ),
            const SizedBox(height: 12.0),

            const Divider(),
            const SizedBox(height: 12.0),

            // Change in EUR (always shown)
            _buildResultRow(
              context,
              'Change in EUR',
              _formatCurrency(changeInEur),
              'EUR',
              isChange: true,
            ),
            const SizedBox(height: 12.0),

            // Change in BGN (always shown)
            _buildResultRow(
              context,
              'Change in BGN',
              _formatCurrency(changeInBgn),
              'BGN',
              isChange: true,
            ),
          ],
        ),
      ),
    );
  }
}
