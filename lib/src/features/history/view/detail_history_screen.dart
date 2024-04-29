// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:collection/collection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ystfamily/src/core/common/image_picker.dart';
import 'package:ystfamily/src/core/core.dart';
import 'package:ystfamily/src/features/order/model/detail_order.dart';
import 'package:ystfamily/src/features/order/order.dart';
import 'package:ystfamily/src/features/order/provider/detail_order_provider.dart';
import 'package:ystfamily/src/features/order/provider/order_provider.dart';

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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Berhasil Kirim Bukti Pembayaran")));
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
                  separatorBuilder: (context, index) {
                    return const Gap(12);
                  },
                  padding: const EdgeInsets.all(24),
                  itemCount: 10,
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
                                Text(data.status),
                              ],
                            ),
                            const Gap(8),
                            ...data.treatments.mapIndexed(
                              (i, e) {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(child: Text(e.treatmentName)),
                                        Text(formatCurrency.format(e.price))
                                      ],
                                    ),
                                    if (i != data.treatments.length - 1)
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
                          Text(data.orderNumber)
                        ],
                      );
                    }
                    if (index == 2) {
                      return Row(
                        children: [
                          const Text("Tanggal Booking"),
                          const Spacer(),
                          Text(
                            DateTime.parse(data.bookingTime)
                                .formatTimePesanan(),
                          )
                        ],
                      );
                    }
                    if (index == 3) {
                      return Row(
                        children: [
                          const Text("Tanggal Konfirmasi"),
                          const Spacer(),
                          Text(
                            data.confirmationDate == null
                                ? "Menunggu Konfirmasi"
                                : DateTime.parse(data.confirmationDate!)
                                    .formatTimePesanan(),
                          )
                        ],
                      );
                    }

                    if (index == 4) {
                      return Row(
                        children: [
                          const Text("Durasi Treatment"),
                          const Spacer(),
                          Text(
                            data.treatments.time,
                          ),
                        ],
                      );
                    }
                    if (index == 5) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              const Text("Cabang"),
                              const Spacer(),
                              Text(data.cabangNama),
                            ],
                          ),
                          const Gap(12),
                          Row(
                            children: [
                              const Text("Therapist"),
                              const Spacer(),
                              Text(data.therapistNama),
                            ],
                          ),
                        ],
                      );
                    }
                    if (index == 6) {
                      return Row(
                        children: [
                          const Text("Tanggal Treatment"),
                          const Spacer(),
                          Text(data.tanggalTreatment),
                        ],
                      );
                    }

                    if (index == 7) {
                      return Row(
                        children: [
                          const Text("Waktu Treatment"),
                          const Spacer(),
                          Text("${data.orderStartTime} - ${data.orderEndTime}"),
                        ],
                      );
                    }
                    if (index == 8) {
                      return Row(
                        children: [
                          const Text("Total Harga"),
                          const Spacer(),
                          Text(formatCurrency
                              .format(data.treatments.map((e) => e.price).sum)),
                        ],
                      );
                    }
                    if (index == 9) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text("Bukti Pembayaran"),
                              const Spacer(),
                              if (data.buktiBayar == null)
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
                                          ref
                                              .read(orderProvider.notifier)
                                              .postBuktiOrder(
                                                  orderId: data.orderId,
                                                  file: file);
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
                          if (data.buktiBayar != null)
                            InkWell(
                              onTap: () {
                                showImageInteractive(
                                    context, "${data.buktiBayar}");
                              },
                              child: Image.network(
                                "${data.buktiBayar}",
                                height: 120,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress?.cumulativeBytesLoaded !=
                                      loadingProgress?.expectedTotalBytes) {
                                    return Container(
                                      height: 120,
                                      color: VColor.primaryBackground,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: VColor.primaryTextColor,
                                          value: (loadingProgress
                                                      ?.cumulativeBytesLoaded ??
                                                  0) /
                                              (loadingProgress
                                                      ?.expectedTotalBytes ??
                                                  1),
                                        ),
                                      ),
                                    );
                                  }
                                  return child;
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
