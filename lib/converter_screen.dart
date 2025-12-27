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

  /// true = EUR, false = BGN
  bool _isEurSelected = true;

  @override
  void initState() {
    super.initState();
    _totalAmountController.addListener(_updateCalculations);
    _amountGivenController.addListener(_updateCalculations);
  }

  @override
  void dispose() {
    _totalAmountController.dispose();
    _amountGivenController.dispose();
    super.dispose();
  }

  void _updateCalculations() {
    setState(() {});
  }

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

  /// Formats a number to 2 decimal places for currency display
  String _formatCurrency(double? value) {
    if (value == null) return '0.00';
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _parseAmount(_totalAmountController.text);
    final amountGiven = _parseAmount(_amountGivenController.text);

    // Calculate total amount in other currency
    double? totalInOtherCurrency;
    if (totalAmount != null) {
      if (_isEurSelected) {
        totalInOtherCurrency = _convertEurToBgn(totalAmount);
      } else {
        totalInOtherCurrency = _convertBgnToEur(totalAmount);
      }
    }

    // Calculate change
    double? changeInSelectedCurrency;
    double? changeInOtherCurrency;
    if (totalAmount != null && amountGiven != null) {
      changeInSelectedCurrency = amountGiven - totalAmount;
      if (_isEurSelected) {
        changeInOtherCurrency = _convertEurToBgn(changeInSelectedCurrency);
      } else {
        changeInOtherCurrency = _convertBgnToEur(changeInSelectedCurrency);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('EUR-BGN Converter'), centerTitle: true),
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
                      Text(
                        'Working Currency',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Row(
                        children: [
                          Text(
                            'EUR',
                            style: TextStyle(
                              color: _isEurSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                              fontWeight: _isEurSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          Switch(
                            value: _isEurSelected,
                            onChanged: (value) {
                              setState(() {
                                _isEurSelected = value;
                              });
                            },
                          ),
                          Text(
                            'BGN',
                            style: TextStyle(
                              color: !_isEurSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                              fontWeight: !_isEurSelected
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
                      Text(
                        'Total Amount',
                        style: Theme.of(context).textTheme.titleMedium,
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
                          suffixText: _isEurSelected ? 'EUR' : 'BGN',
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
                      Text(
                        'Amount Given',
                        style: Theme.of(context).textTheme.titleMedium,
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
                          suffixText: _isEurSelected ? 'EUR' : 'BGN',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              // Results Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),

                      // Total in other currency
                      _buildResultRow(
                        context,
                        'Total Amount in ${_isEurSelected ? 'BGN' : 'EUR'}',
                        _formatCurrency(totalInOtherCurrency),
                        _isEurSelected ? 'BGN' : 'EUR',
                      ),
                      const SizedBox(height: 12.0),

                      const Divider(),
                      const SizedBox(height: 12.0),

                      // Change in selected currency
                      _buildResultRow(
                        context,
                        'Change in ${_isEurSelected ? 'EUR' : 'BGN'}',
                        _formatCurrency(changeInSelectedCurrency),
                        _isEurSelected ? 'EUR' : 'BGN',
                        isChange: true,
                      ),
                      const SizedBox(height: 12.0),

                      // Change in other currency
                      _buildResultRow(
                        context,
                        'Change in ${_isEurSelected ? 'BGN' : 'EUR'}',
                        _formatCurrency(changeInOtherCurrency),
                        _isEurSelected ? 'BGN' : 'EUR',
                        isChange: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
}
