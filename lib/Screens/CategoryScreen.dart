import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:wnradio/Model/CategoryModel.dart';
import 'package:wnradio/Network/rest_apis.dart';
import 'package:wnradio/Screens/NewsListScreen.dart';
import 'package:wnradio/Utils/Colors.dart';
import 'package:wnradio/Utils/Common.dart';
import 'package:wnradio/Utils/Extensions.dart';
import 'package:wnradio/Utils/Strings.dart';
import 'package:wnradio/Utils/Widgets.dart';
import 'package:wnradio/Utils/constant.dart';

class CategoryScreen extends StatefulWidget {
  bool isTab = false;

  @override
  _CategoryScreenState createState() => _CategoryScreenState();

  CategoryScreen(this.isTab);
}

class _CategoryScreenState extends State<CategoryScreen> {
  var categoryList = List<CategoriesModel>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    changeStatusColor(white_color);
    fetchCategoryData();
  }

  @override
  void dispose() {
    super.dispose();
    changeStatusColor(white_color);
  }

  Future fetchCategoryData() async {
    setState(() {
      isLoading = true;
    });
    await getCategories().then((res) {
      if (!mounted) return;
      isLoading = false;
      setState(() {
        Iterable mCategory = res;
        categoryList = mCategory.map((model) => CategoriesModel.fromJson(model)).toList();
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        toast(error.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    changeStatusColor(white_color);

//    Widget newsList(List<CategoriesModel> list) {
//      return ListView.builder(
//        itemCount: list.length,
//        shrinkWrap: true,
//        scrollDirection: Axis.vertical,
//        physics: NeverScrollableScrollPhysics(),
//        itemBuilder: (context, i) {
//          return GestureDetector(
//            onTap: () {
//              NewsListScreen(title: list[i].name, id: list[i].id).launch(context);
//            },
//            child: Container(
//                    height: 50,
//                    width: context.width(),
//                    decoration: boxDecoration(bgColor: getColorFromHex(categoryColors[i % categoryColors.length]), radius: 25.0),
//                    child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                      children: [
//                        Center(child: list[i].name.text(style: boldTextStyle(color: white_color, size: textSizeMedium), textAlign: TextAlign.center)),
//                        Center(
//                            child: Icon(
//                          Icons.keyboard_arrow_right,
//                          size: 30,
//                          color: white_color,
//                        )),
//                      ],
//                    ).paddingOnly(left: 16.0, right: 16.0))
//                .paddingAll(12.0),
//          );
//        },
//      );
//    }

    Widget newsList(List<CategoriesModel> list) {
      return ListView.builder(
        itemCount: list.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) {
          return GestureDetector(
            onTap: () {
              NewsListScreen(title: list[i].name, id: list[i].id).launch(context);
            },
            child: Container(
                height: context.height() * 0.15,
                width: context.width(),
                child: Stack(
                  children: [
                    Image.asset(catImg[i % catImg.length],height: context.height(),width: context.width(),filterQuality: FilterQuality.high,fit: BoxFit.cover
                    ).cornerRadiusWithClipRRect(10.0),
                    Container(
                      height: context.height(),
                      width: context.width(),
                      decoration: boxDecoration(bgColor: blackColor.withOpacity(0.4),radius: 10.0),
                      child: Row(
                        children: [
                          Center(
                            child: Container(
                              height: 1.0,
                              width: context.width() * 0.1,
                              color: white_color,
                            ),
                          ).paddingOnly(left: 16.0),
                          8.width,
                          Text(parseHtmlString(list[i].name),style: secondaryTextStyle(color: white_color,size: textSizeNormal),),
                        ],
                      ),
                    )
                  ],
                ))
                .paddingOnly(left: 16,right: 16,top: 6,bottom: 6),
          );
        },
      );
    }


    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: app_Background,
              elevation: 0.0,
              leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: blackColor,
                  ),
                  onPressed: () {
                    finish(context);
                  }).visible(widget.isTab == false),
              title: Text(
                Category,
                style: boldTextStyle(color: textColorPrimary, size: 18),
              ),
            ),
            backgroundColor: app_Background,
            body: RefreshIndicator(
                onRefresh: () {
                  return fetchCategoryData();
                },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    16.height,
                    newsList(categoryList),
                    16.height,
                  ],
                ),
              ),
            ),
          ),
          CircularProgressIndicator().center().visible(isLoading),
        ],
      ),
    );
  }
}
