import 'package:meta/meta.dart';

@immutable
abstract class MyRequestsEvent {}

class FetchMyRequests extends MyRequestsEvent {}
