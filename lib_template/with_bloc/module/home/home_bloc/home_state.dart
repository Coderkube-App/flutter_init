import 'package:equatable/equatable.dart';

class HomeState extends Equatable {
  final bool isLoading;
  final String? name;

  const HomeState({this.isLoading = false, this.name});

  HomeState copyWith({bool? isLoading, String? name}) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [isLoading, name];
}
