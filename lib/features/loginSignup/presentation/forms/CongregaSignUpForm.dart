import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpBloc.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpEvent.dart';
import 'package:congrega/features/loginSignup/presentation/bloc/signup/SignUpState.dart';
import 'package:congrega/ui/CongregaCallToActionAnimatedButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import 'CongregaTextFormField.dart';

class CongregaSignUpForm extends StatelessWidget {
  final double _scale;
  final int delayedAmount;
  final AnimationController _controller;

  CongregaSignUpForm(this._scale, this.delayedAmount, this._controller);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _NameInput(),
              const Padding(padding: EdgeInsets.all(4)),
              _UsernameInput(),
              const Padding(padding: EdgeInsets.all(4)),
              _PasswordInput(),
              const Padding(padding: EdgeInsets.all(12)),
              _SignUpButton(_scale, delayedAmount, _controller),
            ],
          ),
        ),
    );
  }
}

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
        buildWhen: (previous, current) => previous.name != current.name,
        builder: (context, state) {
          return CongregaTextFormField(
            key: const Key('signUpForm_nameInput_textField'),
            hintText: "Name (optional)",
            errorText: state.name.invalid ? 'Empty name' : '', //"Username can't be empty",
            icon: Icons.assignment_ind_rounded,
            obscureText: false,
            onChanged: (name) => context.read<SignUpBloc>().add(SignUpNameChanged(name)),
          );
        }
    );
  }

}

class _UsernameInput extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return CongregaTextFormField(
            key: const Key('signUpForm_usernameInput_textField'),
            hintText: "Username",
            errorText: state.username.invalid ? 'Invalid username' : "", //"Username can't be empty",
            icon: Icons.account_circle_sharp,
            obscureText: false,
            onChanged: (username) => context.read<SignUpBloc>().add(SignUpUsernameChanged(username)),
            );
        }
    );
  }
  
}

class _PasswordInput extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => ((previous.password != current.password) ||
                (previous.passwordVisible != current.passwordVisible)),
      builder: (context, state) {
        return CongregaTextFormField(
            key: const Key('loginForm_passwordInput_textField'),
            hintText: "Password (min 8 char)",
            errorText: state.password.invalid
                ? "Password can't be empty"
                : "",
            icon: Icons.vpn_key,
            obscureText: !state.passwordVisible,
            onChanged: (password) =>
                context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
            suffixIcon: IconButton(
                icon: Icon(
                    !state.passwordVisible ? Icons.visibility : Icons.visibility_off,
                    color: Theme
                        .of(context)
                        .primaryColorDark),
                onPressed: () {
                  context.read<SignUpBloc>().add(SignUpPasswordVisibilityChanged(!state.passwordVisible));
                  }
            )
        );
      },
    );
  }
}

class _SignUpButton extends StatelessWidget {
  final double _scale;
  final int delayedAmount;
  final AnimationController _controller;
  final String confirmationButtonMessage = "Submit";

  _SignUpButton(this._scale, this.delayedAmount, this._controller);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : CongregaCallToActionAnimatedButton(
          key: const Key('signUpForm_continue_raisedButton'),
          enabled: state.status.isValid,
          scale: _scale,
          controller: _controller,
          buttonText: confirmationButtonMessage,
          callback: state.status.isValidated ? () {
            context.read<SignUpBloc>().add(const SignUpSubmitted());
          } : null,
        );
      },
    );
  }
}