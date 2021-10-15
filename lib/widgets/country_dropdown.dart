import 'package:flutter/cupertino.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:vipepeo_app/utils/app_theme.dart';

class CountryDropdownWidget extends StatelessWidget {
  final Function(String country) onCountySelected;
  final String defaultCountry;

  const CountryDropdownWidget(
      {Key key, @required this.onCountySelected, this.defaultCountry})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CountryPickerDropdown(
      initialValue: defaultCountry ?? 'UG',
      isExpanded: true,
      dropdownColor: AppTheme.PrimaryDarkColor,
      itemBuilder: (Country country) {
        return Wrap(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            const SizedBox(width: 8.0),
            Text(
              country.name,
            )
          ],
        );
      },
      onValuePicked: (country) => onCountySelected(country.isoCode),
    );
  }
}
