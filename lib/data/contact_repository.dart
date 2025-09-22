// lib/data/contact_repository.dart
class ContactRepository {
  static final ContactRepository _instance = ContactRepository._internal();
  factory ContactRepository() => _instance;
  ContactRepository._internal();

  final List<Map<String, String>> _savedContacts = [];

  void addContact(String name, String phone, String email) {
    _savedContacts.add({
      'name': name,
      'phone': phone,
      'email': email,
    });
  }

  List<Map<String, String>> get contacts => _savedContacts;
}
