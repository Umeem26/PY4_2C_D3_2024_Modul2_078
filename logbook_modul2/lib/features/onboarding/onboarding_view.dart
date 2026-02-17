import 'package:flutter/material.dart';
import 'package:logbook_modul2/features/auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int _step = 1;

  void _nextStep() {
    setState(() {
      if (_step < 3) {
        _step++;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    });
  }

  Widget _buildDot(int index) {
    bool isActive = _step == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 20 : 10, // Kalau aktif lebih lebar
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? Colors.indigo : Colors.indigo.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  // Data konten biar rapi (Title & Desc)
  final List<Map<String, String>> _onboardingData = [
    {
      "title": "Selamat Datang!",
      "desc": "Aplikasi Logbook digital untuk mencatat aktivitas harianmu dengan mudah."
    },
    {
      "title": "Keamanan Terjamin",
      "desc": "Login aman dengan sistem validasi user yang canggih dan terpercaya."
    },
    {
      "title": "Simpan Otomatis",
      "desc": "Jangan khawatir data hilang. Kami menyimpannya secara lokal di perangkatmu."
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Ambil data berdasarkan step (index array mulai dari 0, jadi step-1)
    final data = _onboardingData[_step - 1];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const Spacer(),
              // GAMBAR (Placeholder Assets)
              Expanded(
                flex: 3,
                child: Image.asset(
                  'assets/onboard$_step.png',
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image, size: 100, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 30),
              
              // INDIKATOR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(1),
                  _buildDot(2),
                  _buildDot(3),
                ],
              ),
              const SizedBox(height: 30),

              // TEKS JUDUL & DESKRIPSI
              Text(
                data["title"]!,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                data["desc"]!,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const Spacer(),

              // TOMBOL MODERN
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                  ),
                  child: Text(
                    _step == 3 ? "MULAI SEKARANG" : "LANJUT",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}