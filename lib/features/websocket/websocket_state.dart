import 'package:equatable/equatable.dart';

class LifeCounterUpdateState extends Equatable {
  const LifeCounterUpdateState({required this.score});

  final int score;

  LifeCounterUpdateState copyWith({int? score}) {
    return LifeCounterUpdateState(score: score ?? this.score);
  }

  @override
  List<Object?> get props => [score];
}
