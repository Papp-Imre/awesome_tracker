// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:fire_redux_sample/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_architecture_samples/flutter_architecture_samples.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected<VisibilityFilter> onSelected;
  final VisibilityFilter activeFilter;
  final bool visible;

  FilterButton({this.onSelected, this.activeFilter, this.visible, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.body1;
    final activeStyle = Theme
        .of(context)
        .textTheme
        .body1
        .copyWith(color: Theme.of(context).accentColor);

    return AnimatedOpacity(
      opacity: visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 150),
      child: PopupMenuButton<VisibilityFilter>(
        key: ArchSampleKeys.filterButton,
        tooltip: ArchSampleLocalizations.of(context).filterTasks,
        onSelected: onSelected,
        itemBuilder: (BuildContext context) =>
            <PopupMenuItem<VisibilityFilter>>[
              PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.allFilter,
                value: VisibilityFilter.all,
                child: Text(
                  ArchSampleLocalizations.of(context).showAll,
                  style: activeFilter == VisibilityFilter.all
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.activeFilter,
                value: VisibilityFilter.active,
                child: Text(
                  ArchSampleLocalizations.of(context).showActive,
                  style: activeFilter == VisibilityFilter.active
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
              PopupMenuItem<VisibilityFilter>(
                key: ArchSampleKeys.completedFilter,
                value: VisibilityFilter.completed,
                child: Text(
                  ArchSampleLocalizations.of(context).showCompleted,
                  style: activeFilter == VisibilityFilter.completed
                      ? activeStyle
                      : defaultStyle,
                ),
              ),
            ],
        icon: Icon(Icons.filter_list),
      ),
    );
  }
}
