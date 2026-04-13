import 'package:granix/features/carga/domain/carga_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CargaMemoryRepository {
  CargaMemoryRepository._();

  static const String _storageKey = 'granix_cargas';
  static final List<CargaModel> _cargas = [];

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_storageKey) ?? [];

    _cargas
      ..clear()
      ..addAll(rawList.map(CargaModel.fromJson));
  }

  static List<CargaModel> getAll() {
    return List.unmodifiable(_cargas);
  }

  static Future<void> add(CargaModel carga) async {
    _cargas.insert(0, carga);
    await _persist();
  }

  static Future<void> removeAt(int index) async {
    if (index >= 0 && index < _cargas.length) {
      _cargas.removeAt(index);
      await _persist();
    }
  }

  static Future<void> clear() async {
    _cargas.clear();
    await _persist();
  }

  static Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _cargas.map((e) => e.toJson()).toList();
    await prefs.setStringList(_storageKey, data);
  }
}
