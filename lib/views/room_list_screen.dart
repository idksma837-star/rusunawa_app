import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/room_list_viewmodel.dart';
import 'room_detail_screen.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});
  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<RoomListViewModel>().load());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RoomListViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kamar'), actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await context.read<AuthViewModel>().logout();
            if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ]),
      body: Column(children: [
        Wrap(spacing: 8, children: [
          for (final s in [null, 'available', 'occupied'])
            ChoiceChip(
              label: Text(s ?? 'Semua'),
              selected: vm.status == s,
              onSelected: (_) => vm.setStatus(s),
            ),
        ]),
        Expanded(child: _body(vm)),
      ]),
    );
  }

  Widget _body(RoomListViewModel vm) {
    switch (vm.state) {
      case ViewState.loading:
        return const Center(child: CircularProgressIndicator());
      case ViewState.error:
        return Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(vm.error ?? 'Terjadi kesalahan'),
            ElevatedButton(onPressed: vm.load, child: const Text('Retry')),
          ]),
        );
      case ViewState.empty:
        return const Center(child: Text('Belum ada kamar'));
      case ViewState.success:
        return RefreshIndicator(
          onRefresh: () => vm.load(silent: true),
          child: ListView.builder(
            itemCount: vm.rooms.length,
            itemBuilder: (_, i) {
              final r = vm.rooms[i];
              return ListTile(
                title: Text('${r.roomNumber} - ${r.buildingName ?? ''}'),
                subtitle: Text('Lantai ${r.floor} | Rp ${r.price} | ${r.status}'),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => RoomDetailScreen(roomId: r.id))),
              );
            },
          ),
        );
    }
  }
}