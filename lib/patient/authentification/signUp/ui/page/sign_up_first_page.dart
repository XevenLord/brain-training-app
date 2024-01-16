import 'package:brain_training_app/common/ui/widget/input_segmented_control.dart';
import 'package:brain_training_app/common/ui/widget/input_text_field.dart';
import 'package:brain_training_app/patient/authentification/signUp/ui/view_model/sign_up_controller.dart';
import 'package:brain_training_app/route_helper.dart';
import 'package:brain_training_app/utils/app_constant.dart';
import 'package:brain_training_app/utils/app_text_style.dart';
import 'package:brain_training_app/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignUpFirstPage extends StatefulWidget {
  const SignUpFirstPage({super.key});

  @override
  State<SignUpFirstPage> createState() => _SignUpFirstPageState();
}

class _SignUpFirstPageState extends State<SignUpFirstPage> {
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  late SignUpController signUpController;

  int genderValue = 0;
  List<String> genderList = ["Male", "Female"];

  TextEditingController _nameInput = TextEditingController();
  TextEditingController _icInput = TextEditingController();
  TextEditingController _emailInput = TextEditingController();
  TextEditingController _phoneInput = TextEditingController();
  TextEditingController _dOBInput = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    signUpController = Get.find<SignUpController>();
  }

  void _goNextPage() {
    _fbKey.currentState!.save();
    if (_fbKey.currentState!.saveAndValidate()) {
      signUpController.setFormData(_fbKey.currentState!.value);
      print("proceed to next page");
      Get.toNamed(RouteHelper.getSignUpSecondPage());
    } else {
      print("validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: FormBuilder(
              key: _fbKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(AppConstant.NEUROFIT_LOGO_ONLY,
                            width: 80.w),
                        SizedBox(height: 16.h),
                        Text("Create New Account", style: AppTextStyle.h2),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  InputTextFormField(
                    name: "name",
                    promptText: "Full Name",
                    textEditingController: _nameInput,
                    label: "Enter Your Full Name",
                    keyboardType: TextInputType.name,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your name",
                      ),
                      FormBuilderValidators.minLength(2,
                          errorText: "Your name is too short!"),
                    ]),
                  ),
                  InputTextFormField(
                    name: "ic",
                    promptText: "No. IC",
                    textEditingController: _icInput,
                    label: "Enter Your No. IC",
                    keyboardType: TextInputType.number,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your IC number",
                      ),
                      FormBuilderValidators.equalLength(12,
                          errorText: "Your IC number is not valid!"),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  InputTextFormField(
                    name: "email",
                    promptText: "Email",
                    textEditingController: _emailInput,
                    label: "Enter Your Email",
                    keyboardType: TextInputType.emailAddress,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your email",
                      ),
                      FormBuilderValidators.email(
                          errorText: "Your email is not valid!"),
                    ]),
                  ),
                  InputTextFormField(
                    name: "phone",
                    promptText: "Mobile Number",
                    textEditingController: _phoneInput,
                    label: "Enter Your Phone Number",
                    keyboardType: TextInputType.phone,
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Please enter your phone number",
                      ),
                      FormBuilderValidators.numeric(),
                    ]),
                  ),
                  InputTextFormField(
                    name: "dob",
                    promptText: "Date of Birth",
                    textEditingController: _dOBInput,
                    label: "DD/MM/YYYY",
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2100));

                      if (pickedDate != null) {
                        print(
                            pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                        print(
                            formattedDate); //formatted date output using intl package =>  2021-03-16
                        setState(() {
                          _dOBInput.text =
                              formattedDate; //set output date to TextField value.
                        });
                      } else {}
                    },
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(
                        errorText: "Select your date of birth",
                      ),
                      FormBuilderValidators.dateString(),

                    ]),
                  ),
                  InputFormSegmentedControl(
                    name: "gender",
                    fieldName: "Gender",
                    options: List.generate(
                        genderList.length,
                        (index) => FormBuilderFieldOption(
                            value: genderList[index],
                            child: Text(genderList[index],
                                style: AppTextStyle.h3))).toList(),
                  ),
                  // Password and Confirm Password
                  SizedBox(height: 30.h),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _goNextPage();
                          },
                          child: Text(
                            "Next",
                            style: AppTextStyle.h3,
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.brandBlue),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already a user? ",
                              style: AppTextStyle.h3
                                  .merge(AppTextStyle.blackTextStyle),
                            ),
                            InkWell(
                              onTap: () {
                                Get.offAllNamed(RouteHelper.getSignIn());
                              },
                              child: Text(
                                "Login",
                                style: AppTextStyle.h3.merge(AppTextStyle
                                    .brandBlueTextStyle
                                    .merge(AppTextStyle.underlineTextStyle)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
