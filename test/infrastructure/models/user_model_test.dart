import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/infrastructure/models/user_model.dart';

void main() {
  group('UserModel', () {
    final json = {
      'gender': 'male',
      'name': {
        'title': 'Mr',
        'first': 'John',
        'last': 'Doe',
      },
      'location': {
        'street': {'number': 1234, 'name': 'Main St'},
        'city': 'Anytown',
        'state': 'CA',
        'country': 'USA',
        'postcode': '12345',
      },
      'email': 'john.doe@example.com',
      'login': {'uuid': 'abc-123'},
      'phone': '010-1234',
      'cell': '010-5678',
      'picture': {
        'large': 'https://example.com/large.jpg',
        'medium': 'https://example.com/medium.jpg',
        'thumbnail': 'https://example.com/thumb.jpg',
      },
      'nat': 'US',
    };

    test('fromJson parses all fields', () {
      final m = UserModel.fromJson(json);

      expect(m.id, 'abc-123');
      expect(m.gender, 'male');
      expect(m.name.title, 'Mr');
      expect(m.name.first, 'John');
      expect(m.name.last, 'Doe');
      expect(m.email, 'john.doe@example.com');
      expect(m.phone, '010-1234');
      expect(m.cell, '010-5678');
      expect(m.picture.large, 'https://example.com/large.jpg');
      expect(m.location.street.number, 1234);
      expect(m.location.street.name, 'Main St');
      expect(m.location.city, 'Anytown');
      expect(m.location.country, 'USA');
      expect(m.nat, 'US');
    });

    test('toJson round-trips through fromJson', () {
      final original = UserModel.fromJson(json);
      final roundTripped = UserModel.fromJson(original.toJson());

      expect(roundTripped.id, original.id);
      expect(roundTripped.gender, original.gender);
      expect(roundTripped.name.first, original.name.first);
      expect(roundTripped.name.last, original.name.last);
      expect(roundTripped.email, original.email);
      expect(roundTripped.location.city, original.location.city);
      expect(roundTripped.picture.medium, original.picture.medium);
    });

    test('fromJson with missing fields uses dynParser defaults', () {
      final partial = <String, dynamic>{
        'name': {'first': 'Jane', 'last': 'Doe'},
        'login': {'uuid': 'xyz'},
      };
      final m = UserModel.fromJson(partial);

      expect(m.id, 'xyz');
      expect(m.name.first, 'Jane');
      expect(m.email, '');
      expect(m.gender, '');
      expect(m.picture.medium, '');
    });

    test('toEntity maps to User domain entity', () {
      final m = UserModel.fromJson(json);
      final e = m.toEntity();

      expect(e.id, 'abc-123');
      expect(e.name.first, 'John');
      expect(e.email, 'john.doe@example.com');
      expect(e.location.street.number, 1234);
    });
  });
}
