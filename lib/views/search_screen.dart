import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final filteredItems = ref.watch(searchProvider);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: colorScheme.primary, width: 2.0),
                  ),
                ),
                // onChanged: (query) {
                //   ref.read(searchProvider.notifier).setSearchQuery(query);
                // },
              ),
              const SizedBox(height: 16),
              // Expanded(
              //   child: ListView.builder(
              //     itemCount: filteredItems.length,
              //     itemBuilder: (context, index) {
              //       return ListTile(
              //         title: Text(filteredItems[index]),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
