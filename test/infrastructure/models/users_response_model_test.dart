import 'package:flutter_test/flutter_test.dart';
import 'package:random_user/infrastructure/models/users_response_model.dart';

void main() {
  group('UsersResponseModel', () {
    final json = {
      'results': [
        {
          'gender': 'female',
          'name': {'title': 'Ms', 'first': 'Jane', 'last': 'Doe'},
          'location': {
            'street': {'number': 1, 'name': 'Oak Ave'},
            'city': 'Paris',
            'state': 'IDF',
            'country': 'France',
            'postcode': '75001',
          },
          'email': 'jane@example.com',
          'login': {'uuid': 'uuid-1'},
          'phone': '010-1111',
          'cell': '010-2222',
          'picture': {
            'large': 'l1',
            'medium': 'm1',
            'thumbnail': 't1',
          },
          'nat': 'FR',
        },
        {
          'gender': 'male',
          'name': {'title': 'Mr', 'first': 'Bob', 'last': 'Smith'},
          'location': {
            'street': {'number': 2, 'name': 'Pine Rd'},
            'city': 'London',
            'state': 'ENG',
            'country': 'UK',
            'postcode': 'EC1A',
          },
          'email': 'bob@example.com',
          'login': {'uuid': 'uuid-2'},
          'phone': '020-1111',
          'cell': '020-2222',
          'picture': {
            'large': 'l2',
            'medium': 'm2',
            'thumbnail': 't2',
          },
          'nat': 'GB',
        },
      ],
      'info': {
        'seed': 'abc',
        'results': 2,
        'page': 1,
        'version': '1.4',
      },
    };

    test('fromJson parses results + info', () {
      final m = UsersResponseModel.fromJson(json);

      expect(m.users, hasLength(2));
      expect(m.users[0].id, 'uuid-1');
      expect(m.users[0].name.first, 'Jane');
      expect(m.users[1].id, 'uuid-2');
      expect(m.info.seed, 'abc');
      expect(m.info.results, 2);
      expect(m.info.page, 1);
      expect(m.info.version, '1.4');
    });

    test('toEntity returns UsersResponse with domain entities', () {
      final m = UsersResponseModel.fromJson(json);
      final e = m.toEntity();

      expect(e.users, hasLength(2));
      expect(e.users[0].id, 'uuid-1');
      expect(e.users[0].name.first, 'Jane');
      expect(e.info.seed, 'abc');
      expect(e.info.page, 1);
    });
  });
}
