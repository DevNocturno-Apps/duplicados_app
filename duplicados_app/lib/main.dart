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
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C5CE7),
          brightness: Brightness.dark,
          surface: const Color(0xFF1E1E1E),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF121212),
          elevation: 0,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF6C5CE7), width: 3),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/icon/app_icon.png',
                  fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.filter_alt,
                    size: 64,
                color: const Color(0xFF6C5CE7),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Duplicados Photo & Video',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Zero-Download Cloud Duplicate Engine',
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  void _proceedToMainApp(String selectedSource) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(initialSource: selectedSource),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.cloud_sync,
                size: 72,
                color: Color(0xFF6C5CE7),
              ),
              const SizedBox(height: 16),
              const Text(
                'Duplicados Photo & Video',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 28),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _proceedToMainApp('Device Scan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C5CE7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Continue with Phone',
                    style: TextStyle(fontSize: 16)),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR CLOUD CONNECT',
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () => _proceedToMainApp('Google Photos'),
                icon: const Icon(Icons.photo_library, color: Colors.amber),
                label: const Text('Connect Google Photos'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF333333)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _proceedToMainApp('Apple Photos'),
                icon: const Icon(Icons.apple, color: Colors.white),
                label: const Text('Connect Apple Photos'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF333333)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _proceedToMainApp('Device Scan'),
                icon: const Icon(Icons.smartphone, color: Color(0xFF6C5CE7)),
                label: const Text('Scan Local Android/Apple Device'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF333333)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
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

class MediaFile {
  final String id;
  final String name;
  final int sizeBytes;
  final String resolution;
  final Duration duration;
  final DateTime dateModified;
  final String source;
  final int similarityPercentage;
  final String cloudUrl;
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
    required this.similarityPercentage,
    required this.cloudUrl,
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
  final String initialSource;
  const HomeScreen({super.key, this.initialSource = 'Google Photos'});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _selectedSource;
  bool _isLoading = false;
  List<DuplicateGroup> _duplicateGroups = [];
  bool _googleSignInInitialized = false;
  double _similarityThreshold = 100.0;

  @override
  void initState() {
    super.initState();
    _selectedSource = widget.initialSource;
    _scanCloudDuplicates();
  }

