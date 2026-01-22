import 'package:flutter/material.dart';
import 'package:ministry_of_minority_affairs/app/core/values/app_colors.dart';
import 'package:ministry_of_minority_affairs/app/core/widgets/widgets.dart';

/// Example implementation of Work In Progress screen
/// This demonstrates how to use all the reusable widgets together
/// 
/// To use this in your app:
/// 1. Create a controller for managing state (selected filters, search query, etc.)
/// 2. Replace this example with your actual data source
/// 3. Implement navigation and business logic in your controller
class WorkInProgressScreenExample extends StatefulWidget {
  const WorkInProgressScreenExample({super.key});

  @override
  State<WorkInProgressScreenExample> createState() =>
      _WorkInProgressScreenExampleState();
}

class _WorkInProgressScreenExampleState
    extends State<WorkInProgressScreenExample> {
  String? selectedSector;
  String? selectedYear;
  bool isSectorDropdownOpen = false;
  bool isYearDropdownOpen = false;
  final TextEditingController searchController = TextEditingController();

  final List<String> sectors = [
    'Animal Husbandry',
    'DWS',
    'Education',
    'Health',
    'Housing',
    'Other Community Infrastructure',
    'Others',
    'Renewable Energy',
    'Sanitation',
    'Skill',
    'SNA release',
    'Sports',
    'Tourism',
    'WCD',
  ];

  final List<String> years = [
    '2013',
    '2014',
    '2015',
    '2016',
    '2017',
    '2018',
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            // Header
            WorkProgressHeader(
              userName: 'User Name',
              avatarAssetPath: 'assets/images/emblem.png',
            ),
            // Search and Filters Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SearchBarWidget(
                          controller: searchController,
                          hintText: 'Search',
                          onChanged: (value) {
                            // Handle search
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Sector Wise Dropdown
                      Stack(
                        children: [
                          FilterDropdown<String>(
                            label: 'Sector Wise',
                            selectedValue: selectedSector,
                            items: sectors,
                            itemBuilder: (item) => item,
                            isOpen: isSectorDropdownOpen,
                            onTap: () {
                              setState(() {
                                isSectorDropdownOpen = !isSectorDropdownOpen;
                                isYearDropdownOpen = false;
                              });
                            },
                          ),
                          if (isSectorDropdownOpen)
                            Positioned(
                              top: 56,
                              left: 0,
                              right: 0,
                              child: FilterDropdownMenu<String>(
                                items: sectors,
                                itemBuilder: (item) => item,
                                onItemSelected: (item) {
                                  setState(() {
                                    selectedSector = item;
                                    isSectorDropdownOpen = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      // Year Wise Dropdown
                      Stack(
                        children: [
                          FilterDropdown<String>(
                            label: 'Year Wise',
                            selectedValue: selectedYear,
                            items: years,
                            itemBuilder: (item) => item,
                            isOpen: isYearDropdownOpen,
                            onTap: () {
                              setState(() {
                                isYearDropdownOpen = !isYearDropdownOpen;
                                isSectorDropdownOpen = false;
                              });
                            },
                          ),
                          if (isYearDropdownOpen)
                            Positioned(
                              top: 56,
                              left: 0,
                              right: 0,
                              child: FilterDropdownMenu<String>(
                                items: years,
                                itemBuilder: (item) => item,
                                onItemSelected: (item) {
                                  setState(() {
                                    selectedYear = item;
                                    isYearDropdownOpen = false;
                                  });
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Work Progress Cards List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  // Example: Add your WorkProgressCard widgets here
                  // WorkProgressCard(
                  //   project: project,
                  //   onUpdateProgress: () {
                  //     // Handle update progress
                  //   },
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
