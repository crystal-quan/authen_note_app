import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'user.g.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@endtemplate}
///
@HiveType(typeId: 3)
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
    this.birthday,
    this.phone,
  });

  /// The current user's id.
  @HiveField(0, defaultValue: '')
  final String id;
  // ignore: public_member_api_docs
  @HiveField(1)
  final String? birthday;
  // ignore: public_member_api_docs
  @HiveField(2)
  final int? phone;

  /// The current user's email address.
  final String? email;
  @HiveField(3)

  /// The current user's name (display name).
  @HiveField(4)
  final String? name;

  /// Url for the current user's photo.
  @HiveField(5)
  final String? photo;

  /// Empty user which represents an unauthenticated user.

  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo, birthday, phone];
}
