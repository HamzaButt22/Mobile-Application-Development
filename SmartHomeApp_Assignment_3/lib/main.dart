import 'package:flutter/material.dart';

void main() {
  runApp(const SmartHomeApp());
}

class SmartHomeApp extends StatelessWidget {
  const SmartHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Home Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF1E3A8A),
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E3A8A),
          elevation: 0,
          centerTitle: true,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF3B82F6),
        ),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

// Device Model
class Device {
  final String id;
  String name;
  String type;
  String room;
  bool isOn;
  double intensity; // For brightness/speed (0-100)
  IconData icon;
  Color color;

  Device({
    required this.id,
    required this.name,
    required this.type,
    required this.room,
    this.isOn = false,
    this.intensity = 50.0,
    required this.icon,
    required this.color,
  });
}

// Main Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Device> devices = [
    Device(
      id: '1',
      name: 'Living Room Light',
      type: 'Light',
      room: 'Living Room',
      isOn: true,
      intensity: 70,
      icon: Icons.lightbulb,
      color: Colors.amber,
    ),
    Device(
      id: '2',
      name: 'Bedroom Fan',
      type: 'Fan',
      room: 'Bedroom',
      isOn: false,
      intensity: 60,
      icon: Icons.air,
      color: Colors.cyan,
    ),
    Device(
      id: '3',
      name: 'Living Room AC',
      type: 'AC',
      room: 'Living Room',
      isOn: true,
      intensity: 22,
      icon: Icons.ac_unit,
      color: Colors.blue,
    ),
    Device(
      id: '4',
      name: 'Front Door Camera',
      type: 'Camera',
      room: 'Entrance',
      isOn: true,
      intensity: 100,
      icon: Icons.videocam,
      color: Colors.red,
    ),
    Device(
      id: '5',
      name: 'Kitchen Light',
      type: 'Light',
      room: 'Kitchen',
      isOn: false,
      intensity: 80,
      icon: Icons.lightbulb,
      color: Colors.amber,
    ),
    Device(
      id: '6',
      name: 'Garage Door',
      type: 'Door',
      room: 'Garage',
      isOn: false,
      intensity: 0,
      icon: Icons.garage,
      color: Colors.grey,
    ),
  ];

  void _toggleDevice(int index) {
    setState(() {
      devices[index].isOn = !devices[index].isOn;
    });
  }

  void _addNewDevice(Device device) {
    setState(() {
      devices.add(device);
    });
  }

  void _updateDevice(Device updatedDevice) {
    setState(() {
      int index = devices.indexWhere((d) => d.id == updatedDevice.id);
      if (index != -1) {
        devices[index] = updatedDevice;
      }
    });
  }

  void _showAddDeviceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddDeviceDialog(onDeviceAdded: _addNewDevice);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Menu opened')),
            );
          },
        ),
        title: const Text(
          'Smart Home Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Text(
              'Welcome Home!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${devices.where((d) => d.isOn).length} devices are currently active',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),

            // Devices Grid
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceCard(
                    device: devices[index],
                    onToggle: () => _toggleDevice(index),
                    onTap: () async {
                      final updatedDevice = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DeviceDetailsScreen(
                            device: devices[index],
                          ),
                        ),
                      );
                      if (updatedDevice != null) {
                        _updateDevice(updatedDevice);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDeviceDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add Device'),
      ),
    );
  }
}

// Device Card Widget
class DeviceCard extends StatefulWidget {
  final Device device;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const DeviceCard({
    super.key,
    required this.device,
    required this.onToggle,
    required this.onTap,
  });

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Card(
          color: widget.device.isOn
              ? Color.alphaBlend(
            widget.device.color.withValues(alpha: 0.1),
            Colors.white,
          )
              : Colors.white,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon and Switch
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: widget.device.isOn
                              ? widget.device.color
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          widget.device.icon,
                          color: widget.device.isOn
                              ? Colors.white
                              : Colors.grey.shade600,
                          size: 28,
                        ),
                      ),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: widget.device.isOn,
                          onChanged: (_) => widget.onToggle(),
                          activeTrackColor: widget.device.color,
                        ),
                      ),
                    ],
                  ),

                  // Device Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.device.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.device.room,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: widget.device.isOn
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          widget.device.isOn ? 'ON' : 'OFF',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: widget.device.isOn
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Device Details Screen
class DeviceDetailsScreen extends StatefulWidget {
  final Device device;

  const DeviceDetailsScreen({super.key, required this.device});

  @override
  State<DeviceDetailsScreen> createState() => _DeviceDetailsScreenState();
}

class _DeviceDetailsScreenState extends State<DeviceDetailsScreen> {
  late Device _device;

  @override
  void initState() {
    super.initState();
    _device = Device(
      id: widget.device.id,
      name: widget.device.name,
      type: widget.device.type,
      room: widget.device.room,
      isOn: widget.device.isOn,
      intensity: widget.device.intensity,
      icon: widget.device.icon,
      color: widget.device.color,
    );
  }

