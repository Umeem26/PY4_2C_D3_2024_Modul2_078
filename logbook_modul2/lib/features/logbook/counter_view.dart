import 'package:flutter/material.dart';
import 'package:logbook_modul2/features/logbook/counter_controller.dart';
import 'package:logbook_modul2/features/onboarding/onboarding_view.dart';

class CounterView extends StatefulWidget {
  final String username;
  const CounterView({super.key, required this.username});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() async {
    await _controller.loadData(widget.username);
    setState(() {});
  }

  void refresh() => setState(() {});

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Yakin ingin keluar? Sesi Anda akan berakhir."),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingView()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Logbook", style: const TextStyle(fontSize: 14, color: Colors.white70)),
            Text(widget.username, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Reset Data',
            onPressed: () {
               _controller.reset();
               refresh();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Keluar',
            onPressed: _handleLogout,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          // HEADER AREA
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            decoration: const BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Column(
              children: [
                Text(
                  "${_getGreeting()}!",
                  style: const TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                
                // KARTU SKOR
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
                  ),
                  child: Column(
                    children: [
                      const Text("TOTAL HITUNGAN", style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1.5)),
                      const SizedBox(height: 5),
                      Text(
                        '${_controller.value}',
                        style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold, color: Colors.indigo),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // --- KONTROL STEPPER (SLIDER) ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Atur Langkah (Step):", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    // Indikator Angka Step
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(color: Colors.indigo.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Text("${_controller.step}", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Widget Slider Keren
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.indigo,
                    inactiveTrackColor: Colors.indigo.shade100,
                    thumbColor: Colors.indigo,
                    overlayColor: Colors.indigo.withOpacity(0.2),
                    valueIndicatorColor: Colors.indigo,
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 20.0),
                  ),
                  child: Slider(
                    value: _controller.step.toDouble(),
                    min: 1,
                    max: 10, // Maksimal 10 (Sesuai Modul)
                    divisions: 9,
                    label: _controller.step.toString(),
                    onChanged: (val) {
                      _controller.setStep(val.toInt());
                      refresh();
                    },
                  ),
                ),
              ],
            ),
          ),
          // --------------------------------

          const SizedBox(height: 15),

          // TOMBOL AKSI (+ / -)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () { _controller.decrement(); refresh(); },
                    icon: const Icon(Icons.remove),
                    label: const Text("KURANG"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () { _controller.increment(); refresh(); },
                    icon: const Icon(Icons.add),
                    label: const Text("TAMBAH"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade50,
                      foregroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // LIST RIWAYAT
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Riwayat Aktivitas", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _controller.history.length,
                      itemBuilder: (context, index) {
                        final log = _controller.history[index];
                        bool isAdd = log.contains("Ditambah");
                        bool isReset = log.contains("reset");
                        Color iconColor = isReset ? Colors.orange : (isAdd ? Colors.green : Colors.red);
                        IconData iconData = isReset ? Icons.refresh : (isAdd ? Icons.arrow_upward : Icons.arrow_downward);

                        return Card(
                          elevation: 1, // Card lebih tipis biar modern
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
                              child: Icon(iconData, color: iconColor, size: 20),
                            ),
                            title: Text(log, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}