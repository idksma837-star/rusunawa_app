import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/room.dart';
import '../data/repositories/room_repository.dart';
import '../viewmodels/lease_viewmodel.dart';

class RoomDetailScreen extends StatefulWidget {
  final int roomId;
  const RoomDetailScreen({super.key, required this.roomId});
  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  late Future<Room> future;
  final start = TextEditingController();
  final end = TextEditingController();

  @override
  void initState() {
    super.initState();
    future = context.read<RoomRepository>().getRoom(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    final lease = context.watch<LeaseViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kamar')),
      body: FutureBuilder<Room>(
        future: future,
        builder: (_, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) return const Center(child: Text('Gagal memuat detail'));
          final r = snap.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(r.roomNumber, style: Theme.of(context).textTheme.headlineSmall),
              Text('${r.buildingName ?? ''} | Lantai ${r.floor}'),
              Text('Rp ${r.price} / bulan | ${r.status}'),
              const Divider(height: 32),
              if (lease.error != null && lease.fieldErrors.isEmpty) Text(lease.error!),
              if (lease.fieldErrors['room_id'] != null)
                Text(lease.fieldErrors['room_id']!, style: const TextStyle(color: Colors.red)),
              TextField(controller: start,
                  decoration: InputDecoration(labelText: 'Mulai (YYYY-MM-DD)',
                      errorText: lease.fieldErrors['start_date'])),
              TextField(controller: end,
                  decoration: InputDecoration(labelText: 'Selesai (YYYY-MM-DD)',
                      errorText: lease.fieldErrors['end_date'])),
              const SizedBox(height: 16),
              if (lease.loading) const CircularProgressIndicator()
              else ElevatedButton(
                onPressed: () async {
                  final ok = await lease.submit(r.id, start.text, end.text);
                  if (ok && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sewa berhasil dibuat')));
                    Navigator.pop(context);
                  }
                },
                child: const Text('Sewa Kamar'),
              ),
            ]),
          );
        },
      ),
    );
  }
}