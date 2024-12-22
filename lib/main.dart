import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter + Supabase Sample',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _message = 'Press the button to load data from Supabase';

  Future<void> _testConnection() async {
    try {
      // Fetch a single row from 'test_table'
      final data = await Supabase.instance.client
          .from('test_table')
          .select('*')
          .limit(1)
          .maybeSingle(); 

      setState(() {
        _message = 'Data fetched: $data';
      });
    } on PostgrestException catch (error) {
      // Supabase-specific error
      setState(() {
        _message = 'Error: ${error.message}';
      });
    } catch (e) {
      // Any other unexpected error
      setState(() {
        _message = 'Unexpected error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter + Supabase Sample')),
      body: Center(child: Text(_message)),
      floatingActionButton: FloatingActionButton(
        onPressed: _testConnection,
        child: const Icon(Icons.cloud_download),
      ),
    );
  }
}
