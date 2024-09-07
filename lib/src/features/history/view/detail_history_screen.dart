// ignore_for_file: public_member_api_docs, sort_constructors_first
import "package:cached_network_image/cached_network_image.dart";
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/auth/view/otp_screen.dart';
import 'package:ystfamily/src/features/order/model/order_detail.dart';
import 'package:ystfamily/src/features/order/order.dart';

import 'history_page.dart';

_convertOrder(OrderDetailModel detail) {
  if (detail.picture == null) {
    return "Menunggu Pembayaran";
  }
  if (detail.picture != null && detail.confirmationTime == null) {
    return "Menunggu Konfirmasi";
  }
  if (detail.picture != null && detail.confirmationTime != null) {
    return "Selesai";
  }
  return "Menunggu Pembayaran";
}

class DetailHistoryScreen extends HookConsumerWidget {
  const DetailHistoryScreen({super.key, required this.id});
  final int id;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailOrder = ref.watch(detailOrderProvider(id));
    final isLoading = useState(false);
    ref.listen(orderProvider, (previous, next) {
      next.when(
        data: (data) {
          if (data.isEmpty) {
            return;
          }
          if (data.isNotEmpty) {
            if (isLoading.value) {
              isLoading.value = false;
              Navigator.pop(context);
            }

            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            showDialog(
              context: context,
              builder: (context) => AlertDialog.adaptive(
                title: const Text("Notifikasi"),
                content: const Text("Bukti Pembayaran Berhasil Diupload"),
                actions: [
                  ActionButton(
                    isFilled: false,
                    onPressed: () {
                      const HistoryPageRoute().go(context);
                    },
                    text: "Ok",
                  ),
                ],
              ),
            );

            ref.invalidate(detailOrderProvider(id));
          }
        },
        error: (error, stackTrace) {
          if (isLoading.value) {
            isLoading.value = false;
            Navigator.pop(context);
          }
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("$error")));
        },
        loading: () {
          isLoading.value = true;
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
        title: const Text("Detail Booking"),
        backgroundColor: VColor.primaryBackground,
      ),
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          if (detailOrder.map(
              data: (data) => false,
              error: (error) => false,
              loading: (loading) => true)) {
            return;
          }
          ref.invalidate(detailOrderProvider(id));
        },
        child: Container(
            color: Colors.white,
            child: detailOrder.when(
              skipLoadingOnRefresh: false,
              skipLoadingOnReload: false,
              data: (data) {
                return ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  separatorBuilder: (context, index) {
                    return const Gap(12);
                  },
                  padding: const EdgeInsets.all(24),
                  itemCount: 9,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return VCard.horizontal(
                        backgroundColor:
                            VColor.appbarBackground.withOpacity(.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("Status"),
                                const Spacer(),
                                Text(data.orderStatus.toTitle),
                              ],
                            ),
                            const Gap(8),
                            ...data.orderDetail.mapIndexed(
                              (i, e) {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text(e.nama)),
                                        Text(formatCurrency.format(e.price))
                                      ],
                                    ),
                                    if (i != data.orderDetail.length - 1)
                                      const Divider()
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    if (index == 1) {
                      return Row(
                        children: [
                          const Text("Nomor Booking"),
                          const Spacer(),
                          Text(data.orderId)
                        ],
                      );
                    }
                    if (index == 2) {
                      return Row(
                        children: [
                          const Text("Tanggal Treatment"),
                          const Spacer(),
                          Text(
                            data.orderTime.toDate?.formatTimePesanan() ?? "-",
                          )
                        ],
                      );
                    }
                    if (index == 3) {
                      if (data.confirmationTime == null) {
                        return Row(
                          children: [
                            const Text("Status Order"),
                            const Spacer(),
                            Text(
                              _convertOrder(data),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          const Text("Tanggal Konfirmasi"),
                          const Spacer(),
                          Text(data.confirmationTime == null
                              ? "Menunggu Konfirmasi"
                              : DateTime.parse(data.confirmationTime!)
                                  .formatTimePesanan())
                        ],
                      );
                    }

                    if (index == 4) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              const Text("Cabang"),
                              const Spacer(),
                              Text(data.cabang),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Text("Nomor Telepon Cabang"),
                              const Spacer(),
                              Text(data.cabangPhone),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Text("Therapist"),
                              const Spacer(),
                              Text(
                                  "${data.therapist ?? ""} - ${data.therapistGender.gender}"),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Text("Tamu"),
                              const Spacer(),
                              Text(data.guestGender.gender),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Text("No Wa Tamu"),
                              const Spacer(),
                              Text(data.guestPhone),
                            ],
                          ),
                        ],
                      );
                    }
                    if (index == 5) {
                      return Row(
                        children: [
                          const Text("Tanggal Treatment"),
                          const Spacer(),
                          Text(data.orderTime.toDate?.getDate() ?? "-"),
                        ],
                      );
                    }

                    if (index == 6) {
                      return Row(
                        children: [
                          const Text("Jam Treatment"),
                          const Spacer(),
                          Text(data.orderTime.toDate?.getHour() ?? "-"),
                        ],
                      );
                    }
                    if (index == 7) {
                      return Row(
                        children: [
                          const Text("Total Harga"),
                          const Spacer(),
                          Text(formatCurrency.format(data.totalPrice)),
                        ],
                      );
                    }
                    if (index == 8) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Bukti Pembayaran"),
                              const Spacer(),
                              if (data.picture == null)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    VCard.horizontal(
                                      width: -1,
                                      onTap: () async {
                                        showImageInteractive(context, "",
                                            isQr: true);
                                      },
                                      child: const Text("Scan QR Code"),
                                    ),
                                    const Gap(8),
                                    VCard.horizontal(
                                      width: -1,
                                      onTap: () async {
                                        final scaffolMes =
                                            ScaffoldMessenger.of(context);

                                        final file = await ref
                                            .read(pickProvider)
                                            .pickImageMobile(
                                                source: ImageSource.gallery);

                                        if (file != null) {
                                          final size =
                                              await getFileSize(file.path, 2);
                                          final sizeArray = size.split(" ");
                                          if (sizeArray[1] != "KB") {
                                            scaffolMes.showSnackBar(const SnackBar(
                                                content: Text(
                                                    "Ukuran File Harus Kurang Dari 1 MB")));
                                            return;
                                          }

                                          ref
                                              .read(orderProvider.notifier)
                                              .postBuktiOrder(
                                                  orderId: data.id, file: file);
                                          return;
                                        }
                                        scaffolMes.showSnackBar(const SnackBar(
                                            content:
                                                Text("Mohon Pilih Gambar")));
                                      },
                                      child: const Text(
                                          "Kirimkan Bukti Pembayaran"),
                                    ),
                                  ],
                                )
                            ],
                          ),
                          const Gap(8),
                          if (data.picture != null)
                            InkWell(
                              onTap: () {
                                showImageInteractive(
                                    context, "$image${data.picture}");
                              },
                              child: CachedNetworkImage(
                                imageUrl: "$image${data.picture}",
                                height: 240,
                                progressIndicatorBuilder:
                                    (context, url, progress) {
                                  return Center(
                                    child: CircularProgressIndicator.adaptive(
                                      value: progress.progress,
                                      valueColor: const AlwaysStoppedAnimation(
                                          Colors.white),
                                    ),
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
              error: (error, stackTrace) {
                return Center(child: Text("$error"));
              },
              loading: () => const Center(child: CircularProgressIndicator()),
            )),
      ),
    );
  }
}

Future<dynamic> showImageInteractive(BuildContext context, String url,
    {bool isQr = false}) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: InteractiveImageDialog(
          url: url,
          isQr: isQr,
        ),
      );
    },
  );
}

class InteractiveImageDialog extends StatefulWidget {
  final bool isQr;
  final String url;
  const InteractiveImageDialog({
    Key? key,
    required this.isQr,
    required this.url,
  }) : super(key: key);

  @override
  State<InteractiveImageDialog> createState() => _InteractiveImageDialogState();
}

class _InteractiveImageDialogState extends State<InteractiveImageDialog> {
  late TransformationController controller;

  @override
  void initState() {
    controller = TransformationController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: controller,
      onInteractionEnd: (ScaleEndDetails endDetails) {
        controller.value = Matrix4.identity();
      },
      child: widget.isQr
          ? Image.asset("assets/qris.jpeg")
          : Image.network(
              widget.url,
            ),
    );
  }
}
