import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;
  final AddressEntity address;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.website,
    required this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phone, website, address];
}

class AddressEntity extends Equatable {
  final String street;
  final String suite;
  final String city;
  final String zipcode;

  const AddressEntity({
    required this.street,
    required this.suite,
    required this.city,
    required this.zipcode,
  });

  String get fullAddress => '$street, $suite, $city, $zipcode';

  @override
  List<Object?> get props => [street, suite, city, zipcode];
}
