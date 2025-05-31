import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pesan_screen.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  Future<List<dynamic>> loadData() async {
    final String jsonString = await rootBundle
        .loadString('assets/json_data_chat_dosen/dosen_chat.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'Whfatimah',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(child: Text('Belum ada pencarian')),
                ];
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Gagal memuat data'));
          }

          final dosenList = snapshot.data!;
          return ListView.builder(
            itemCount: dosenList.length,
            itemBuilder: (context, index) {
              final dosen = dosenList[index];
              final nama = dosen['name'];
              final gambar = dosen['img'];
              final List details = dosen['details'] ?? [];
              final lastChat = details.isNotEmpty
                  ? details.last['message']
                  : 'Belum ada chat';

              return ListTile(
                leading: CircleAvatar(backgroundImage: AssetImage(gambar)),
                title: Text(nama),
                subtitle: Text(
                  lastChat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Text('Kemaren'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PesanScreen(dosenData: dosen),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
    );
  }
}
