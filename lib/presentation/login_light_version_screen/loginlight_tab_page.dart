import 'package:flutter/material.dart';
import '../core/app_export.dart';
import 'bloc/login_light_version_bloc.dart';
import 'models/booklist_item_model.dart';
import 'models/loginlight_tab_model.dart';
import 'widgets/booklist_item_widget.dart';

class LoginLightTabPage extends StatefulWidget {
  const LoginLightTabPage({Key? key}) : super(key: key);

  @override
  LoginLightTabPageState createState() => LoginLightTabPageState();

  static Widget builder(BuildContext context) {
    return BlocProvider<LoginLightVersionBloc>(
      create: (context) => LoginLightVersionBloc(LoginLightVersionState(
        loginLightTabModelObj: LoginLightTabModel(),
      ))..add(LoginLightVersionInitialEvent()),
      child: LoginLightTabPage(),
    );
  }
}

class LoginLightTabPageState extends State<LoginLightTabPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 4.h,
        vertical: 10.h,
      ),
      child: Column(
        children: [
          SizedBox(height: 4.h),
          _buildBookList(context),
        ],
      ),
    );
  }

  // Section Widget
  Widget _buildBookList(BuildContext context) {
    return Expanded(
      child: BlocSelector<LoginLightVersionBloc, LoginLightVersionState,
          LoginLightTabModel>(
        selector: (state) => state.loginLightTabModelObj,
        builder: (context, loginLightTabModelObj) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 6.h,
              );
            },
            itemCount: loginLightTabModelObj?.booklistItemList.length ?? 0,
            itemBuilder: (context, index) {
              BooklistItemModel model =
                  loginLightTabModelObj?.booklistItemList[index] ??
                      BooklistItemModel();
              return BooklistItemWidget(
                model,
              );
            },
          );
        },
      ),
    );
  }
}