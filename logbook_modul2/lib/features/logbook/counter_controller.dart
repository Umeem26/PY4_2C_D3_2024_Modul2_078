import 'package:shared_preferences/shared_preferences.dart'; // 1. Panggil paketnya

class CounterController {
  int _counter = 0;
  int _step = 1;
  final List<String> _history = [];

  int get value => _counter;
  int get step => _step;
  List<String> get history => _history;

  // --- LOGIKA BARU: PERSISTENCE (Task 3) ---

  String _storageKey = 'counter_general'; 

  // --- LOGIKA BARU: MULTI-USER PERSISTENCE (Homework 1) ---

  // Fungsi Memuat Data (Sekarang butuh parameter Username!)
  Future<void> loadData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    
    _storageKey = 'counter_$username'; 
    
    // Ambil data sesuai kunci unik tersebut
    _counter = prefs.getInt(_storageKey) ?? 0;
  }

  // Fungsi Menyimpan Data
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Simpan ke kunci yang sudah diset di loadData tadi
    await prefs.setInt(_storageKey, _counter);
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    String hour = now.hour.toString().padLeft(2, '0');
    String minute = now.minute.toString().padLeft(2, '0');
    String second = now.second.toString().padLeft(2, '0');
    return "$hour:$minute:$second";
  }

  void _addHistory(String message) {
    String time = _getCurrentTime();
    _history.insert(0, "[$time] $message");
    if (_history.length > 5) {
      _history.removeLast();
    }
  }

  void setStep(int newStep) => _step = newStep;

  void increment() {
    _counter += _step;
    _addHistory("Ditambah $_step (Total: $_counter)");
    _saveData(); // <--- Simpan otomatis setiap nambah
  }

  void decrement() {
    if (_counter >= _step) {
      _counter -= _step;
      _addHistory("Dikurang $_step (Total: $_counter)");
    } else {
      _counter = 0;
      _addHistory("Dikurang mentok ke 0");
    }
    _saveData(); // <--- Simpan otomatis setiap kurang
  }

  void reset() {
    _counter = 0;
    _addHistory("Data di-reset ke 0");
    _saveData(); // <--- Simpan otomatis saat reset
  }
}