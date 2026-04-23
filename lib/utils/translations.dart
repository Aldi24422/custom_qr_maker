import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/qr_provider.dart';

class AppTranslations {
  static const Map<String, Map<String, String>> translations = {
    'en': {
      // General & Home
      'app_title': 'Custom QR Maker',
      'tab_content': 'Content',
      'tab_style': 'Style',
      'tooltip_reset': 'Reset All',
      'tooltip_theme': 'Toggle Theme',
      'tooltip_lang': 'Toggle Language',
      'reset_dialog_title': 'Reset Everything?',
      'reset_dialog_content': 'This will clear all your current changes. Are you sure?',
      'cancel': 'Cancel',
      'reset': 'Reset',
      'reset_success': 'Reset complete',

      // Section Headers
      'content_type': 'Content Type',
      'choose_qr_format': 'Choose the QR format you need',
      'input_details': 'Input Details',
      'customize_design': 'Customize Design',
      'personalize_qr': 'Personalize your QR code style',

      // QR Preview
      'share': 'Share',
      'save': 'Save',
      'ready_title': 'Ready to Generate',
      'ready_desc': 'Enter content to see preview',
      'error_share': 'Failed to share QR code',
      'error_save': 'Failed to save file',
      'saved_to': 'Saved to',

      // Data Types
      'type_text': 'Text',
      'type_url': 'URL/Link',
      'type_wifi': 'WiFi',
      'type_email': 'Email',
      'type_vcard': 'VCard/Contact',
      'type_phone': 'Phone',
      'type_sms': 'SMS',
      'type_location': 'Location',

      // URL Form
      'form_url_label': 'Website URL',
      'form_url_hint': 'https://example.com',
      'form_url_desc': 'Enter website address or link to encode',
      'form_url_info': 'https:// will be automatically added if missing',

      // Text Form
      'form_text_hint': 'Enter text here',
      'form_text_desc': 'Enter any text, message, or paragraph to encode',
      'form_text_char_count': 'characters',
      'form_text_info': 'Supports up to 4,296 characters for alphanumeric content',

      // WiFi Form
      'form_wifi_ssid': 'Network Name (SSID)',
      'form_wifi_pass': 'Password',
      'form_wifi_password': 'Password',
      'form_wifi_enc': 'Encryption',
      'form_wifi_encryption': 'Encryption Type',
      'form_wifi_hidden': 'Hidden Network',
      'form_wifi_hidden_hint': 'Enable if your network is not visible',
      'form_wifi_desc': 'Create a QR code to easily connect to WiFi',
      'form_wifi_info': 'Scan this QR to connect to WiFi automatically',
      'wifi_enc_wpa': 'WPA/WPA2',
      'wifi_enc_wep': 'WEP',
      'wifi_enc_none': 'None',

      // Email Form
      'form_email_to': 'Email Address',
      'form_email_address': 'Email Address',
      'form_email_hint': 'example@email.com',
      'form_email_subject': 'Subject',
      'form_email_body': 'Message',
      'form_email_desc': 'Create an email preset',
      'form_email_info': 'Scanning will open the email app with pre-filled content',

      // VCard Form
      'form_vcard_name': 'Full Name',
      'form_vcard_first': 'First Name',
      'form_vcard_last': 'Last Name',
      'form_vcard_org': 'Company',
      'form_vcard_title': 'Job Title',
      'form_vcard_phone': 'Phone Number',
      'form_vcard_email': 'Email Address',
      'form_vcard_url': 'Website',
      'form_vcard_website': 'Website',
      'form_vcard_address': 'Address',
      'form_vcard_desc': 'Create a contact card',
      'form_vcard_info': 'Scanning will save this contact to the phone',

      // Common Form
      'form_error_required': 'This field is required',
      'form_error_url': 'Enter a valid URL',
      'form_error_email': 'Enter a valid email address',

      // Style Settings
      'size': 'Size',
      'style_size': 'QR Size',
      'style_margin': 'Image Margin',
      'style_shape_title': 'Shape Settings',
      'style_dot_shape': 'Dot Shape',
      'style_eye_frame': 'Eye Frame Shape',
      'style_eye_ball': 'Eye Ball Shape',
      'style_color_title': 'Color Settings',
      'style_bg': 'Background',
      'style_dots': 'Dots',
      'style_eye_frame_color': 'Eye Frame',
      'style_eye_ball_color': 'Eye Ball',
      'style_logo_title': 'Logo Settings',
      'style_logo_choose': 'Choose Logo',
      'style_logo_remove': 'Remove Logo',
      'style_advanced_title': 'Advanced Settings',
      'style_error_level': 'Error Correction Level',
      'style_remove_bg': 'Remove background behind logo',
      'style_antialiasing': 'Enable Antialiasing',
      'antialiasing_desc': 'Smoother edges for QR code elements',
      'error_level_hint': 'Higher level allows more damage tolerance but larger QR',

      // Logo Section
      'logo_active': 'Logo active',
      'change_image': 'Change Image',
      'remove_image': 'Remove Image',
      'pick_image_failed': 'Failed to pick image',

      // Color Warning Dialog
      'eye_ball_warning': 'Light eye ball colors may affect scanning reliability',
      'warning_color_title': 'Color Warning',
      'warning_color_message': 'This color is very light and may make the QR code difficult to scan. Are you sure you want to use it?',
      'cancel_change': 'Cancel Change',
      'keep_color': 'Keep Color',
    },
    'id': {
      // General & Home
      'app_title': 'Custom QR Maker',
      'tab_content': 'Konten',
      'tab_style': 'Gaya',
      'tooltip_reset': 'Ulangi Semua',
      'tooltip_theme': 'Ganti Tema',
      'tooltip_lang': 'Ganti Bahasa',
      'reset_dialog_title': 'Ulangi Semuanya?',
      'reset_dialog_content': 'Ini akan menghapus semua perubahan Anda. Anda yakin?',
      'cancel': 'Batal',
      'reset': 'Ulangi',
      'reset_success': 'Berhasil diulang',

      // Section Headers
      'content_type': 'Tipe Konten',
      'choose_qr_format': 'Pilih format QR yang Anda butuhkan',
      'input_details': 'Detail Input',
      'customize_design': 'Kustomisasi Desain',
      'personalize_qr': 'Sesuaikan gaya QR code Anda',

      // QR Preview
      'share': 'Bagikan',
      'save': 'Simpan',
      'ready_title': 'Siap Dibuat',
      'ready_desc': 'Masukkan konten untuk melihat pratinjau',
      'error_share': 'Gagal membagikan QR code',
      'error_save': 'Gagal menyimpan file',
      'saved_to': 'Tersimpan di',

      // Data Types
      'type_text': 'Teks',
      'type_url': 'URL/Tautan',
      'type_wifi': 'WiFi',
      'type_email': 'Email',
      'type_vcard': 'VCard/Kontak',
      'type_phone': 'Telepon',
      'type_sms': 'SMS',
      'type_location': 'Lokasi',

      // URL Form
      'form_url_label': 'URL Website',
      'form_url_hint': 'https://contoh.com',
      'form_url_desc': 'Masukkan alamat website atau link yang ingin di-encode',
      'form_url_info': 'Protokol https:// akan ditambahkan otomatis jika tidak ada',

      // Text Form
      'form_text_hint': 'Mengetik teks Anda di sini...',
      'form_text_desc': 'Masukkan teks, pesan, atau paragraf yang ingin di-encode',
      'form_text_char_count': 'karakter',
      'form_text_info': 'Mendukung hingga 4.296 karakter untuk konten alfanumerik',

      // WiFi Form
      'form_wifi_ssid': 'Nama Jaringan (SSID)',
      'form_wifi_pass': 'Kata Sandi',
      'form_wifi_password': 'Kata Sandi',
      'form_wifi_enc': 'Enkripsi',
      'form_wifi_encryption': 'Tipe Enkripsi',
      'form_wifi_hidden': 'Jaringan Tersembunyi',
      'form_wifi_hidden_hint': 'Aktifkan jika jaringan Anda tidak terlihat',
      'form_wifi_desc': 'Buat QR code untuk terhubung ke jaringan WiFi dengan mudah',
      'form_wifi_info': 'Pindai QR ini untuk terhubung ke WiFi secara otomatis',
      'wifi_enc_wpa': 'WPA/WPA2',
      'wifi_enc_wep': 'WEP',
      'wifi_enc_none': 'Tidak Ada',

      // Email Form
      'form_email_to': 'Alamat Email',
      'form_email_address': 'Alamat Email',
      'form_email_hint': 'contoh@email.com',
      'form_email_subject': 'Subjek',
      'form_email_body': 'Pesan',
      'form_email_desc': 'Buat template alamat dan isi email',
      'form_email_info': 'Pemindaian akan membuka aplikasi email dengan konten terisi',

      // VCard Form
      'form_vcard_name': 'Nama Lengkap',
      'form_vcard_first': 'Nama Depan',
      'form_vcard_last': 'Nama Belakang',
      'form_vcard_org': 'Perusahaan',
      'form_vcard_title': 'Jabatan',
      'form_vcard_phone': 'Nomor Telepon',
      'form_vcard_email': 'Alamat Email',
      'form_vcard_url': 'Situs Web',
      'form_vcard_website': 'Situs Web',
      'form_vcard_address': 'Alamat',
      'form_vcard_desc': 'Masukkan kontak untuk dijadikan kartu',
      'form_vcard_info': 'Pemindaian akan menyimpan kontak ini ke ponsel',

      // Common Form
      'form_error_required': 'Kolom ini wajib diisi',
      'form_error_url': 'Masukkan URL yang valid',
      'form_error_email': 'Masukkan alamat email yang valid',

      // Style Settings
      'size': 'Ukuran',
      'style_size': 'Ukuran QR',
      'style_margin': 'Batas Gambar',
      'style_shape_title': 'Pengaturan Bentuk',
      'style_dot_shape': 'Bentuk Titik',
      'style_eye_frame': 'Bentuk Bingkai Mata',
      'style_eye_ball': 'Bentuk Bola Mata',
      'style_color_title': 'Pengaturan Warna',
      'style_bg': 'Latar',
      'style_dots': 'Titik',
      'style_eye_frame_color': 'Bingkai Mata',
      'style_eye_ball_color': 'Bola Mata',
      'style_logo_title': 'Pengaturan Logo',
      'style_logo_choose': 'Pilih Logo',
      'style_logo_remove': 'Hapus Logo',
      'style_advanced_title': 'Pengaturan Lanjutan',
      'style_error_level': 'Tingkat Koreksi Kesalahan',
      'style_remove_bg': 'Hapus latar belakang di balik logo',
      'style_antialiasing': 'Aktifkan Antialiasing',
      'antialiasing_desc': 'Tepi lebih halus untuk elemen QR code',
      'error_level_hint': 'Level lebih tinggi memungkinkan toleransi kerusakan lebih besar namun QR lebih besar',

      // Logo Section
      'logo_active': 'Logo aktif',
      'change_image': 'Ganti Gambar',
      'remove_image': 'Hapus Gambar',
      'pick_image_failed': 'Gagal memilih gambar',

      // Color Warning Dialog
      'eye_ball_warning': 'Warna eye ball yang terang dapat mempengaruhi keandalan pemindaian',
      'warning_color_title': 'Peringatan Warna',
      'warning_color_message': 'Warna ini sangat terang dan dapat membuat QR code sulit dipindai. Apakah Anda yakin ingin menggunakannya?',
      'cancel_change': 'Batalkan',
      'keep_color': 'Tetap Gunakan',
    }
  };
}

extension LocalizationHelper on BuildContext {
  String t(String key) {
    QrProvider? provider;
    try { 
      provider = read<QrProvider>(); 
    } catch(e) {
      // In validators or outside provider tree context read might fail, though unlikely
      return key;
    }
    final lang = provider.language;
    final dict = AppTranslations.translations[lang] ?? AppTranslations.translations['en']!;
    return dict[key] ?? key;
  }
}
