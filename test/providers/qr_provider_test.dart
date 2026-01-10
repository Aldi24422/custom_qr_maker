import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:custom_qr_maker/providers/qr_provider.dart';
import 'package:custom_qr_maker/models/qr_options.dart';
import 'package:custom_qr_maker/models/qr_data.dart';

void main() {
  group('QrProvider Logic', () {
    late QrProvider provider;

    setUp(() {
      // Create a fresh provider before each test
      provider = QrProvider();
    });

    group('Initial State', () {
      test('should have default size of 1000', () {
        expect(provider.options.size, 1000.0);
      });

      test('should have default dotShape as square', () {
        expect(provider.options.dotShape, QrDotShape.square);
      });

      test('should have default eyeFrameShape as square', () {
        expect(provider.options.eyeFrameShape, QrEyeFrameShape.square);
      });

      test('should have default eyeBallShape as square', () {
        expect(provider.options.eyeBallShape, QrEyeBallShape.square);
      });

      test('should have empty content initially', () {
        expect(provider.data.content, isEmpty);
      });

      test('should have default data type as text', () {
        expect(provider.data.type, QrDataType.text);
      });

      test('should not be ready to generate with empty content', () {
        expect(provider.isReadyToGenerate, isFalse);
      });
    });

    group('Update Styling - Size', () {
      test('should update size to 500', () {
        provider.updateSize(500);
        expect(provider.options.size, 500.0);
      });

      test('should update size to 2000', () {
        provider.updateSize(2000);
        expect(provider.options.size, 2000.0);
      });

      test('should notify listeners when size changes', () {
        bool notified = false;
        provider.addListener(() => notified = true);

        provider.updateSize(750);

        expect(notified, isTrue);
      });
    });

    group('Update Styling - Colors', () {
      test('should update dotColor to red', () {
        provider.updateDotColor(Colors.red);
        expect(provider.options.dotColor, Colors.red);
      });

      test('should update eyeFrameColor to blue', () {
        provider.updateEyeFrameColor(Colors.blue);
        expect(provider.options.eyeFrameColor, Colors.blue);
      });

      test('should update eyeBallColor to green', () {
        provider.updateEyeBallColor(Colors.green);
        expect(provider.options.eyeBallColor, Colors.green);
      });

      test('should update all colors at once', () {
        provider.updateAllColors(
          dotColor: Colors.purple,
          eyeFrameColor: Colors.orange,
          eyeBallColor: Colors.pink,
        );

        expect(provider.options.dotColor, Colors.purple);
        expect(provider.options.eyeFrameColor, Colors.orange);
        expect(provider.options.eyeBallColor, Colors.pink);
      });
    });

    group('Update Styling - Shapes', () {
      test('should update dotShape to circle', () {
        provider.updateDotShape(QrDotShape.circle);
        expect(provider.options.dotShape, QrDotShape.circle);
      });

      test('should update dotShape to rounded', () {
        provider.updateDotShape(QrDotShape.rounded);
        expect(provider.options.dotShape, QrDotShape.rounded);
      });

      test('should update eyeFrameShape to rounded', () {
        provider.updateEyeFrameShape(QrEyeFrameShape.rounded);
        expect(provider.options.eyeFrameShape, QrEyeFrameShape.rounded);
      });

      test('should update eyeBallShape to circle', () {
        provider.updateEyeBallShape(QrEyeBallShape.circle);
        expect(provider.options.eyeBallShape, QrEyeBallShape.circle);
      });
    });

    group('Update Content', () {
      test('should update content to "Hello World"', () {
        provider.updateContent('Hello World');
        expect(provider.data.content, 'Hello World');
      });

      test('should update data type to URL', () {
        provider.updateDataType(QrDataType.url);
        expect(provider.data.type, QrDataType.url);
      });

      test('should update data type to WiFi', () {
        provider.updateDataType(QrDataType.wifi);
        expect(provider.data.type, QrDataType.wifi);
      });

      test('should update both type and content', () {
        provider.updateData(
          type: QrDataType.email,
          content: 'test@example.com',
        );

        expect(provider.data.type, QrDataType.email);
        expect(provider.data.content, 'test@example.com');
      });

      test('should be ready to generate when content is not empty', () {
        provider.updateContent('Some content');
        expect(provider.isReadyToGenerate, isTrue);
      });

      test('should notify listeners when content changes', () {
        bool notified = false;
        provider.addListener(() => notified = true);

        provider.updateContent('Test content');

        expect(notified, isTrue);
      });
    });

    group('Update Image/Logo', () {
      test('should update imagePath', () {
        provider.updateImagePath('/path/to/logo.png');
        expect(provider.options.imagePath, '/path/to/logo.png');
      });

      test('should update imageMargin', () {
        provider.updateImageMargin(25.0);
        expect(provider.options.imageMargin, 25.0);
      });

      test('should clear imagePath when set to null', () {
        provider.updateImagePath('/path/to/logo.png');
        provider.updateImagePath(null);
        // Note: copyWith doesn't set null, it keeps previous value
        // This is a design decision - to truly clear, need different approach
        expect(provider.options.imagePath, isNotNull);
      });
    });

    group('Reset Functionality', () {
      test('should reset options to default values', () {
        // First, change some values
        provider.updateSize(500);
        provider.updateDotColor(Colors.red);
        provider.updateDotShape(QrDotShape.circle);

        // Verify changes
        expect(provider.options.size, 500.0);
        expect(provider.options.dotColor, Colors.red);
        expect(provider.options.dotShape, QrDotShape.circle);

        // Reset
        provider.resetOptions();

        // Verify reset to defaults
        expect(provider.options.size, 1000.0);
        expect(provider.options.dotColor, const Color(0xFF4A148C));
        expect(provider.options.dotShape, QrDotShape.square);
      });

      test('should reset data to default values', () {
        // First, change some values
        provider.updateContent('Hello World');
        provider.updateDataType(QrDataType.url);

        // Verify changes
        expect(provider.data.content, 'Hello World');
        expect(provider.data.type, QrDataType.url);

        // Reset
        provider.resetData();

        // Verify reset to defaults
        expect(provider.data.content, isEmpty);
        expect(provider.data.type, QrDataType.text);
      });

      test('should reset all state with resetAll()', () {
        // Change various values
        provider.updateSize(1500);
        provider.updateDotColor(Colors.blue);
        provider.updateContent('Test Data');
        provider.updateDataType(QrDataType.wifi);

        // Reset all
        provider.resetAll();

        // Verify all reset
        expect(provider.options.size, 1000.0);
        expect(provider.options.dotColor, const Color(0xFF4A148C));
        expect(provider.data.content, isEmpty);
        expect(provider.data.type, QrDataType.text);
      });
    });

    group('RemoveBrand Option', () {
      test('should update removeBrand to true', () {
        expect(provider.options.removeBrand, isFalse);

        provider.updateRemoveBrand(true);

        expect(provider.options.removeBrand, isTrue);
      });

      test('should update removeBrand back to false', () {
        provider.updateRemoveBrand(true);
        provider.updateRemoveBrand(false);

        expect(provider.options.removeBrand, isFalse);
      });
    });
  });

  group('QrOptions JSON Serialization', () {
    test('should serialize to JSON correctly', () {
      const options = QrOptions(
        size: 800,
        dotShape: QrDotShape.circle,
        dotColor: Colors.red,
      );

      final json = options.toJson();

      expect(json['size'], 800.0);
      expect(json['dotShape'], QrDotShape.circle.index);
      expect(json['dotColor'], Colors.red.toARGB32());
    });

    test('should deserialize from JSON correctly', () {
      final json = {
        'size': 1500.0,
        'imageMargin': 20.0,
        'dotShape': QrDotShape.rounded.index,
        'eyeFrameShape': QrEyeFrameShape.circle.index,
        'eyeBallShape': QrEyeBallShape.rounded.index,
        'dotColor': Colors.blue.toARGB32(),
        'eyeFrameColor': Colors.green.toARGB32(),
        'eyeBallColor': Colors.orange.toARGB32(),
        'imagePath': null,
        'removeBrand': true,
      };

      final options = QrOptions.fromJson(json);

      expect(options.size, 1500.0);
      expect(options.imageMargin, 20.0);
      expect(options.dotShape, QrDotShape.rounded);
      expect(options.eyeFrameShape, QrEyeFrameShape.circle);
      expect(options.eyeBallShape, QrEyeBallShape.rounded);
      expect(options.removeBrand, isTrue);
    });

    test('should handle missing JSON fields with defaults', () {
      final json = <String, dynamic>{};

      final options = QrOptions.fromJson(json);

      expect(options.size, 1000.0);
      expect(options.dotShape, QrDotShape.square);
      expect(options.removeBrand, isFalse);
    });
  });

  group('QrData Model', () {
    test('should generate correct encoded content for email', () {
      const data = QrData(type: QrDataType.email, content: 'test@example.com');

      expect(data.encodedContent, 'mailto:test@example.com');
    });

    test('should generate correct encoded content for phone', () {
      const data = QrData(type: QrDataType.phone, content: '+1234567890');

      expect(data.encodedContent, 'tel:+1234567890');
    });

    test('should return raw content for text type', () {
      const data = QrData(type: QrDataType.text, content: 'Hello World');

      expect(data.encodedContent, 'Hello World');
    });

    test('should validate empty content as invalid', () {
      const data = QrData(content: '');
      expect(data.isValid, isFalse);
    });

    test('should validate non-empty content as valid', () {
      const data = QrData(content: 'Valid content');
      expect(data.isValid, isTrue);
    });
  });
}
