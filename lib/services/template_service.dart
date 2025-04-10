import 'dart:io';
import 'package:path/path.dart';

class TemplateService {
  static Future<void> generateBLoCTemplates(String projectPath) async {
    final blocDir =Directory('$projectPath/lib/bloc');
    await blocDir.create(recursive: true);

    // Generate map_event.dart
    await File(join(blocDir.path, 'map_event.dart')).writeAsString('''
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {}

class MapInitialized extends MapEvent {
  final LatLng initialPosition;

  MapInitialized(this.initialPosition);
}

class MapCreated extends MapEvent {
  final GoogleMapController controller;

  MapCreated(this.controller);
}

class MapLocationUpdated extends MapEvent {
  final LatLng newLocation;

  MapLocationUpdated(this.newLocation);
}
''');

    // Generate map_state.dart
    await File(join(blocDir.path, 'map_state.dart')).writeAsString('''
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';

class MapState extends Equatable {
  final LatLng initialPosition;
  final GoogleMapController? controller;
  final Set<Marker> markers;

  const MapState({
    required this.initialPosition,
    this.controller,
    this.markers = const {},
  });

  MapState copyWith({
    LatLng? initialPosition,
    GoogleMapController? controller,
    Set<Marker>? markers,
  }) {
    return MapState(
      initialPosition: initialPosition ?? this.initialPosition,
      controller: controller ?? this.controller,
      markers: markers ?? this.markers,
    );
  }

  @override
  List<Object?> get props => [initialPosition, controller, markers];
}
''');

    // Generate map_bloc.dart
    await File(join(blocDir.path, 'map_bloc.dart')).writeAsString('''
import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState(
    initialPosition: const LatLng(37.42796133580664, -122.085749655962),
  )) {
    on<MapInitialized>(_onMapInitialized);
    on<MapCreated>(_onMapCreated);
    on<MapLocationUpdated>(_onLocationUpdated);
  }

  void _onMapInitialized(MapInitialized event, Emitter<MapState> emit) {
    emit(state.copyWith(
      initialPosition: event.initialPosition,
      markers: {
        Marker(
          markerId: const MarkerId('initial_location'),
          position: event.initialPosition,
          infoWindow: const InfoWindow(title: 'Initial Location'),
        ),
      },
    ));
  }

  void _onMapCreated(MapCreated event, Emitter<MapState> emit) {
    emit(state.copyWith(controller: event.controller));
  }

  void _onLocationUpdated(MapLocationUpdated event, Emitter<MapState> emit) {
    final newMarkers = Set<Marker>.from(state.markers);
    newMarkers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: event.newLocation,
        infoWindow: const InfoWindow(title: 'Current Location'),
      ),
    );
    emit(state.copyWith(markers: newMarkers));
  }
}
''');
  }

  static Future<void> generateMapScreen(String projectPath) async {
    final screensDir = Directory('$projectPath/lib/screens');
    await screensDir.create(recursive: true);

    // Generate map_screen.dart
    await File(join(screensDir.path, 'map_screen.dart')).writeAsString('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../bloc/map_bloc.dart';
import '../bloc/map_event.dart';
import '../bloc/map_state.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late final GoogleMapController _mapController;

  @override
  void initState() {
    super.initState();
    // Initialize with default location
    context.read<MapBloc>().add(
      MapInitialized(const LatLng(37.42796133580664, -122.085749655962)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps with BLoC'),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _goToInitialLocation,
          ),
        ],
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: state.initialPosition,
              zoom: 14.4746,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
              context.read<MapBloc>().add(MapCreated(controller));
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: state.markers,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _goToInitialLocation,
        child: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _goToInitialLocation() async {
    final state = context.read<MapBloc>().state;
    if (state.controller != null) {
      await state.controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: state.initialPosition,
            zoom: 17,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }
}
''');

    // Update main.dart to include the MapScreen
    final mainFile = File('$projectPath/lib/main.dart');
    if (await mainFile.exists()) {
      await mainFile.writeAsString('''
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/map_bloc.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Google Maps Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => MapBloc(),
        child: const MapScreen(),
      ),
    );
  }
}
''');
    }
  }

  static Future<void> generateReadme(String projectPath) async {
    await File('$projectPath/README_GOOGLE_MAPS.md').writeAsString('''
# Google Maps Integration Guide

## Setup Instructions

1. **Android Configuration**:
   - Add your API key to `android/app/src/main/AndroidManifest.xml`
   - Replace `YOUR_ANDROID_API_KEY`

2. **iOS Configuration**:
   - Add your API key to `ios/Runner/AppDelegate.swift`
   - Replace `YOUR_IOS_API_KEY`

## Features Implemented
- Google Maps with BLoC state management
- Current location tracking
- Marker management
- Camera control

## BLoC Architecture
- Events: MapInitialized, MapCreated, MapLocationUpdated
- States: MapState with position, controller and markers
''');
  }
}