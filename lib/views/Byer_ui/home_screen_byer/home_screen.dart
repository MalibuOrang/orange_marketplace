import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orange_marketplace/constant/consts.dart';
import 'package:orange_marketplace/constant/lists.dart';
import 'package:orange_marketplace/controllers/home_controller.dart';
import 'package:orange_marketplace/services/firestore_services.dart';
import 'package:orange_marketplace/views/Byer_ui/category_screen_byer/item_details.dart';
import 'package:orange_marketplace/views/Byer_ui/home_screen_byer/components/featured_button.dart';
import 'package:orange_marketplace/views/Byer_ui/home_screen_byer/search_screen.dart';
import 'package:orange_marketplace/widgets/home_buttons.dart';
import 'package:orange_marketplace/widgets/loading_indicator.dart';

class HomeScreenByer extends StatelessWidget {
  const HomeScreenByer({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<HomeController>();
    return Container(
      padding: const EdgeInsets.all(12),
      color: lightGrey,
      width: context.screenWidth,
      height: context.screenHeight,
      child: SafeArea(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: 60,
            color: lightGrey,
            child: TextFormField(
              controller: controller.searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                suffixIcon: const Icon(Icons.search).onTap(() {
                  if (controller.searchController.text.isNotEmptyAndNotNull) {
                    Get.to(() => SearchScreenByer(
                          title: controller.searchController.text,
                        ));
                  } else {
                    VxToast.show(context,
                        msg: "You search is empty!",
                        position: VxToastPosition.top);
                  }
                }),
                filled: true,
                fillColor: whiteColor,
                hintText: searchanything,
                hintStyle: const TextStyle(color: textfieldGrey),
              ),
            ),
          ),
          10.heightBox,
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  //Swiper brands
                  VxSwiper.builder(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      height: 150,
                      enableInfiniteScroll: true,
                      itemCount: sliderList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          sliderList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 10))
                            .make();
                      }),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        2,
                        (index) => homeButtons(
                              height: context.screenHeight * 0.15,
                              width: context.screenWidth / 2.5,
                              icon: index == 0 ? icTodaysDeal : icFlashDeal,
                              title: index == 0 ? todayDeal : flashsale,
                            )),
                  ),
                  10.heightBox,
                  //2nd swiper
                  VxSwiper.builder(
                      aspectRatio: 16 / 10,
                      autoPlay: true,
                      height: 150,
                      enableInfiniteScroll: true,
                      itemCount: secondsSliderList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondsSliderList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 10))
                            .make();
                      }),
                  10.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                        3,
                        (index) => homeButtons(
                              height: context.screenHeight * 0.12,
                              width: context.screenWidth / 3.5,
                              icon: index == 0
                                  ? icTopCategories
                                  : index == 1
                                      ? icBrands
                                      : icTopSeller,
                              title: index == 0
                                  ? topCategories
                                  : index == 1
                                      ? brand
                                      : topSellers,
                            )),
                  ),
                  20.heightBox,
                  // featured categories
                  Align(
                    alignment: Alignment.centerLeft,
                    child: featuredCategories.text
                        .color(darkFontGrey)
                        .size(18)
                        .fontFamily(semibold)
                        .make(),
                  ),
                  20.heightBox,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                          3,
                          (index) => Column(
                                children: [
                                  featuredButton(
                                      icon: featuredImages1[index],
                                      title: featuredTitles1[index]),
                                  10.heightBox,
                                  featuredButton(
                                      icon: featuredImages2[index],
                                      title: featuredTitles2[index]),
                                ],
                              )).toList(),
                    ),
                  ),
                  // featured product
                  20.heightBox,
                  Container(
                    padding: const EdgeInsets.all(12),
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: orangeColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        featuredProduct.text.white
                            .fontFamily(bold)
                            .size(18)
                            .make(),
                        10.heightBox,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: FutureBuilder(
                            future: FirestoreServices.getFeaturedProducts(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: loadingIndicator(),
                                );
                              } else if (snapshot.data!.docs.isEmpty) {
                                return "No featured products"
                                    .text
                                    .white
                                    .makeCentered();
                              } else {
                                var featuredData = snapshot.data!.docs;
                                return Row(
                                  children: List.generate(
                                      featuredData.length,
                                      (index) => Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.network(
                                                featuredData[index]['p_imgs']
                                                    [1],
                                                width: 130,
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                              10.heightBox,
                                              "${featuredData[index]['p_name']}"
                                                  .text
                                                  .fontFamily(semibold)
                                                  .color(darkFontGrey)
                                                  .make(),
                                              10.heightBox,
                                              "${featuredData[index]['p_price']}"
                                                  .numCurrency
                                                  .text
                                                  .color(orangeColor)
                                                  .fontFamily(bold)
                                                  .size(16)
                                                  .make(),
                                            ],
                                          )
                                              .box
                                              .white
                                              .margin(
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4))
                                              .roundedSM
                                              .padding(const EdgeInsets.all(8))
                                              .make()
                                              .onTap(() {
                                            Get.to(() => ItemDetailsByer(
                                                  title:
                                                      "${featuredData[index]['p_name']}",
                                                  data: featuredData[index],
                                                ));
                                          })),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // third swiper
                  20.heightBox,
                  VxSwiper.builder(
                      aspectRatio: 16 / 10,
                      autoPlay: true,
                      height: 150,
                      enableInfiniteScroll: true,
                      itemCount: secondsSliderList.length,
                      itemBuilder: (context, index) {
                        return Image.asset(
                          secondsSliderList[index],
                          fit: BoxFit.fill,
                        )
                            .box
                            .rounded
                            .clip(Clip.antiAlias)
                            .margin(const EdgeInsets.symmetric(horizontal: 10))
                            .make();
                      }),
                  // all products section
                  20.heightBox,
                  StreamBuilder(
                    stream: FirestoreServices.allProduct(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return loadingIndicator();
                      } else {
                        var allProductData = snapshot.data!.docs;
                        return GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: allProductData.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  mainAxisExtent: 300),
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  allProductData[index]['p_imgs'][0],
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                const Spacer(),
                                "${allProductData[index]['p_name']}"
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                                10.heightBox,
                                "${allProductData[index]['p_price']}"
                                    .text
                                    .color(orangeColor)
                                    .fontFamily(bold)
                                    .size(16)
                                    .make(),
                                10.heightBox,
                              ],
                            )
                                .box
                                .white
                                .margin(
                                    const EdgeInsets.symmetric(horizontal: 4))
                                .roundedSM
                                .padding(const EdgeInsets.all(12))
                                .make()
                                .onTap(() {
                              Get.to(() => ItemDetailsByer(
                                    title: "${allProductData[index]['p_name']}",
                                    data: allProductData[index],
                                  ));
                            });
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
