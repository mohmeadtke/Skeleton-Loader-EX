import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

void main() {
  runApp(MaterialApp(
    home: SkeletonLoaderExample(),
  ));
}

class SkeletonLoaderExample extends StatelessWidget {
  // Simulated loading state
  Future<List<String>> fetchData() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Simulate a network delay
    return List.generate(5, (index) => "Loaded item $index");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeleton Loader Example'),
      ),
      body: FutureBuilder<List<String>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show skeleton loader while data is loading
            return ListView.builder(
              itemCount: 5, // Number of placeholders
              itemBuilder: (context, index) => const SkeletonLoader(),
            );
          } else if (snapshot.hasError) {
            // Show error message if something went wrong
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            // Show actual content when data is loaded
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(snapshot.data![index]),
                );
              },
            );
          } else {
            // Handle the unlikely case of no data
            return const Center(
              child: Text('No data available.'),
            );
          }
        },
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.red[100]!,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            // Placeholder for the circular avatar
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16.0),
            // Placeholder for the text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 15.0,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.5, // Half the screen width
                    height: 15.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
