import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../data/repository.dart';
import '../change_notifiers/future_state.dart';
import '../change_notifiers/search_change_notifier.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late SearchChangeNotifier _changeNotifier;

  @override
  void initState() {
    super.initState();
    _changeNotifier = SearchChangeNotifier(
      context.read<FakestagramRepository>(),
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _changeNotifier.getImageList();
    });
  }

  @override
  Widget build(BuildContext oldContext) {
    super.build(oldContext);
    return ChangeNotifierProvider(
        create: (_) => _changeNotifier,
        builder: (context, _) {
          return Consumer<SearchChangeNotifier>(builder: (_, changeNotifier, __) {
            if (changeNotifier.imageListState == FutureState.wait) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  await _changeNotifier.getImageList();
                },
                child: GridView.count(
                    crossAxisCount: 3,
                    children: changeNotifier.imageBase64List
                        .map<Widget>((imageBase64) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.memory(base64Decode(imageBase64)),
                            ))
                        .toList()),
              );
            }
          });
        });
  }
}