  String _getIntensityLabel() {
    switch (_device.type) {
      case 'Light':
        return 'Brightness';
      case 'Fan':
        return 'Speed';
      case 'AC':
        return 'Temperature';
      default:
        return 'Intensity';
    }
  }

  String _getIntensityValue() {
    if (_device.type == 'AC') {
      return '${_device.intensity.round()}°C';
    }
    return '${_device.intensity.round()}%';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, _device),
        ),
        title: Text(
          _device.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Device Icon
              Center(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: _device.isOn
                        ? Color.alphaBlend(
                      _device.color.withValues(alpha: 0.2),
                      Colors.white,
                    )
                        : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _device.icon,
                    size: 80,
                    color: _device.isOn ? _device.color : Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Device Name and Room
              Text(
                _device.name,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.room, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _device.room,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.category, size: 20, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    _device.type,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Status Card
              Card(
                color: _device.isOn ? Colors.green.shade50 : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Status',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _device.isOn
                                ? '${_device.type} is ON'
                                : '${_device.type} is OFF',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _device.isOn
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: _device.isOn,
                        onChanged: (value) {
                          setState(() {
                            _device.isOn = value;
                          });
                        },
                        activeTrackColor: _device.color,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Intensity Control (only for Light, Fan, AC)
              if (_device.type == 'Light' ||
                  _device.type == 'Fan' ||
                  _device.type == 'AC') ...[
                Text(
                  _getIntensityLabel(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(_device.icon, color: _device.color),
                            Text(
                              _getIntensityValue(),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _device.color,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Slider(
                          value: _device.intensity,
                          min: _device.type == 'AC' ? 16 : 0,
                          max: _device.type == 'AC' ? 30 : 100,
                          divisions: _device.type == 'AC' ? 14 : 20,
                          activeColor: _device.color,
                          onChanged: _device.isOn
                              ? (value) {
                            setState(() {
                              _device.intensity = value;
                            });
                          }
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _device.isOn = !_device.isOn;
                        });
                      },
                      icon: Icon(_device.isOn ? Icons.power_off : Icons.power),
                      label: Text(_device.isOn ? 'Turn OFF' : 'Turn ON'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _device.isOn ? Colors.red : Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Add Device Dialog
class AddDeviceDialog extends StatefulWidget {
  final Function(Device) onDeviceAdded;

  const AddDeviceDialog({super.key, required this.onDeviceAdded});

  @override
  State<AddDeviceDialog> createState() => _AddDeviceDialogState();
}

class _AddDeviceDialogState extends State<AddDeviceDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roomController = TextEditingController();
  String _selectedType = 'Light';
  bool _isOn = false;

  final Map<String, Map<String, dynamic>> _deviceTypes = {
    'Light': {'icon': Icons.lightbulb, 'color': Colors.amber},
    'Fan': {'icon': Icons.air, 'color': Colors.cyan},
    'AC': {'icon': Icons.ac_unit, 'color': Colors.blue},
    'Camera': {'icon': Icons.videocam, 'color': Colors.red},
    'Door': {'icon': Icons.door_front_door, 'color': Colors.brown},
    'Thermostat': {'icon': Icons.thermostat, 'color': Colors.orange},
  };

  @override
  void dispose() {
    _nameController.dispose();
    _roomController.dispose();
    super.dispose();
  }

  void _addDevice() {
    if (_formKey.currentState!.validate()) {
      final device = Device(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        room: _roomController.text,
        isOn: _isOn,
        intensity: 50,
        icon: _deviceTypes[_selectedType]!['icon'],
        color: _deviceTypes[_selectedType]!['color'],
      );

      widget.onDeviceAdded(device);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_nameController.text} added successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Add New Device',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Device Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Device Name',
                    hintText: 'e.g., Living Room Light',
                    prefixIcon: const Icon(Icons.devices),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter device name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Device Type Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedType,
                  decoration: InputDecoration(
                    labelText: 'Device Type',
                    prefixIcon: const Icon(Icons.category),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _deviceTypes.keys.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            _deviceTypes[type]!['icon'],
                            color: _deviceTypes[type]!['color'],
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(type),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      _selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Room Name
                TextFormField(
                  controller: _roomController,
                  decoration: InputDecoration(
                    labelText: 'Room Name',
                    hintText: 'e.g., Living Room',
                    prefixIcon: const Icon(Icons.room),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter room name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Initial Status
                SwitchListTile(
                  title: const Text('Initial Status'),
                  subtitle:
                  Text(_isOn ? 'Device will be ON' : 'Device will be OFF'),
                  value: _isOn,
                  onChanged: (value) {
                    setState(() {
                      _isOn = value;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                const SizedBox(height: 24),

                // Add Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addDevice,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Device'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}