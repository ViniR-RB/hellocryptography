import 'package:flutter/foundation.dart';

import '../states/signup_state.dart';

class SingupController extends ValueNotifier<SignUpState> {
  SingupController() : super(SignUpInitialState());



  
  emit(SignUpState state) {
    super.value = state;
  }
}
