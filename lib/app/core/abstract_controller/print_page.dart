import 'dart:ui' as ui;

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:nb_utils/nb_utils.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({super.key});

  @override
  State<PrintPage> createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  bool _isPrinting = false;
  double _customFontSize = 12; // Default font size for image printing

  // Image-based printing methods with Unicode support
  Future<img.Image> _generateTextImage(
    String text,
    double fontSize,
  ) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Thermal printer width (384 pixels for 58mm, 576 for 80mm)
    const double width = 384;
    final double height = fontSize * 2.0; // More height for complex scripts

    // White background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, width, height),
      Paint()..color = Colors.white,
    );

    // Draw text with Unicode support
// More top padding for complex scripts

    final picture = recorder.endRecording();
    final uiImage = await picture.toImage(width.toInt(), (height + 15).toInt());
    final byteData = await uiImage.toByteData(format: ui.ImageByteFormat.png);

    // Convert to img.Image for ESC/POS processing
    final pngBytes = byteData!.buffer.asUint8List();
    final image = img.decodeImage(pngBytes);

    return image!;
  }

  Future<List<int>> _generateImagePrintData(img.Image image) async {
    List<int> bytes = [];

    // Load printer profile (58mm thermal printer)
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    // Initialize printer
    bytes += generator.reset();

    // Print the image
    bytes += generator.image(image);

    // Add some space and cut
    bytes += generator.feed(2);
    bytes += generator.cut();

    return bytes;
  }

  Future<void> _printCustomImageText(String text) async {
    setState(() => _isPrinting = true);

    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        toast('Printer not connected');
        return;
      }

      if (kDebugMode) {
        print('🖼️ Generating image with font size $_customFontSize px...');
      }

      // Generate image with custom font size
      final image = await _generateTextImage(text, _customFontSize);
      final printData = await _generateImagePrintData(image);

      if (kDebugMode) {
        print('🖨️ Printing ${_customFontSize}px text as image...');
      }

      // Print the image data
      await PrintBluetoothThermal.writeBytes(printData);

      if (kDebugMode) print('✅ Image-based text printed successfully');
      toast('✅ Printed ${_customFontSize}px text as image!');
    } catch (e) {
      if (kDebugMode) print('❌ Image print error: $e');
      toast('Failed to print image: $e');
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<void> _printImageFontDemo() async {
    setState(() => _isPrinting = true);

    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        toast('Printer not connected');
        return;
      }

      if (kDebugMode) print('🖼️ Printing complete font size comparison...');

      List<int> allBytes = [];

      // Load printer profile
      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);

      // Initialize printer
      allBytes += generator.reset();

      // Add header
      allBytes += generator.text(
        'IMAGE-BASED FONT DEMO',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      allBytes += generator.text(
        'Unlimited pixel-perfect control!',
        styles: const PosStyles(align: PosAlign.center),
      );
      allBytes += generator.text(
        '=' * 32,
        styles: const PosStyles(align: PosAlign.center),
      );
      allBytes += generator.feed(1);

      // Demo different font sizes as images
      final fontSizes = [4.0, 6.0, 8.0, 10.0, 12.0, 16.0, 20.0, 24.0, 32.0];

      for (final double size in fontSizes) {
        final image = await _generateTextImage(
          'Font Size ${size.toStringAsFixed(0)}px - Perfect Control!',
          size,
        );
        allBytes += generator.image(image);
        allBytes += generator.feed(1); // Space between lines
      }

      // Add footer
      allBytes += generator.feed(1);
      allBytes += generator.text(
        'Image Printing Benefits:',
        styles: const PosStyles(bold: true),
      );
      allBytes += generator.text('• ANY size you want!');
      allBytes += generator.text('• Perfect Unicode support');
      allBytes += generator.text('• Custom fonts possible');
      allBytes += generator.text('• Pixel-perfect control');
      allBytes += generator.feed(2);
      allBytes += generator.cut();

      await PrintBluetoothThermal.writeBytes(allBytes);

      if (kDebugMode) print('✅ Complete font demo printed');
      toast('✅ Image-based font demo printed!');
    } catch (e) {
      if (kDebugMode) print('❌ Image demo error: $e');
      toast('Failed to print image demo: $e');
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  Future<void> _printBanglaDemo() async {
    setState(() => _isPrinting = true);

    try {
      final isConnected = await PrintBluetoothThermal.connectionStatus;
      if (!isConnected) {
        toast('Printer not connected');
        return;
      }

      if (kDebugMode) print('🇧🇩 Printing Bangla text demo...');

      List<int> allBytes = [];

      final profile = await CapabilityProfile.load();
      final generator = Generator(PaperSize.mm58, profile);

      allBytes += generator.reset();

      // Header in English
      allBytes += generator.text(
        'BANGLA TEXT PRINTING DEMO',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      allBytes += generator.text(
        '=' * 32,
        styles: const PosStyles(align: PosAlign.center),
      );
      allBytes += generator.feed(1);

      // Bangla samples with different sizes
      final banglaTexts = [
        {'text': 'স্বাগতম', 'size': 20.0, 'meaning': '(Welcome)'},
        {'text': 'বাংলাদেশ', 'size': 18.0, 'meaning': '(Bangladesh)'},
        {
          'text': 'আমি বাংলায় গান গাই',
          'size': 14.0,
          'meaning': '(I sing in Bengali)',
        },
        {
          'text': 'রবীন্দ্রনাথ ঠাকুর',
          'size': 12.0,
          'meaning': '(Rabindranath Tagore)',
        },
        {
          'text': 'আমার সোনার বাংলা',
          'size': 10.0,
          'meaning': '(My Golden Bengal)',
        },
        {'text': 'ধন্যবাদ', 'size': 16.0, 'meaning': '(Thank you)'},
      ];

      for (final item in banglaTexts) {
        // Print Bangla text
        final banglaImage = await _generateTextImage(
          item['text']! as String,
          item['size']! as double,
        );
        allBytes += generator.image(banglaImage);

        // Print meaning in smaller English text
        allBytes += generator.text(
          '  ${item['meaning']}',
        );
        allBytes += generator.feed(1);
      }

      // Mixed Bangla-English receipt demo
      allBytes += generator.feed(1);
      allBytes += generator.text(
        'MIXED LANGUAGE RECEIPT',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      );
      allBytes += generator.text(
        '-' * 32,
        styles: const PosStyles(align: PosAlign.center),
      );
      allBytes += generator.feed(1);

      // Shop name in Bangla
      final shopImage = await _generateTextImage('রহমান স্টোর', 18);
      allBytes += generator.image(shopImage);

      // Address in Bangla
      final addressImage = await _generateTextImage('ঢাকা, বাংলাদেশ', 10);
      allBytes += generator.image(addressImage);
      allBytes += generator.feed(1);

      // Items with Bangla names
      final items = [
        'চাল (Rice)               ৫০০ টাকা',
        'ডাল (Lentil)             ১২০ টাকা',
        'তেল (Oil)                 ২৮০ টাকা',
        'চিনি (Sugar)              ১৫০ টাকা',
      ];

      for (final String item in items) {
        final itemImage = await _generateTextImage(item, 9);
        allBytes += generator.image(itemImage);
      }

      allBytes += generator.feed(1);

      // Total in Bangla
      final totalImage = await _generateTextImage('মোট: ১০৫০ টাকা', 14);
      allBytes += generator.image(totalImage);

      allBytes += generator.feed(2);
      allBytes += generator.cut();

      await PrintBluetoothThermal.writeBytes(allBytes);

      if (kDebugMode) print('✅ Bangla demo printed successfully');
      toast('✅ বাংলা টেক্সট প্রিন্ট সফল! (Bangla text printed successfully!)');
    } catch (e) {
      if (kDebugMode) print('❌ Bangla print error: $e');
      toast('Failed to print Bangla text: $e');
    } finally {
      setState(() => _isPrinting = false);
    }
  }

  void _showCustomImageTextDialog() {
    final textController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Custom Size Text'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'Enter text to print...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Font Size: '),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _customFontSize,
                    min: 4,
                    max: 48,
                    divisions: 44,
                    label: '${_customFontSize.toStringAsFixed(0)}px',
                    onChanged: (double value) {
                      setState(() => _customFontSize = value);
                    },
                  ),
                ),
                Text('${_customFontSize.toStringAsFixed(0)}px'),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (textController.text.isNotEmpty) {
                _printCustomImageText(textController.text);
              }
            },
            child: const Text('Print as Image'),
          ),
        ],
      ),
    );
  }

  void _showBanglaTextDialog() {
    final textController = TextEditingController()
      ..text = 'আমি বাংলায় লিখি'; // Default Bangla text

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Print Bangla Text / বাংলা টেক্সট প্রিন্ট'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                hintText: 'বাংলা টেক্সট লিখুন... (Enter Bangla text...)',
                border: OutlineInputBorder(),
                helperText: 'You can type in Bangla or any Unicode text',
              ),
              maxLines: 3,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Font Size: '),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _customFontSize,
                    min: 8, // Slightly larger min for complex scripts
                    max: 32,
                    divisions: 24,
                    label: '${_customFontSize.toStringAsFixed(0)}px',
                    onChanged: (double value) {
                      setState(() => _customFontSize = value);
                    },
                  ),
                ),
                Text('${_customFontSize.toStringAsFixed(0)}px'),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Sample: আমি বাংলায় গান গাই',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (textController.text.isNotEmpty) {
                _printCustomImageText(textController.text);
              }
            },
            child: const Text('Print / প্রিন্ট'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image-Based Thermal Printing'),
        elevation: 2,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildFontSizeSelector(),
              const SizedBox(height: 24),
              _buildPrintOptions(),
              const SizedBox(height: 24),
              _buildConnectionStatus(),
              const SizedBox(height: 24), // Extra padding at bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.image, size: 48, color: Colors.purple),
            SizedBox(height: 8),
            Text(
              'Image-Based Thermal Printing',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              'Unlimited font control • Perfect Unicode support',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontSizeSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Font Size Control',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Font Size: '),
                const SizedBox(width: 8),
                Expanded(
                  child: Slider(
                    value: _customFontSize,
                    min: 4,
                    max: 48,
                    divisions: 44,
                    label: '${_customFontSize.toStringAsFixed(0)}px',
                    onChanged: (double value) {
                      setState(() => _customFontSize = value);
                    },
                  ),
                ),
                Text(
                  '${_customFontSize.toStringAsFixed(0)}px',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Pixel-perfect control: ANY size from 4px to 48px',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrintOptions() {
    return Column(
      children: [
        const Text(
          'Print Options',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Image-based Printing Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.image, color: Colors.purple.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Image-based Printing (UNLIMITED CONTROL)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Perfect pixel control • ANY font size • Custom fonts',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.purple.shade600,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isPrinting ? null : _printImageFontDemo,
                icon: _isPrinting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.photo_size_select_actual),
                label: Text(
                  _isPrinting ? 'Printing...' : 'Print Font Size Demo',
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isPrinting ? null : _showCustomImageTextDialog,
                icon: const Icon(Icons.image_aspect_ratio),
                label: const Text('Print Custom Size Text'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.purple.shade300,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Unicode/Bangla Printing Section
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.language, color: Colors.green.shade600),
                  const SizedBox(width: 8),
                  Text(
                    'Unicode Text Printing (বাংলা/العربية/中文/русский)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Print ANY language • Perfect Unicode support • Complex scripts',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isPrinting ? null : _printBanglaDemo,
                icon: const Text('🇧🇩', style: TextStyle(fontSize: 20)),
                label: const Text('Bangla Demo / বাংলা ডেমো'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: _isPrinting ? null : _showBanglaTextDialog,
                icon: const Icon(Icons.translate),
                label: const Text('Custom Bangla Text / কাস্টম বাংলা'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.green.shade300,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Sample: আমি বাংলায় গান গাই • আমার সোনার বাংলা • ধন্যবাদ',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return FutureBuilder<bool>(
      future: PrintBluetoothThermal.connectionStatus,
      builder: (context, snapshot) {
        final isConnected = snapshot.data ?? false;
        return Card(
          color: isConnected ? Colors.green.shade50 : Colors.red.shade50,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  isConnected
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: isConnected ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  isConnected ? 'Printer Connected' : 'Printer Not Connected',
                  style: TextStyle(
                    color: isConnected
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
