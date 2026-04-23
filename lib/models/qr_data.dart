import 'package:flutter/material.dart';

/// Enum untuk jenis data yang di-encode dalam QR Code
enum QrDataType {
  text('type_text', Icons.text_fields),
  url('type_url', Icons.link),
  wifi('type_wifi', Icons.wifi),
  email('type_email', Icons.email),
  phone('type_phone', Icons.phone),
  sms('type_sms', Icons.sms),
  vcard('type_vcard', Icons.contact_page),
  location('type_location', Icons.location_on);

  final String labelKey;
  final IconData icon;

  const QrDataType(this.labelKey, this.icon);
}

/// Class untuk menyimpan data yang akan di-encode ke QR Code
@immutable
class QrData {
  final QrDataType type;
  final String content;

  const QrData({this.type = QrDataType.text, this.content = ''});

  /// Creates a copy of this QrData with the given fields replaced
  QrData copyWith({QrDataType? type, String? content}) {
    return QrData(type: type ?? this.type, content: content ?? this.content);
  }

  /// Menghasilkan string yang siap di-encode ke QR Code
  /// berdasarkan tipe data
  String get encodedContent {
    switch (type) {
      case QrDataType.text:
      case QrDataType.url:
        return content;
      case QrDataType.wifi:
        // Format: WIFI:T:WPA;S:mynetwork;P:mypassword;;
        return content;
      case QrDataType.email:
        return 'mailto:$content';
      case QrDataType.phone:
        return 'tel:$content';
      case QrDataType.sms:
        return 'sms:$content';
      case QrDataType.vcard:
        return content;
      case QrDataType.location:
        return 'geo:$content';
    }
  }

  /// Cek apakah content valid (tidak kosong)
  bool get isValid => content.trim().isNotEmpty;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QrData && other.type == type && other.content == content;
  }

  @override
  int get hashCode => Object.hash(type, content);

  @override
  String toString() => 'QrData(type: $type, content: $content)';
}
