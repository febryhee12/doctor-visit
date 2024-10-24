import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:home_visit/styles/color.dart';
import 'package:home_visit/views/auth/auth_controller.dart';
import 'package:home_visit/widgets/text_btn.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sizer/sizer.dart';

import '../../styles/layout.dart';
import '../../widgets/form_field.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Obx(() => body()),
      ),
    );
  }

  body() {
    return Center(
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: controller.formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120,
                  child: Image.asset(
                    'assets/image.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                fieldUsername(),
                SizedBox(
                  height: 3.h,
                ),
                fieldPassword(),
                SizedBox(
                  height: 3.h,
                ),
                buttonLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  fieldUsername() {
    return CustomFormField().field(
      question: "Username",
      canBeNull: false,
      obscureText: false,
      onChanged: controller.onTextChangedUsername,
      controller: controller.username,
      keyboardType: TextInputType.name,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
      ],
    );
  }

  fieldPassword() {
    return CustomFormField().field(
      question: "Password",
      canBeNull: false,
      obscureText: controller.hidden.value,
      onChanged: controller.onTextChangedPassword,
      controller: controller.password,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp('[ ]')),
      ],
      suffixIcon: IconButton(
        onPressed: () => controller.hidden.toggle(),
        icon: controller.hidden.value == false
            ? const Icon(
                Iconsax.eye,
              )
            : const Icon(
                Iconsax.eye_slash,
              ),
      ),
    );
  }

  buttonLogin() {
    return TextBtn().button(
      width: Layout.width,
      onPressed: () {
        if (controller.isTextFieldUserEmpty.value ||
            controller.isTextFieldPassEmpty.value) {
          null;
        } else {
          controller.auth();
        }
      },
      label: "Masuk",
      backgroundColor: controller.isTextFieldUserEmpty.value ||
              controller.isTextFieldPassEmpty.value
          ? HVColors.grey_300
          : HVColors.primary,
      textStyle: TextStyle(
          fontSize: 12.sp,
          color: controller.isTextFieldUserEmpty.value ||
                  controller.isTextFieldPassEmpty.value
              ? Colors.black26
              : Colors.white),
    );
  }
}
