import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../model/scrip_info_model.dart';
import '../../util/Dataconstants.dart';
import '../../util/Utils.dart';

class BidAskScreen extends StatefulWidget {
  final ScripInfoModel model;
  final BuildContext modalContext;

  BidAskScreen(
    this.model, {
    this.modalContext,
  });

  @override
  State<BidAskScreen> createState() => _BidAskScreenState();
}

class _BidAskScreenState extends State<BidAskScreen> {
  bool viewMore = false;

  @override
  void initState() {
    widget.model.resetBidOffer();
    Dataconstants.iqsClient
        .sendMarketDepthRequest(widget.model.exch, widget.model.exchCode, true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            Text(
              'MARKET DEPTH',
              style: Utils.fonts(size: 12.0, fontWeight: FontWeight.w500, color: Utils.greyColor),
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Divider(),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Qty', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Text('Ord', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Text('Bid', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.darkGreenColor)),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: size.width * 0.43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Offer', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.darkRedColor)),
                          Text('Ord', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                          Text('Qty', style: Utils.fonts(size: 11.0, fontWeight: FontWeight.w400, color: Utils.greyColor)),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Observer(
                                builder: (_) => Text(widget.model.bidQty1.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidQty2.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidQty3.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidQty4.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidQty5.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Observer(
                                builder: (_) => Text(widget.model.bidOrder1.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidOrder2.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidOrder3.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidOrder4.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.bidOrder5.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkGreenColor,
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.bidRate1.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkGreenColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.bidRate1.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.bidRate2.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkGreenColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.bidRate2.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.bidRate3.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkGreenColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.bidRate3.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.bidRate4.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkGreenColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.bidRate4.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.bidRate5.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkGreenColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.bidRate5.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: size.width * 0.43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.offerRate1.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkRedColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.offerRate1.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.offerRate2.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkRedColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.offerRate2.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.offerRate3.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkRedColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.offerRate3.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.offerRate4.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkRedColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.offerRate4.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => InkWell(
                                  child: Text(widget.model.offerRate5.toStringAsFixed(widget.model.precision),
                                      style: Utils.fonts(
                                        size: 11.0,
                                        fontWeight: FontWeight.w400,
                                        color: Utils.darkRedColor,
                                      )),
                                  onTap: () {
                                    if (widget.modalContext != null) {
                                      Navigator.of(widget.modalContext).pop(widget.model.offerRate5.toStringAsFixed(widget.model.precision));
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Observer(
                                builder: (_) => Text(widget.model.offerOrder1.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerOrder2.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerOrder3.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerOrder4.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerOrder5.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Observer(
                                builder: (_) => Text(widget.model.offerQty1.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerQty2.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerQty3.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerQty4.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Observer(
                                builder: (_) => Text(widget.model.offerQty5.toString(),
                                    style: Utils.fonts(
                                      size: 11.0,
                                      fontWeight: FontWeight.w400,
                                      color: Utils.darkRedColor,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Observer(
                            builder: (_) => Text(widget.model.totalBuyQty.toString(),
                                style: Utils.fonts(
                                  size: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Utils.darkGreenColor,
                                )),
                          ),
                          Text('Total Bid',
                              style: Utils.fonts(
                                size: 11.0,
                                fontWeight: FontWeight.w400,
                                color: Utils.darkGreenColor,
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: size.width * 0.43,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Observer(
                            builder: (_) => Text(widget.model.totalSellQty.toString(),
                                style: Utils.fonts(
                                  size: 11.0,
                                  fontWeight: FontWeight.w500,
                                  color: Utils.darkRedColor,
                                )),
                          ),
                          Text('Total Offer',
                              style: Utils.fonts(
                                size: 11.0,
                                fontWeight: FontWeight.w400,
                                color: Utils.darkRedColor,
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
                Divider(),
                // const SizedBox(height: 20,),
                // GestureDetector(
                //   onTap: () {
                //     setState(() {
                //       viewMore = !viewMore;
                //     });
                //   },
                //   child: Text('View 20 Depth',
                //     style: Utils.fonts(
                //     size: 16.0,
                //     fontWeight: FontWeight.w500,
                //       textDecoration: TextDecoration.underline
                //   ),),
                // )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
