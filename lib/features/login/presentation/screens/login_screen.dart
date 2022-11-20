import 'package:crm_flutter_project/core/utils/media_query_values.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../config/locale/app_localizations.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../../../core/widgets/custom_edit_text.dart';
import '../../../../core/widgets/default_hieght_sized_box.dart';
import '../../../../core/widgets/employer_not_enabled_widget.dart';
import '../../../../core/widgets/error_item_widget.dart';
import '../../domain/use_cases/login_use_cases.dart';
import '../cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WindowListener {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  bool isVisible = false;

  Widget _buildBodyContent() {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginError) {
          Constants.showErrorDialog(context: context, msg: "تأكد من الايميل وكلمة السر");
        }

        if (state is EndLogin || state is EndInit) {
          // Navigator.pushNamedAndRemoveUntil(context, Routes.customersRoute, (route) => false);
          Navigator.pushNamedAndRemoveUntil(context, Routes.ownReportsRoute, (route) => false);

        }

      },
      builder: (context, state) {
        final loginCubit = LoginCubit.get(context);

        if (state is StartLogin || state is StartInit) {
          return Center(
            child: SpinKitFadingCircle(
              color: AppColors.primary,
            ),
          );
        }

        if (state is EmployeeIsNotEnabled) {
          return EmployeeNotEnabledWidget(message: state.msg, loginCubit: loginCubit,);
        }


        if (state is LoginError) {

          return ErrorItemWidget(
            msg: "تأكد من الايميل وكلمة السر او ربما تم قفل حسابك او تم عمل تغير للايميل او كلمة السر",
            onPress: () {
              loginCubit.init();
            },
          );
        }

        if (state is GettingEmployeeError) {

          return ErrorItemWidget(
            msg: state.msg,
            onPress: () {
              loginCubit.init();
            },
          );
        }



        return Form(
          key: formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomEditText(
                        hint: "الايميل",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        suffixIcon: usernameController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  usernameController.clear();
                                },
                                icon: const Icon(Icons.clear)),
                        controller: usernameController,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return AppStrings.required;
                          }

                          if (Constants.validateEmail(v, context) != null &&
                              Constants.validateMobile(v) != null) {
                            return "ادخل ايميل صحيح";
                          }

                          return null;
                        },
                        inputType: TextInputType.emailAddress,
                      ),
                      const DefaultHeightSizedBox(),
                      CustomEditText(
                        maxLines: 1,
                        hint: AppLocalizations.of(context)!
                            .translate('password')!,
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? const Icon(
                                    Icons.visibility_off_outlined,
                                  )
                                : const Icon(
                                    Icons.visibility_outlined,
                                  )),
                        isPassword: !isVisible,
                        controller: passwordController,
                        validator: (v) {
                          if (v!.isEmpty) {
                            return AppStrings.required;
                          }

                          return null;
                        },
                        inputType: TextInputType.visiblePassword,
                      ),
                      const DefaultHeightSizedBox(),

                      SizedBox(
                        width: context.width,
                        child: CustomButtonWidget(
                          text: "دخول",
                          onPress: () {

                            if (formKey.currentState!.validate()) {
                              BlocProvider.of<LoginCubit>(context).login(
                                  LoginParam(
                                      username: usernameController.text.trim(),
                                      password: passwordController.text)
                              );
                            }
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {

    windowManager.addListener(this);
    usernameController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(children: [
              // Construction
              TextSpan(
                  text: "NewStart",
                  style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold)),
              TextSpan(
                  text: "crm",
                  style: TextStyle(
                    color: AppColors.hint,
                    fontSize: 22.0,
                  )),
            ]),
          ),
        ),
        body: _buildBodyContent()
    );
  }


  @override
  void onWindowClose() async {
    bool _isPreventClose = await windowManager.isPreventClose();
    if (_isPreventClose) {

      final result = await Constants.showConfirmDialog(context: context, msg: 'هل تريد تأكيد الخروج ؟');

      if (result) {
        Navigator.pop(context);
        windowManager.destroy();
      }
    }
  }


  @override
  void dispose() {
    super.dispose();
    windowManager.removeListener(this);
    usernameController.dispose();
    passwordController.dispose();
  }
}
