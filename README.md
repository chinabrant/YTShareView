基于ShareSDK封装的一个分享view
-------------------

加了一个显示和隐藏的动画，里面的分享项可以随便加减，高度会自适应。

#### 使用示例：

```
YTShareModel *shareModel = [[YTShareModel alloc] init];
shareModel.title = @"分享的标题";
shareModel.desc = @"分享的描述";
shareModel.url = @"分享的url";
shareModel.img = @"分享的图片";
[YTShareView showInView:self.navigationController.view shareModel:shareModel completeionHandler:^(bool isSuccess, YTShareType type) {
    // show hud tips
}];
```


