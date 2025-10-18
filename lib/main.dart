import 'package:flutter/material.dart';

void main() {
  runApp(const ProfileApp());
}

class ProfileApp extends StatelessWidget {
  const ProfileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProfileApp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // State for the displayed profile name
  String _currentName = 'Alex Johnson';

  // 1. NEW: Controller for the Name input field, initialized with the starting name.
  late final TextEditingController _nameController;

  // Controller and state for the separate username validation field
  final TextEditingController _usernameController = TextEditingController();
  String? _usernameErrorText;

  @override
  void initState() {
    super.initState();
    // Initialize the name controller here, outside of build.
    _nameController = TextEditingController(text: _currentName);
  }

  @override
  void dispose() {
    // Dispose both controllers
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // Method to update the profile name displayed in RichText
  void _updateProfileName(String newName) {
    // 2. Only update the state variable, not the controller here.
    setState(() {
      _currentName = newName;
    });
  }

  // Method to validate the username field
  void _validateUsername(String? value) {
    setState(() {
      if (value == null || value.isEmpty) {
        _usernameErrorText = 'Username cannot be empty';
      } else {
        _usernameErrorText = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    final String orientationText =
    orientation == Orientation.portrait ? 'Portrait' : 'Landscape';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Screen'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Profile Picture
              const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 100,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),

              // RichText widget for name (now dynamic) and email (static)
              Center(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.5,
                    ),
                    children: <TextSpan>[
                      // User's name in bold (uses the state variable _currentName)
                      TextSpan(
                        text: '$_currentName\n',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      // Email in a smaller font
                      TextSpan(
                        text: 'alex.johnson@example.com',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Row showing two buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  // ElevatedButton
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit Profile Pressed')),
                      );
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  // TextButton
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Message Pressed')),
                      );
                    },
                    child: const Text(
                      'Message',
                      style: TextStyle(color: Colors.teal),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Container with description
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: const Text(
                  'A passionate mobile developer specializing in Flutter framework. Enthusiastic about creating beautiful and performant cross-platform applications.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // CORRECTED: TextField to edit the profile name
              TextField(
                // 3. Use the single, persistent controller
                controller: _nameController,
                // Use onChanged to immediately update the name in the RichText
                onChanged: _updateProfileName,
                decoration: const InputDecoration(
                  labelText: 'Edit Profile Name',
                  hintText: 'Enter new name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 24),

              // Original Username TextField
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username (Validation Test)',
                  hintText: 'Enter new username',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: _usernameErrorText,
                ),
                onChanged: _validateUsername,
                onEditingComplete: () => _validateUsername(_usernameController.text),
              ),
              const SizedBox(height: 32),

              // Display current screen orientation at the bottom
              Center(
                child: Text(
                  'Current Orientation: $orientationText',
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
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