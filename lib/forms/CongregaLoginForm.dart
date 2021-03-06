import 'package:congrega/forms/inputs/PasswordFormInput.dart';
import 'package:congrega/forms/inputs/UsernameFormInput.dart';
import 'package:congrega/login/LoginBloc.dart';
import 'package:congrega/login/LoginEvent.dart';
import 'package:congrega/login/LoginState.dart';
import 'package:congrega/ui/CongregaCallToActionAnimatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'CongregaTextFormField.dart';

class CongregaLoginForm extends StatelessWidget {

  final double _scale;
  final int delayedAmount;
  final AnimationController _controller;

  CongregaLoginForm(this._scale, this.delayedAmount, this._controller);

  @override
  Widget build(BuildContext context){
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(errorMessage(state))),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(4)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(_scale, delayedAmount, _controller),
          ],
        ),
      ),
    );
  }

  String errorMessage(LoginState state){
    String error = "";

    if(state.username.error == UsernameValidationError.empty)
      error += "your username";

    if(error.isNotEmpty) error += " and ";

    if(state.password.error == PasswordValidationError.empty)
      error += "your password";


    return "Please, enter " + error + ".";
  }

}
class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {

        return CongregaTextFormField(
            key: const Key('loginForm_usernameInput_textField'),
            hintText: "Username",
            errorText: state.username.invalid ? 'invalid username' : null, //"Username can't be empty",
            icon: Icons.account_circle_sharp,
            obscureText: false,
            onChanged: (username) => context.read<LoginBloc>().add(LoginUsernameChanged(username))
        );

      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => ((previous.password != current.password) ||
          (previous.passwordVisibility != current.passwordVisibility)),
      builder: (context, state) {
        return CongregaTextFormField(
            key: const Key('signUpForm_passwordInput_textField'),
            hintText: "Password",
            errorText: state.password.invalid
                ? "Password can't be empty"
                : null,
            icon: Icons.vpn_key,
            obscureText: !state.passwordVisibility,
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            suffixIcon: IconButton(
                icon: Icon(
                    !state.passwordVisibility ? Icons.visibility : Icons.visibility_off,
                    color: Theme
                        .of(context)
                        .primaryColorDark),
                onPressed: () {
                  context.read<LoginBloc>().add(LoginPasswordVisibilityChanged(!state.passwordVisibility));
                }
            )
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {

  final double _scale;
  final int delayedAmount;
  final AnimationController _controller;
  final String confirmationButtonMessage = "Login";

  _LoginButton(this._scale, this.delayedAmount, this._controller);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : CongregaCallToActionAnimatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          enabled: state.status.isValid,
          scale: _scale,
          controller: _controller,
          buttonText: confirmationButtonMessage,
          callback: state.status.isValidated ? () {
            context.read<LoginBloc>().add(const LoginSubmitted());
          } : null,
        );
      },
    );
  }
}