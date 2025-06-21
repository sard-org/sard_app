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
import '../Home/Logic/home_books_cubit.dart';
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
          color: AppColors.neutral100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: isSelected ? AppColors.primary500 : AppColors.neutral300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category['icon'] as IconData,
              size: 16,
              color: isSelected ? AppColors.primary500 : AppColors.neutral700,
            ),
            SizedBox(width: 4),
            Text(
              category['label'] as String,
              style: AppTexts.contentRegular.copyWith(
                color: isSelected ? AppColors.primary500 : AppColors.neutral700,
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
                                : AppColors.neutral100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary500
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
                                          ? AppColors.primary500
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
                                      ? AppColors.primary500
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
                    color: AppColors.primary500,
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
                        color: AppColors.neutral100,
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

  late HomeCubit homeCubit;
  late CategoriesCubit categoriesCubit;
  late HomeBooksLCubit homeBooksLCubit;

  @override
  void initState() {
    super.initState();
    homeCubit = context.read<HomeCubit>();
    categoriesCubit = context.read<CategoriesCubit>();
    homeBooksLCubit = context.read<HomeBooksLCubit>();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load data using cache if available
    homeCubit.getUserData();
    categoriesCubit.getCategories();
    homeBooksLCubit.loadRecommendedBooks(limit: 4);
    homeBooksLCubit.loadExchangeBooks(limit: 3);
  }

  Future<void> _refreshData() async {
    // Force refresh all data
    await Future.wait([
      homeCubit.refreshUserData(),
      categoriesCubit.refreshCategories(),
      homeBooksLCubit.refreshRecommendedBooks(),
      homeBooksLCubit.refreshExchangeBooks(),
    ]);
  }

  void resetCategorySelection() {
    _categorySectionKey.currentState?.resetSelection();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: homeCubit),
        BlocProvider.value(value: categoriesCubit),
        BlocProvider.value(value: homeBooksLCubit),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              // إذا كان يحمل، اعرض شاشة تحميل فقط
              if (state is HomeLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.primary500,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'جارٍ تحميل الصفحة الرئيسية...',
                        style: AppTexts.contentBold.copyWith(
                          color: AppColors.neutral700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              // إذا لم يكن يحمل، اعرض المحتوى العادي
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    decoration: BoxDecoration(
                      color: AppColors.primary500,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoaded) {
                          UserModelhome user = state.user;
                          
                          // Generate dynamic streak icons for AppBar
                          List<Widget> _buildStreakIconsForAppBar(int currentStreak) {
                            List<Widget> icons = [];

                            for (int i = 1; i <= 7; i++) {
                              String assetPath = '';

                              if (i == 7) {
                                // اليوم السابع دايماً له شكل مختلف
                                assetPath = 'assets/img/streak week done.png';
                              } else if (currentStreak == 0) {
                                assetPath = 'assets/img/streak_waiting.png';
                              } else if (i < currentStreak) {
                                assetPath = 'assets/img/streakDone.png';
                              } else if (i == currentStreak) {
                                assetPath = 'assets/img/streak_Today.png';
                              } else {
                                assetPath = 'assets/img/streak_waiting.png';
                              }

                              icons.add(
                                Image.asset(
                                  assetPath,
                                  width: 38,
                                  height: 38,
                                ),
                              );
                            }

                            return icons;
                          }
                          
                          return Column(
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
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
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text: 'اهلا, ',
                                            style: AppTexts.heading2Bold.copyWith(
                                              color: AppColors.neutral200,
                                              fontSize: 22,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: user.name,
                                                style: AppTexts.heading1Bold.copyWith(
                                                  color: AppColors.neutral100,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${user.message}',
                                          style: AppTexts.contentRegular.copyWith(
                                            color: AppColors.neutral100,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: _buildStreakIconsForAppBar(user.streak),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: AppColors.neutral100.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: AppColors.neutral100.withOpacity(0.5)),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/img/coin.png',
                                          width: 24,
                                          height: 24,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${user.points}',
                                          style: AppTexts.heading2Bold.copyWith(
                                            color: AppColors.neutral100,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ),
              ),
                  Expanded(
                    child: BaseScreen(
                      child: RefreshIndicator(
                        onRefresh: _refreshData,
                        color: AppColors.primary500,
                        backgroundColor: AppColors.neutral100,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SearchResultsScreen(searchQuery: ''),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.neutral100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.neutral300),
                                  ),
                                  child: Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      child: Row(
                                        children: [
                                          Text(
                                            'عن ماذا تبحث؟',
                                            style: AppTexts.contentEmphasis
                                                .copyWith(color: AppColors.neutral600),
                                          ),
                                          const Spacer(),
                                          Icon(Icons.search, color: AppColors.neutral600),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: SingleChildScrollView(
                                physics: AlwaysScrollableScrollPhysics(),
                                child: CategorySection(key: _categorySectionKey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
