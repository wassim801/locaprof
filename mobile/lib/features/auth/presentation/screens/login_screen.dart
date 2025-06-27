import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> get createState => _LoginScreenState();
}

class Country {
  final String name;
  final String code;

  const Country({required this.name, required this.code});
}

class _LoginScreenState extends State<LoginScreen> {
  static const List<Country> _countries = [
    Country(name: 'Morocco', code: '212'),
    Country(name: 'Algeria', code: '213'),
    Country(name: 'Tunisia', code: '216'),
  ];

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  late String _selectedCountry;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCountry = _countries.first.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              // Country selector
              InkWell(
                onTap: _showCountryPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedCountry,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Phone number input
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefixText: '+${_countries.firstWhere((c) => c.name == _selectedCountry).code} ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: _validatePhoneNumber,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
              ),
              const SizedBox(height: 24),
              // Continue button
              ElevatedButton(
                onPressed: _isLoading ? null : _handlePhoneLogin,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue'),
              ),
              const SizedBox(height: 16),
              // Terms and Conditions
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'By continuing, you agree to our ',
                    style: TextStyle(color: AppTheme.greyColor, fontSize: 12),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Navigate to Terms page
                    },
                    child: Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePhoneLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final countryCode = _countries.firstWhere((c) => c.name == _selectedCountry).code;
    final cleanNumber = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (cleanNumber.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enter a valid phone number'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    final phoneNumber = '+$countryCode$cleanNumber';
    setState(() => _isLoading = true);
    
    HapticFeedback.lightImpact();

    // Simuler un délai de connexion
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
    setState(() => _isLoading = false);
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => CountryPickerSheet(
          countries: _countries,
          selectedCountry: _selectedCountry,
          onCountrySelected: (country) {
            setState(() => _selectedCountry = country);
            Navigator.pop(context);
          },
          scrollController: scrollController,
        ),
      ),
    );
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final cleanNumber = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanNumber.isEmpty) {
      return 'Please enter a valid phone number';
    }
    if (cleanNumber.length < 6) {
      return 'Phone number is too short';
    }
    if (cleanNumber.length > 15) {
      return 'Phone number is too long';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'Phone number can only contain digits';
    }
    return null;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}

class CountryPickerSheet extends StatefulWidget {
  final List<Country> countries;
  final String selectedCountry;
  final Function(String) onCountrySelected;
  final ScrollController scrollController;

  const CountryPickerSheet({
    Key? key,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.scrollController,
  }) : super(key: key);

  @override
  State<CountryPickerSheet> get createState => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<CountryPickerSheet> {
  late TextEditingController _searchController;
  late List<Country> _filteredCountries;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCountries = widget.countries;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries(String query) {
    if (!mounted) return;
    setState(() {
      _filteredCountries = widget.countries.where((country) =>
        country.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    });
  }

  Widget _buildCountryTile(String country) {
    final isSelected = country == widget.selectedCountry;
    final countryData = widget.countries.firstWhere((c) => c.name == country);
    return ListTile(
      title: Text(country),
      subtitle: Text('Code: +${countryData.code}'),
      trailing: isSelected 
        ? Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(Icons.check, color: Theme.of(context).primaryColor),
          ) 
        : null,
      onTap: () => widget.onCountrySelected(country),
      tileColor: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Text(
            'Select your country/region',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search countries',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _filterCountries('');
                    },
                  )
                : null,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: _filterCountries,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              controller: widget.scrollController,
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) => _buildCountryTile(_filteredCountries[index].name),
            ),
          ),
        ],
      ),
    );
  }
}