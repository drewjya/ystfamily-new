// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ystfamily/src/core/api/api_exception.dart';
import 'package:ystfamily/src/core/common/image_picker.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/model/dto/update_profile.dart';
import 'package:ystfamily/src/features/auth/provider/auth_provider.dart';
import 'package:ystfamily/src/features/auth/provider/change_provider.dart';
import 'package:ystfamily/src/features/auth/view/register_screen.dart';

class VCircleImage extends HookWidget {
  final double radius;
  final VoidCallback? onTap;
  final Uint8List? file;
  final String? url;
  const VCircleImage({
    Key? key,
    this.radius = 65,
    this.onTap,
    this.file,
    this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? foregroundImage;
    if (file != null) {
      foregroundImage = ClipOval(
        child: Image.memory(
          file!,
          height: radius * 2,
          width: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    } else if (url != null) {
      foregroundImage = ClipOval(
        child: Image.network(
          url!,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }

            return CircularProgressIndicator(
              color: Colors.white,
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      (loadingProgress.expectedTotalBytes ?? 1)
                  : null,
            );
          },
          height: radius * 2,
          width: radius * 2,
          fit: BoxFit.cover,
        ),
      );
    }

    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(100),
        child: Ink(
          child: CircleAvatar(
            radius: radius,
            backgroundColor: VColor.darkBrown,
            child: foregroundImage ?? const Text("Pilih Gambar"),
          ),
        ),
      ),
    );
  }
}

class EditProfileScreen extends HookConsumerWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final dialogShown = useState(false);
    final namaController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    final selectedGender = useState<Gender>(Gender.laki);
    final newFile = useState<XFile?>(null);
    final uint8List = useState<Uint8List?>(null);
    useEffect(() {
      final user = ref.read(authProvider);
      namaController.text = user.value?.nama ?? "";
      phoneNumberController.text = user.value?.phoneNumber ?? "";
      selectedGender.value = Gender.values.firstWhereOrNull(
              (element) => element.value == user.value?.gender) ??
          Gender.laki;
      return;
    }, []);
    ref.listen(changePasswordProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data.isNotEmpty) {
            ref.invalidate(authProvider);
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            if (dialogShown.value) {
              dialogShown.value = false;
              Navigator.pop(context);
            }
            Navigator.pop(context);
          }
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          if (dialogShown.value) {
            dialogShown.value = false;
            Navigator.pop(context);
          }
          String message = "Silahkan coba lagi";
          if (error is ApiException) {
            message = (error).message;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
            ),
          );
        },
        loading: () {
          dialogShown.value = true;
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      );
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: VColor.primaryBackground,
      ),
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                VCircleImage(
                  onTap: () async {
                    final file = await ref
                        .read(pickProvider)
                        .pickImageMobile(source: ImageSource.gallery);
                    newFile.value = file;
                    if (file == null) {
                      return;
                    }
                    uint8List.value = await file.readAsBytes();
                  },
                  file: uint8List.value,
                  url: ref.watch(authProvider
                      .select((value) => value.asData?.value.profilePicture)),
                ),
                const Gap(12),
                TextFormField(
                  controller: namaController,
                  decoration: inputStyle.copyWith(
                    labelText: "Nama Lengkap",
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return "Nama tidak boleh kosong";
                    }
                  },
                ),
                const Gap(12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Jenis Kelamin"),
                    const Gap(8),
                    ChoiceChip.elevated(
                      label: Text(Gender.laki.value),
                      selected: selectedGender.value == Gender.laki,
                      onSelected: (value) {
                        selectedGender.value = Gender.laki;
                      },
                    ),
                    const Gap(8),
                    ChoiceChip.elevated(
                      label: Text(Gender.perempuan.value),
                      selected: selectedGender.value == Gender.perempuan,
                      onSelected: (value) {
                        selectedGender.value = Gender.perempuan;
                      },
                    ),
                  ],
                ),
                TextFormField(
                  controller: phoneNumberController,
                  keyboardType:
                      const TextInputType.numberWithOptions(signed: true),
                  decoration: inputStyle.copyWith(
                    labelText: "No. Telp",
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    } else {
                      return null;
                    }
                  },
                ),
                const Gap(24),
                VCard.horizontal(
                  onTap: () {
                    //     ref.watch(authProvider.select((value) => value.isLoading))
                    // ? null
                    // :
                    if (formKey.currentState?.validate() ?? false) {
                      final user = ref.read(authProvider).asData?.value;
                      log(phoneNumberController.text);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      ref
                          .read(authProvider.notifier)
                          .updateProfile(
                              params: UpdateProfileDTO(
                            gender: selectedGender.value.value,
                            nama: user?.nama == namaController.text ||
                                    namaController.text.isEmpty
                                ? null
                                : namaController.text,
                            phoneNumber: user?.phoneNumber ==
                                        phoneNumberController.text ||
                                    phoneNumberController.text.isEmpty
                                ? null
                                : phoneNumberController.text,
                            profilePicture: newFile.value,
                          ))
                          .then((value) {
                        value.maybeWhen(
                          orElse: () {},
                          data: (data) {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Berhasil memperbarui profil"),
                              ),
                            );
                            Navigator.pop(context);
                          },
                          error: (error, stackTrace) {
                            ScaffoldMessenger.of(context)
                                .removeCurrentSnackBar();
                            Navigator.pop(context);
                            String message = "Silahkan coba lagi";
                            if (error is ApiException) {
                              message = (error).message;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(message),
                              ),
                            );
                          },
                        );
                      });
                      // ref.read(changePasswordProvider.notifier).changePassword(oldPassword: oldPassword.text, newPassword: newPassword.text);
                    }
                    // const OTPRoute(email: "a@gmail.com").push(context);
                  },
                  child: const Center(
                    child: Text(
                      "Perbarui Profile",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