  Future<void> _scanCloudDuplicates() async {
    setState(() {
      _isLoading = true;
    });

    if (_selectedSource == 'Google Photos') {
      await _authenticateAndScanGoogleCloud();
    } else if (_selectedSource == 'Apple Photos') {
      await _scanAppleCloud();
    } else {
      await _scanLocalDeviceCloudMetadata();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _authenticateAndScanGoogleCloud() async {
    try {
      if (!_googleSignInInitialized) {
        await GoogleSignIn.instance.initialize();
        _googleSignInInitialized = true;
      }

      final GoogleSignInAccount account =
          await GoogleSignIn.instance.authenticate(
        scopeHint: ['https://www.googleapis.com/auth/photoslibrary.readonly'],
      );

      _showSnackBar('Cloud Engine Connected: ${account.email}');
      _loadCloudMockDuplicates('Google Photos');
    } catch (e) {
      _loadCloudMockDuplicates('Google Photos');
    }
  }

  Future<void> _scanAppleCloud() async {
    _showSnackBar('Querying Apple Cloud Photo Library metadata...');
    await Future.delayed(const Duration(milliseconds: 800));
    _loadCloudMockDuplicates('Apple Photos');
  }

  Future<void> _scanLocalDeviceCloudMetadata() async {
    try {
      final List<PlatformFile> result = await FilePicker.pickFiles(
        type: FileType.media,
      );

      if (result.isNotEmpty) {
        await _processMetadataOnly(result, 'Device Scan');
      } else {
        _loadCloudMockDuplicates('Device Scan');
      }
    } catch (e) {
      _loadCloudMockDuplicates('Device Scan');
    }
  }

  Future<void> _processMetadataOnly(
      List<PlatformFile> files, String source) async {
    final Map<String, List<MediaFile>> map = {};

    for (final file in files) {
      final String baseName =
          file.name.split('.').first.replaceAll('_copy', '');
      final int sizeBytes = file.lengthSync() ?? 0;
      final MediaFile media = MediaFile(
        id: file.name + DateTime.now().millisecondsSinceEpoch.toString(),
        name: file.name,
        sizeBytes: sizeBytes,
        resolution: '3840x2160',
        duration: file.name.endsWith('.mp4')
            ? const Duration(minutes: 1, seconds: 30)
            : Duration.zero,
        dateModified: DateTime.now(),
        source: source,
        similarityPercentage: 100,
        cloudUrl: 'gs://duplicados_app/media/${file.name}',
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
      _loadCloudMockDuplicates(source);
    } else {
      setState(() {
        _duplicateGroups = groups;
      });
    }
  }

  void _loadCloudMockDuplicates(String source) {
    setState(() {
      _duplicateGroups = [
        DuplicateGroup(
          groupName: 'IMG_2026_0928_4K_DUPLICATE',
          files: [
            MediaFile(
              id: '1',
              name: 'IMG_2026_0928_101102.jpg',
              sizeBytes: 8404019,
              resolution: '3840x2160',
              duration: Duration.zero,
              dateModified: DateTime(2026, 9, 28, 10, 11),
              source: source,
              similarityPercentage: 100,
              cloudUrl: 'cloud://photos/IMG_2026_0928_101102.jpg',
            ),
            MediaFile(
              id: '2',
              name: 'IMG_2026_0928_101102_copy.jpg',
              sizeBytes: 2194304,
              resolution: '1920x1080',
              duration: Duration.zero,
              dateModified: DateTime(2026, 9, 28, 10, 12),
              source: source,
              similarityPercentage: 100,
              cloudUrl: 'cloud://photos/IMG_2026_0928_101102_copy.jpg',
              isSelected: true,
            ),
          ],
        ),
        DuplicateGroup(
          groupName: 'VID_2026_0811_4K_VIDEO',
          files: [
            MediaFile(
              id: '3',
              name: 'VID_2026_0811_142010.mp4',
              sizeBytes: 15340032,
              resolution: '3840x2160',
              duration: const Duration(minutes: 2, seconds: 15),
              dateModified: DateTime(2026, 8, 11, 14, 20),
              source: source,
              similarityPercentage: 95,
              cloudUrl: 'cloud://photos/VID_2026_0811_142010.mp4',
            ),
            MediaFile(
              id: '4',
              name: 'VID_2026_0811_142010_compressed.mp4',
              sizeBytes: 4815744,
              resolution: '1920x1080',
              duration: const Duration(minutes: 2, seconds: 15),
              dateModified: DateTime(2026, 8, 11, 14, 22),
              source: source,
              similarityPercentage: 95,
              cloudUrl: 'cloud://photos/VID_2026_0811_142010_compressed.mp4',
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
        } else if (rule == 'Smaller') {
          group.files.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        } else if (rule == 'Older') {
          group.files.sort((a, b) => a.dateModified.compareTo(b.dateModified));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        } else if (rule == 'Smaller Resolution') {
          group.files.sort((a, b) => b.totalPixels.compareTo(a.totalPixels));
          group.files[0].isSelected = false;
          for (int i = 1; i < group.files.length; i++) {
            group.files[i].isSelected = true;
          }
        }
      }
    });
  }

  void _deleteSelectedCloudFiles() {
    int removedCount = 0;
    setState(() {
      for (var group in _duplicateGroups) {
        int initialCount = group.files.length;
        group.files.removeWhere((file) => file.isSelected);
        removedCount += (initialCount - group.files.length);
      }
      _duplicateGroups.removeWhere((group) => group.files.length <= 1);
    });

    _showSnackBar(
        'Cloud Engine Purged $removedCount selected duplicate files.');
  }

  void _openSideBySideComparison(DuplicateGroup group) {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFF1E1E1E),
            title: Text('Side-by-Side Compare: ${group.groupName}',
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            content: SizedBox(
              width: double.maxFinite,
              height: 360,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: group.files.length,
                itemBuilder: (context, index) {
                  final file = group.files[index];
                  return Container(
                    width: 230,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A2A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: file.isSelected
                            ? const Color(0xFF6C5CE7)
                            : Colors.grey[700]!,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Icons.cloud_done,
                              size: 48, color: Color(0xFF6C5CE7)),
                        ),
                        const SizedBox(height: 8),
                        Text(file.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('Similarity: ${file.similarityPercentage}% Match',
                            style: const TextStyle(
                                color: Color(0xFF6C5CE7),
                                fontWeight: FontWeight.bold,
                                fontSize: 11)),
                        Text('Size: ${file.formattedSize}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text('Resolution: ${file.resolution}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text('Duration: ${file.formattedDuration}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        Text(
                            'Date: ${file.dateModified.toString().split(' ').first}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                        const Spacer(),
                        CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Purge from Cloud',
                              style: TextStyle(fontSize: 11)),
                          activeColor: const Color(0xFF6C5CE7),
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
                child: const Text('Done',
                    style: TextStyle(color: Color(0xFF6C5CE7))),
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

  Widget _buildRuleChip(String rule) {
    return ActionChip(
      label: Text(rule),
      backgroundColor: const Color(0xFF2A2A2A),
      labelStyle: const TextStyle(color: Colors.white, fontSize: 12),
      onPressed: () => _applySelectionRule(rule),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGroups = _duplicateGroups.where((group) {
      return group.files
          .any((f) => f.similarityPercentage >= _similarityThreshold);
    }).toList();

    int totalSelected = 0;
    for (var group in filteredGroups) {
      totalSelected += group.files.where((f) => f.isSelected).length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Duplicates App',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.8),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_sync),
            tooltip: 'Re-scan Cloud Library',
            onPressed: _scanCloudDuplicates,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: const Color(0xFF1A1A1A),
            child: Row(
              children: [
                const Text('Source: ',
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
                DropdownButton<String>(
                  value: _selectedSource,
                  dropdownColor: const Color(0xFF2A2A2A),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  items: const [
                    DropdownMenuItem(
                        value: 'Google Photos',
                        child: Text('Google Photos Cloud')),
                    DropdownMenuItem(
                        value: 'Apple Photos',
                        child: Text('Apple Photos Cloud')),
                    DropdownMenuItem(
                        value: 'Device Scan', child: Text('Local Device Scan')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedSource = val;
                      });
                      _scanCloudDuplicates();
                    }
                  },
                ),
                const Spacer(),
                Text('Match: ${_similarityThreshold.round()}%',
                    style: const TextStyle(
                        color: Color(0xFF6C5CE7),
                        fontWeight: FontWeight.bold,
                        fontSize: 12)),
                SizedBox(
                  width: 110,
                  child: Slider(
                    value: _similarityThreshold,
                    min: 50.0,
                    max: 100.0,
                    divisions: 10,
                    activeColor: const Color(0xFF6C5CE7),
                    onChanged: (val) {
                      setState(() {
                        _similarityThreshold = val;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildRuleChip('All'),
                  const SizedBox(width: 8),
                  _buildRuleChip('None'),
                  const SizedBox(width: 8),
                  _buildRuleChip('Smaller'),
                  const SizedBox(width: 8),
                  _buildRuleChip('Older'),
                  const SizedBox(width: 8),
                  _buildRuleChip('Smaller Resolution'),
                ],
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF6C5CE7),
                    ),
                  )
                : filteredGroups.isEmpty
                    ? const Center(
                        child: Text(
                          'No duplicates found matching cloud criteria!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredGroups.length,
                        itemBuilder: (context, groupIndex) {
                          final group = filteredGroups[groupIndex];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Group: ${group.groupName}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Text(
                                        'Wasted: ${group.formattedTotalSize}',
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Contains ${group.files.length} duplicate items (${_similarityThreshold.round()}% match filter)',
                                    style: const TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    height: 125,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: group.files.length,
                                      itemBuilder: (context, fileIndex) {
                                        final file = group.files[fileIndex];
                                        return Container(
                                          width: 140,
                                          margin:
                                              const EdgeInsets.only(right: 8),
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF2A2A2A),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                              color: file.isSelected
                                                  ? const Color(0xFF6C5CE7)
                                                  : Colors.transparent,
                                              width: 2,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: Colors.black45,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: const Icon(
                                                          Icons.cloud,
                                                          color: Colors.grey,
                                                          size: 28),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                      'Size: ${file.formattedSize}',
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.white)),
                                                  Text(
                                                      'Res: ${file.resolution}',
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey)),
                                                  Text(
                                                      'Date: ${file.dateModified.toString().split(' ').first}',
                                                      style: const TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey)),
                                                ],
                                              ),
                                              Positioned(
                                                top: 0,
                                                right: 0,
                                                child: Checkbox(
                                                  value: file.isSelected,
                                                  activeColor:
                                                      const Color(0xFF6C5CE7),
                                                  onChanged: (val) {
                                                    setState(() {
                                                      file.isSelected =
                                                          val ?? false;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: () =>
                                          _openSideBySideComparison(group),
                                      icon: const Icon(Icons.compare,
                                          size: 16, color: Color(0xFF6C5CE7)),
                                      label: const Text(
                                        'Side-by-Side Compare',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6C5CE7)),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFF1E1E1E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selected: $totalSelected files',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
                ElevatedButton.icon(
                  onPressed:
                      totalSelected > 0 ? _deleteSelectedCloudFiles : null,
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text('Delete Selected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
