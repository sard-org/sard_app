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
  const CategorySection({super.key});

  @override
  State<CategorySection> createState() => _CategorySectionState();
}

class _CategorySectionState extends State<CategorySection> {
  int selectedIndex = -1;

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
          return Center(child: Text('Error: ${state.message}'));
        }

        return const SizedBox();
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  final dio = Dio()..options.baseUrl = 'https://api.mohamed-ramadan.me/api/';

  HomeScreen({super.key});

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
                List<String> streakTypes = [
                  '1',
                  '2',
                  '3',
                  '4',
                  '5',
                  '6',
                  '7',
                ];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(user.photo),
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
                    const SizedBox(height: 8),
                    Text(
                      'أنت تبلي حسنًا 💪 استمر في الاستماع للكتب يوميًا',
                      textDirection: TextDirection.rtl,
                      style: AppTexts.contentRegular
                          .copyWith(color: AppColors.neutral600),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: streakTypes.map((type) {
                            String assetPath = '';
                            switch (type) {
                              case '1':
                              case '2':
                                assetPath = 'assets/img/streakDone.png';
                                break;
                              case '3':
                                assetPath = 'assets/img/streak_Today.png';
                                break;
                              case '4':
                              case '5':
                              case '6':
                                assetPath = 'assets/img/streak_waiting.png';
                                break;
                              case '7':
                                assetPath = 'assets/img/streak week done.png';
                                break;
                            }
                            return Image.asset(
                              assetPath,
                              width: 36,
                              height: 36,
                            );
                          }).toList(),
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
                    const SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'عن ماذا تبحث؟',
                        hintStyle: AppTexts.contentEmphasis
                            .copyWith(color: AppColors.neutral600),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.neutral600),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.neutral300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.primary600),
                        ),
                      ),
                      style: AppTexts.contentEmphasis
                          .copyWith(color: AppColors.neutral1000),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        child: CategorySection(),
                      ),
                    ),
                  ],
                );
              } else if (state is HomeError) {
                return Center(child: Text('حصل خطأ: ${state.message}'));
              }
              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
