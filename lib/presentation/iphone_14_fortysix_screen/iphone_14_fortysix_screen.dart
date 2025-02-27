import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../widgets/app_bar/appbar_trailing_iconbutton.dart';
import '../../widgets/app_bar/custom_app_bar.dart';
import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_outlined_button.dart';
import '../../widgets/custom_rating_bar.dart';
import 'bloc/iphone_14_fortyfive_bloc.dart';
import 'models/iphone_14_fortyfive_model.dart';

class Iphone14FortysixScreen extends StatelessWidget {
  const Iphone14FortyfiveScreen({Key? key}) : super(key: key);

  static Widget builder(BuildContext context) {
    return BlocProvider<Iphone14FortyfiveBloc>(
      create: (context) => Iphone14FortyfiveBloc(
        Iphone14FortyfiveState(
          iphone14FortyfiveModelObj: Iphone14FortyfiveModel(),
        ),
      )..add(Iphone14FortyfiveInitialEvent()),
      child: const Iphone14FortyfiveScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          height: 56.0,
          title: const Text("Book Details"),
          actions: [AppbarTrailingIconbutton()],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookDetails(context),
              const SizedBox(height: 20.0),
              _buildSuggestedBooks(context),
            ],
          ),
        ),
        bottomNavigationBar: _buildActionButtons(context),
      ),
    );
  }

  Widget _buildBookDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Book Title",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8.0),
        Row(
          children: [
            CustomRatingBar(
              rating: 4.5,
            ),
            const SizedBox(width: 10.0),
            Text(
              "4.5",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuggestedBooks(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Suggested Books",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          TextButton(
            onPressed: () {},
            child: const Text("See All"),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CustomOutlinedButton(
            text: "Add to Wishlist",
            onPressed: () {},
          ),
          CustomElevatedButton(
            text: "Buy Now",
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
