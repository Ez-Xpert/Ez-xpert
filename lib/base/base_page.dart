import 'package:ez_xpert/base/base_view_model.dart';
import 'package:ez_xpert/components/common/error.dart';
import 'package:ez_xpert/components/common/loading.dart';
import 'package:ez_xpert/components/dialog/loading_popup.dart';
import 'package:ez_xpert/screen/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';

mixin BasePage<T extends BaseViewModel> {
  T? _provider;

  T? get provider => _provider;

  @protected
  T create();

  @protected
  void initialise(BuildContext context);

  Widget builder(Widget Function() builder) => ChangeNotifierProvider<T>(
        create: (context) {
          _provider = create();

          _provider!.onShowLoading = () {
            LoadingPopup.show(context);
          };

          _provider!.onHideLoading = () {
            Navigator.of(context).pop();
          };

          _provider!.onShowError = (message) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(message), backgroundColor: Colors.red));
            // PopupMessage.showError(context, message);
          };

          _provider!.onShowNotification = (message) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message), backgroundColor: Colors.green));
            // PopupMessage.showNotification(context, message);
          };

          _provider!.onLogOut = () {
            _provider!.prefs.removeAll();
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false);
          };

          initialise(context);

          return _provider!;
        },
        child: Consumer<T>(
          builder: (context, provider, _) {
            _provider = provider;

            state() {
              switch (provider.state) {
                case ChangeState.clone:
                  return Container(child: builder.call());
                case ChangeState.blank:
                  return const Scaffold();
                case ChangeState.loading:
                  return const LoadingWidget();
                case ChangeState.serverError:
                  return const ServerErrorWidget();
                case ChangeState.page:
                  return builder.call();
                default:
                  return builder.call();
              }
            }

            return VisibilityDetector(
              onVisibilityChanged: (info) {
                if (info.visibleFraction >= 1) {
                  try {
                    _provider!.appear();
                  } catch (_) {}
                } else if (info.visibleFraction <= 0) {
                  try {
                    // _provider.disAppear();
                  } catch (_) {}
                }
              },
              key: Key(T.toString()),
              child: GestureDetector(
                child: state(),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              ),
            );
          },
        ),
      );
}
