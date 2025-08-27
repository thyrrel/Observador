DropdownButton<AppTheme>(
  value: Provider.of<AppState>(context, listen: false).theme,
  items: AppTheme.values.map((theme) {
    return DropdownMenuItem(
      value: theme,
      child: Text(theme.toString().split('.').last),
    );
  }).toList(),
  onChanged: (newTheme) {
    if (newTheme != null) {
      Provider.of<AppState>(context, listen: false).setTheme(newTheme);
    }
  },
),
