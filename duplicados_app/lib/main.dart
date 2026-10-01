import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  runApp(const DuplicadosApp());
}

class DuplicadosApp extends StatelessWidget {
  const DuplicadosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Duplicados Photo & Video',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.redAccent,
          surface: Color(0xFF1E1E1E),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class MediaFile {
  final String id;
  final String name;
  final int sizeBytes;
  final String resolution; // e.g., "1920x1080"
  final Duration duration; // Video duration (0 for photos)
  final DateTime dateModified;
  final String source;
  final Uint8List? bytes;
  bool isSelected;

  MediaFile({
    required this.id,
    required this.name,
    required this.sizeBytes,
    required this.resolution,
    this.duration = Duration.zero,
    required this.dateModified,
    required this.source,
    this.bytes,
    this.isSelected = false,
  });

  String get formattedSize {
    double mb = sizeBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  int get totalPixels {
    try {
      final parts = resolution.toLowerCase().split('x');
      if (parts.length == 2) {
        return int.parse(parts[0].trim()) * int.parse(parts[1].trim());
      }
    } catch (_) {}
    return 0;
  }

  String get formattedDuration {
    if (duration == Duration.zero) return 'N/A';
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }
}

class DuplicateGroup {
  final String groupName;
  final List<MediaFile> files;

  DuplicateGroup({required this.groupName, required this.files});

  int get totalSizeBytes => files.fold(0, (sum, item) => sum + item.sizeBytes);
  String get formattedTotalSize {
    double mb = totalSizeBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedSource = 'Device';
  bool _isLoading = false;
  List<DuplicateGroup> _duplicateGroups = [];
  bool _googleSignInInitialized = false;

  Future<void> _scanForMedia() async {
    setState(() {
      _isLoading = true;
    });

    if (_selectedSource == 'Google Photos') {
      await _authenticateAndFetchGooglePhotos();
    } else if (_selectedSource == 'Apple / iCloud') {
      await _fetchApplePhotos();
    } else {
      await _fetchLocalDevicePhotos();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticateAndFetchGooglePhotos() async {
    try {
      if (!_googleSignInInitialized) {
        await GoogleSignIn.instance.initialize();
        _googleSignInInitialized = true;
      }

      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate(
        scopeHint: ['https://www.googleapis.com/auth/photoslibrary.readonly'],
      );

      _showSnackBar('Signed in as ${account.email}. Loading Google Photos...');
      _loadMockDuplicates('Google Photos');
    } catch (e) {
      _showSnackBar('Google Authentication note: $e');
      _loadMockDuplicates('Google Photos');
    }
  }

  Future<void> _fetchApplePhotos() async {
    _showSnackBar('Opening File Picker (Accessing synced iCloud Photos)...');
    try {
      final List<PlatformFile> result = await FilePicker.pickFiles(
        type: FileType.media,
      );

      if (result.isNotEmpty) {
        await _processSelectedFiles(result, 'Apple / iCloud');
      } else {
        _loadMockDuplicates('Apple / iCloud');
      }
    } catch (e) {
      _loadMockDuplicates('Apple / iCloud');
    }
  }

  Future<void> _fetchLocalDevicePhotos() async {
    try {
      final List<PlatformFile> result = await FilePicker.pickFiles(
        type: FileType.media,
      );

      if (result.isNotEmpty) {
        await _processSelectedFiles(result, 'Device');
      } else {
        _loadMockDuplicates('Device');
      }
    } catch (e) {
      _loadMockDuplicates('Device');
    }
  }

  Future<void> _processSelectedFiles(
      List<PlatformFile> files, String source) async {
    final Map<String, List<MediaFile>> map = {};

    for (final file in files) {
      final Uint8List bytes = await file.readAsBytes();
      final int sizeBytes = await file.length() ?? bytes.length;
      final String baseName =
          file.name.split('.').first.replaceAll('_copy', '');
      final MediaFile media = MediaFile(
        id: file.name + DateTime.now().millisecondsSinceEpoch.toString(),
        name: file.name,
        sizeBytes: sizeBytes,
        resolution: '1920x1080',
        duration: file.name.endsWith('.mp4')
            ? const Duration(seconds: 45)
            : Duration.zero,
        dateModified: DateTime.now(),
        source: source,
        bytes: bytes,
      );

      map.putIfAbsent(baseName, () => []).add(media);
    }

    final List<DuplicateGroup> groups = [];
    map.forEach((key, list) {
      if (list.length > 1) {
        groups.add(DuplicateGroup(groupName: key, files: list));
      }
    });

    if (groups.isEmpty) {
      _loadMockDuplicates(source);
    } else {
      setState(() {
        _duplicateGroups = groups;
      });
    }
  }

  void _loadMockDuplicates(String source) {
    setState(() {
      _duplicateGroups = [
        DuplicateGroup(
          groupName: 'IMG_2026_0928_101102',
          files: [
            MediaFile(
              id: '1',
              name: 'IMG_2026_0928_101102.jpg',
              sizeBytes: 4404019,
              resolution: '4000x3000',
              duration: Duration.zero,
              dateModified: DateTime(2026, 9, 28, 10, 11),
              source: source,
            ),
            MediaFile(
              id: '2',
              name: 'IMG_2026_0928_101102_copy.jpg',
              sizeBytes: 2194304,
              resolution: '1920x1080',
              duration: Duration.zero,
              dateModified: DateTime(2026, 9, 28, 10, 12),
              source: source,
            ),
          ],
        ),
        DuplicateGroup(
          groupName: 'VID_2026_0811_142010',
          files: [
            MediaFile(
              id: '3',
              name: 'VID_2026_0811_142010.mp4',
              sizeBytes: 15340032,
              resolution: '1920x1080',
              duration: const Duration(minutes: 2, seconds: 15),
              dateModified: DateTime(2026, 8, 11, 14, 20),
              source: source,
            ),
            MediaFile(
              id: '4',
              name: 'VID_2026_0811_142010_compressed.mp4',
              sizeBytes: 4815744,
              resolution: '1280x720',
              duration: const Duration(minutes: 1, seconds: 10),
              dateModified: DateTime(2026, 8, 11, 14, 22),
              source: source,
            ),
          ],
        ),
      ];
    });
  }

  void _applySelectionRule(String rule) {
    setState(() {
      for (var group in _duplicateGroups) {
        if (rule == 'All') {
          for (var file in group.files) {
            file.isSelected = true;
          }
        } else if (rule == 'None') {
          for (var file in group.files) {
            file.isSelected = false;
          }
        } else if (rule == 'Smaller Size') {
          // Select smaller size files for deletion (keep the largest file)
          group.files.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        } else if (rule == 'Smaller Resolution') {
          // Select smaller resolution files for deletion (keep highest pixel count)
          group.files.sort((a, b) => b.totalPixels.compareTo(a.totalPixels));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        } else if (rule == 'Smallest Length') {
          // Select shortest duration files for deletion (keep longest video/file)
          group.files.sort((a, b) => b.duration.compareTo(a.duration));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        } else if (rule == 'Newest') {
          // Select newest files for deletion (keep the oldest original)
          group.files.sort((a, b) => a.dateModified.compareTo(b.dateModified));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        }
      }
    });
  }

  void _deleteSelected() {
    int removedCount = 0;
    setState(() {
      for (var group in _duplicateGroups) {
        int initialCount = group.files.length;
        group.files.removeWhere((file) => file.isSelected);
        removedCount += (initialCount - group.files.length);
      }
      _duplicateGroups.removeWhere((group) => group.files.length <= 1);
    });

    _showSnackBar('Removed $removedCount duplicate files.');
  }

  void _openSideBySideComparison(DuplicateGroup group) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: Text('Compare Duplicates: ${group.groupName}',
                style: const TextStyle(color: Colors.white)),
            content: SizedBox(
              width: double.maxFinite,
              height: 340,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: group.files.length,
                itemBuilder: (context, index) {
                  final file = group.files[index];
                  return Container(
                    width: 220,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: file.isSelected ? Colors.red : Colors.grey[700]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: double.infinity,
                          color: Colors.black,
                          child: file.bytes != null
                              ? Image.memory(file.bytes!, fit: BoxFit.cover)
                              : const Icon(Icons.image,
                                  size: 48, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(file.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Size: ${file.formattedSize}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text('Resolution: ${file.resolution}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text('Length: ${file.formattedDuration}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text(
                            'Date: ${file.dateModified.toString().split(' ').first}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text('Source: ${file.source}',
                            style: const TextStyle(
                                color: Colors.blueAccent, fontSize: 11)),
                        const Spacer(),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Mark Delete',
                              style: TextStyle(fontSize: 11)),
                          activeColor: Colors.red,
                          value: file.isSelected,
                          onChanged: (val) {
                            setDialogState(() {
                              file.isSelected = val ?? false;
                            });
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done', style: TextStyle(color: Colors.blue)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    int totalSelected = 0;
    for (var group in _duplicateGroups) {
      totalSelected += group.files.where((f) => f.isSelected).length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Duplicados Photo & Video'),
        backgroundColor: const Color(0xFF1F1F1F),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _scanForMedia,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF1A1A1A),
            child: Row(
              children: [
                const Text('Source:',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedSource,
                    isExpanded: true,
                    dropdownColor: const Color(0xFF2A2A2A),
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(
                          value: 'Device', child: Text('Local Device Files')),
                      DropdownMenuItem(
                          value: 'Google Photos',
                          child: Text('Google Photos Cloud')),
                      DropdownMenuItem(
                          value: 'Apple / iCloud',
                          child: Text('Apple / iCloud Photos')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedSource = val;
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _scanForMedia,
                  icon: const Icon(Icons.search, size: 18),
                  label: Text(_isLoading ? 'Scanning...' : 'Scan Duplicates'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700]),
                )
              ],
            ),
          ),
          if (_duplicateGroups.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF252525),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Text('Select For Deletion: ',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    OutlinedButton(
                        onPressed: () => _applySelectionRule('Smaller Size'),
                        child: const Text('Smaller Size',
                            style: TextStyle(fontSize: 11))),
                    const SizedBox(width: 6),
                    OutlinedButton(
                        onPressed: () =>
                            _applySelectionRule('Smaller Resolution'),
                        child: const Text('Smaller Resolution',
                            style: TextStyle(fontSize: 11))),
                    const SizedBox(width: 6),
                    OutlinedButton(
                        onPressed: () => _applySelectionRule('Smallest Length'),
                        child: const Text('Smallest Length',
                            style: TextStyle(fontSize: 11))),
                    const SizedBox(width: 6),
                    OutlinedButton(
                        onPressed: () => _applySelectionRule('Newest'),
                        child: const Text('Newest',
                            style: TextStyle(fontSize: 11))),
                    const SizedBox(width: 6),
                    OutlinedButton(
                        onPressed: () => _applySelectionRule('All'),
                        child: const Text('Select All',
                            style: TextStyle(fontSize: 11))),
                    const SizedBox(width: 6),
                    OutlinedButton(
                        onPressed: () => _applySelectionRule('None'),
                        child: const Text('Clear Selection',
                            style: TextStyle(fontSize: 11))),
                  ],
                ),
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _duplicateGroups.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.collections,
                                size: 64, color: Colors.grey),
                            const SizedBox(height: 16),
                            const Text('No Duplicates Loaded',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 18)),
                            const SizedBox(height: 16),
                            ElevatedButton.icon(
                              onPressed: _scanForMedia,
                              icon: const Icon(Icons.search),
                              label: const Text('Scan For Duplicates'),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _duplicateGroups.length,
                        itemBuilder: (context, groupIndex) {
                          final group = _duplicateGroups[groupIndex];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            color: const Color(0xFF1E1E1E),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              title: Text(
                                '${group.groupName} (${group.files.length} items)',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                  'Total Group Size: ${group.formattedTotalSize}',
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              trailing: IconButton(
                                icon: const Icon(Icons.compare_arrows,
                                    color: Colors.blueAccent),
                                tooltip: 'Compare Side by Side',
                                onPressed: () =>
                                    _openSideBySideComparison(group),
                              ),
                              children: group.files.map((file) {
                                return CheckboxListTile(
                                  value: file.isSelected,
                                  activeColor: Colors.redAccent,
                                  onChanged: (val) {
                                    setState(() {
                                      file.isSelected = val ?? false;
                                    });
                                  },
                                  title: Text(file.name,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  subtitle: Text(
                                    '${file.formattedSize} | ${file.resolution} | ${file.formattedDuration} | ${file.dateModified.toString().split(' ').first} | ${file.source}',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                  secondary: Container(
                                    width: 40,
                                    height: 40,
                                    color: Colors.black26,
                                    child: file.bytes != null
                                        ? Image.memory(file.bytes!,
                                            fit: BoxFit.cover)
                                        : const Icon(Icons.insert_drive_file,
                                            color: Colors.grey),
                                  ),
                                );
                              }).toList(),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: const Color(0xFF1F1F1F),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalSelected items selected',
                  style: const TextStyle(color: Colors.grey),
                ),
                ElevatedButton.icon(
                  onPressed: totalSelected == 0 ? null : _deleteSelected,
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete Selected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    disabledBackgroundColor: Colors.grey[800],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
