import 'package:flutter/material.dart';
import 'package:pokedex/modules/detail/pages/about/about_page.dart';
import 'package:pokedex/modules/detail/pages/base_stats/base_stats_page.dart';
import 'package:pokedex/modules/detail/pages/evolution/evolution_page.dart';
import 'package:pokedex/modules/detail/pages/moves/moves_page.dart';
import 'package:pokedex/modules/detail/pokemon_detail_vm.dart';
import 'package:pokedex/shared/models/pokemon_summary.dart';
import 'package:pokedex/theme/app_theme.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PokemonDetailPagerWidget extends StatefulWidget {
  final PokemonDetailViewModel viewModel;
  final Function(double position) onListener;

  const PokemonDetailPagerWidget({
    super.key,
    required this.viewModel,
    required this.onListener,
  });

  @override
  State<PokemonDetailPagerWidget> createState() => _PokemonDetailPagerWidgetState();
}

class _PokemonDetailPagerWidgetState extends State<PokemonDetailPagerWidget> with TickerProviderStateMixin {
  TabController? _tabController;
  PanelController? _panelController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    );
    _panelController = PanelController();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void onUserScrollNotificationListener(UserScrollNotification userScrollNotification) {
    if (userScrollNotification.metrics.pixels > 0) {
      if (_panelController?.isPanelOpen == false) {
        _panelController?.open();
      }
    }
    if (userScrollNotification.metrics.pixels == 0) {
      if (_panelController?.isPanelOpen == true) {
        _panelController?.close();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = AppTheme.of(context).textTheme;
    var appColors = AppTheme.getColors(context);

    return SizedBox(
      width: size.width,
      height: size.height,
      child: SlidingUpPanel(
        maxHeight: MediaQuery.of(context).size.height * 1,
        minHeight: MediaQuery.of(context).size.height * 0.5,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        controller: _panelController,
        color: Colors.transparent,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        onPanelSlide: widget.onListener,
        boxShadow: null,
        panelBuilder: (scrollController) {
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: Container(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  color: appColors.backgroundColor,
                ),
                child: NestedScrollView(
                  controller: scrollController,
                  headerSliverBuilder: (context, value) {
                    return [
                      SliverAppBar(
                        leading: Container(),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        pinned: true,
                        flexibleSpace: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                                color: appColors.backgroundColor,
                              ),
                              child: StreamBuilder<PokemonSummary>(
                                  stream: widget.viewModel.streamPokemonSummary,
                                  builder: (context, snapshot) {
                                    var pokemon = snapshot.data;
                                    var pokemonColor = appColors.pokemonItem(pokemon?.types[0]);
                                    return TabBar(
                                      padding: const EdgeInsets.only(top: 8),
                                      overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      labelColor: pokemonColor,
                                      labelStyle: textTheme.labelLarge,
                                      unselectedLabelColor: appColors.pokemonTabTitle,
                                      unselectedLabelStyle: textTheme.labelLarge,
                                      indicatorColor: pokemonColor,
                                      controller: _tabController,
                                      tabs: const [
                                        Tab(
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text('About'),
                                          ),
                                        ),
                                        Tab(
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text('BaseStats'),
                                          ),
                                        ),
                                        Tab(
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text('Evolution'),
                                          ),
                                        ),
                                        Tab(
                                          child: FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text('Moves'),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: AboutPage(viewModel: widget.viewModel),
                      ),
                      SingleChildScrollView(
                        child: BaseStatsPage(viewModel: widget.viewModel),
                      ),
                      SingleChildScrollView(
                        child: EvolutionPage(viewModel: widget.viewModel),
                      ),
                      SingleChildScrollView(
                        child: MovesPage(viewModel: widget.viewModel),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
