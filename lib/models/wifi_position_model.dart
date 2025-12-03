class WifiPositionModel {
  final String ssid;
  final int rssi;

  WifiPositionModel({required this.ssid, required this.rssi});

  // Fungsi pemetaan SSID dan RSSI ke lokasi gedung dan lantai
  String getLokasi() {
    if (ssid.contains('UIGM-Gedung B')) {
      return 'Gedung B';
    } else if (ssid.contains('UIGM')) {
      return 'UIGM';
    } else if (ssid.contains('BAU UIGM')) {
      return 'Gedung B Lantai 2';
    } else if (ssid.contains('Ayu')) {
      return 'Rumah Saya';
    } else if (ssid.contains('Ayu-5G')) {
      return 'Rumah Saya';
    } else if (ssid.contains('Hajjima')) {
      return 'Rumah Putri';
    } else if (ssid.contains('PASCA LANTAI1')) {
      return 'Gedung Pascasarjana Lantai 1';
    } else if (ssid.contains('UIGM LT1')) {
      return 'Gedung L Lantai 2';
    } else {
      return 'Lokasi tidak diketahui';
    }
  }
}
