import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../style/BaseScreen.dart';
import '../../../style/Colors.dart';
import '../../../style/Fonts.dart';
import '../Home/Data/home_model.dart';
import '../Home/Logic/home_cubit.dart';
import '../Home/Logic/home_state.dart';
import '../Home/Withoutcategories/WithoutCategoryDetailsPage.dart';
import '../Home/categories/CategoryDetailsPage.dart';
import '../Home/categories/Data/categories_dio.dart';
import '../Home/categories/Logic/categories_cubit.dart';
import '../Home/categories/Logic/categories_state.dart';
import '../Home/search/search_results_screen.dart';

class CategoryItem extends StatelessWidget {
  final Map<String, dynamic> category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? AppColors.primary600 : AppColors.neutral300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category['icon'] as IconData,
              size: 16,
              color: isSelected ? AppColors.primary600 : AppColors.neutral700,
            ),
            SizedBox(width: 4),
            Text(
              category['label'] as String,
              style: AppTexts.contentRegular.copyWith(
                color: isSelected ? AppColors.primary600 : AppColors.neutral700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategorySection extends StatefulWidget {
  final VoidCallback? onResetRequested;
  const CategorySection({super.key, this.onResetRequested});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int selectedIndex = -1;

  void resetSelection() {
    if (mounted) {
      setState(() {
        selectedIndex = -1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      buildWhen: (previous, current) =>
          current is CategoriesLoading || current is CategoriesLoaded,
      builder: (context, state) {
        if (state is CategoriesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CategoriesLoaded) {
          final categories = state.categories;

          return Column(
            children: [
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(categories.length, (index) {
                    final category = categories[index];
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: EdgeInsets.only(right: index == 0 ? 0 : 8),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedIndex == index) {
                              selectedIndex = -1;
                            } else {
                              selectedIndex = index;
                            }
                          });
                        },
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary100
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary600
                                  : AppColors.neutral300,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  category.photo,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.category,
                                      size: 24,
                                      color: isSelected
                                          ? AppColors.primary600
                                          : AppColors.neutral700,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                category.name,
                                style: AppTexts.contentRegular.copyWith(
                                  color: isSelected
                                      ? AppColors.primary600
                                      : AppColors.neutral700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              if (selectedIndex == -1)
                WithoutCategoryDetailsPage()
              else
                CategoryDetailsPage(id: categories[selectedIndex].id),
            ],
          );
        }

        if (state is CategoriesError) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.primary600,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'خطأ في تحميل الفئات',
                    style: AppTexts.heading3Bold.copyWith(
                      color: AppColors.neutral800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    state.message,
                    style: AppTexts.contentRegular.copyWith(
                      color: AppColors.neutral500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CategoriesCubit>().getCategories();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary500,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'إعادة المحاولة',
                      style: AppTexts.contentBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final dio = Dio()..options.baseUrl = 'https://api.mohamed-ramadan.me/api/';
  final GlobalKey<_CategorySectionState> _categorySectionKey =
      GlobalKey<_CategorySectionState>();

  void resetCategorySelection() {
    _categorySectionKey.currentState?.resetSelection();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => HomeCubit()..getUserData()),
        BlocProvider(
          create: (_) => CategoriesCubit(
            CategoriesService(dio),
          ),
        ),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BaseScreen(
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded) {
                UserModelhome user = state.user;

                // Generate dynamic streak icons based on user's actual streak
                List<Widget> _buildStreakIcons(int currentStreak) {
                  List<Widget> icons = [];

                  for (int i = 1; i <= 7; i++) {
                    String assetPath = '';

                    if (currentStreak == 0) {
                      // If streak is 0 (just reset after completing 7 days) - show all as waiting
                      assetPath = 'assets/img/streak_waiting.png';
                    } else if (i < currentStreak) {
                      // Completed days
                      assetPath = 'assets/img/streakDone.png';
                    } else if (i == currentStreak) {
                      // Current day
                      assetPath = 'assets/img/streak_Today.png';
                    } else {
                      // Future days
                      assetPath = 'assets/img/streak_waiting.png';
                    }

                    icons.add(
                      Image.asset(
                        assetPath,
                        width: 36,
                        height: 36,
                      ),
                    );
                  }

                  return icons;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: user.photo.isNotEmpty
                              ? NetworkImage(user.photo)
                              : AssetImage('assets/img/Avatar.png')
                                  as ImageProvider,
                          onBackgroundImageError: user.photo.isNotEmpty
                              ? (exception, stackTrace) {
                                  // Handle network image load error
                                }
                              : null,
                        ),
                        const SizedBox(width: 8),
                        RichText(
                          text: TextSpan(
                            text: 'اهلا, ',
                            style: AppTexts.heading1Standard
                                .copyWith(color: AppColors.neutral600),
                            children: [
                              TextSpan(
                                text: user.name,
                                style: AppTexts.heading3Bold
                                    .copyWith(color: AppColors.neutral1000),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${user.message}',
                      textDirection: TextDirection.rtl,
                      style: AppTexts.contentRegular
                          .copyWith(color: AppColors.neutral600),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: _buildStreakIcons(user.streak),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${user.points}',
                                style: AppTexts.heading1Bold.copyWith(
                                    fontSize: 16, color: AppColors.primary700),
                              ),
                              const SizedBox(width: 4),
                              Image.asset(
                                'assets/img/coin.png',
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SearchResultsScreen(searchQuery: ''),
                          ),
                        );
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'عن ماذا تبحث؟',
                            hintStyle: AppTexts.contentEmphasis
                                .copyWith(color: AppColors.neutral600),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            prefixIcon:
                                Icon(Icons.search, color: AppColors.neutral600),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: AppColors.neutral300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: AppColors.primary600),
                            ),
                          ),
                          style: AppTexts.contentEmphasis
                              .copyWith(color: AppColors.neutral1000),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: CategorySection(key: _categorySectionKey),
                      ),
                    ),
                  ],
                );
              } else if (state is HomeError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: AppColors.primary600,
                        ),
                        SizedBox(height: 24),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'عذراً، حدث خطأ أثناء تحميل ',
                            style: AppTexts.heading2Bold.copyWith(
                              color: AppColors.neutral700,
                            ),
                            children: [
                              TextSpan(
                                text: 'الصفحة الرئيسية',
                                style: AppTexts.heading2Bold.copyWith(
                                  color: AppColors.red200,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary200,
                              width: 1,
                            ),
                          ),
                          child: Text(
                            state.message,
                            style: AppTexts.contentRegular.copyWith(
                              color: AppColors.neutral700,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            context.read<HomeCubit>().getUserData();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'إعادة المحاولة',
                            style: AppTexts.contentBold.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
