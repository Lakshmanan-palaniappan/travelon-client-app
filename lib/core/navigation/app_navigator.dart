import 'package:flutter/material.dart';

/// Global navigator key used to access navigation outside of widget context.
///
/// Useful for:
/// - Navigation from services or blocs
/// - Showing dialogs/snackbars without BuildContext
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();