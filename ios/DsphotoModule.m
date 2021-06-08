#import "DsphotoModule.h"

@implementation DsphotoModule

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}


RCT_EXPORT_MODULE()

NSString *_editImagePath = nil;

RCTResponseSenderBlock _onDoneEditing = nil;
RCTResponseSenderBlock _onCancelEditing = nil;

- (void)doneEditingWithImage:(UIImage *)image {
    if (_onDoneEditing == nil) return;

    NSError* error;

    BOOL isPNG = [_editImagePath.pathExtension.lowercaseString isEqualToString:@"png"];
    NSString* path = _editImagePath;

    if ([path containsString:@"file://"]) {
        NSURL *url = [NSURL URLWithString:_editImagePath];
        path = url.path;
    }

    [isPNG ? UIImagePNGRepresentation(image) : UIImageJPEGRepresentation(image, 0.8) writeToFile:path options:NSDataWritingAtomic error:&error];

    if (error != nil)
        NSLog(@"write error %@", error);

    _onDoneEditing(@[path]);
}

- (void)canceledEditing {
    if (_onCancelEditing == nil) return;

    _onCancelEditing(@[]);
}

RCT_EXPORT_METHOD(Edit:(NSString *)path onDone:(RCTResponseSenderBlock)onDone onCancel:(RCTResponseSenderBlock)onCancel) {

    dispatch_async(dispatch_get_main_queue(), ^{
        _editImagePath = path;//[props objectForKey: @"path"];

        _onDoneEditing = onDone;
        _onCancelEditing = onCancel;

        PhotoEditorViewController *photoEditor = [[PhotoEditorViewController alloc] initWithNibName:@"PhotoEditorViewController" bundle: [NSBundle bundleForClass:[PhotoEditorViewController class]]];

        // Process Image for Editing
        UIImage *image = [UIImage imageWithContentsOfFile:_editImagePath];
        if (image == nil) {
            NSURL *url = [NSURL URLWithString:_editImagePath];
            NSData *data = [NSData dataWithContentsOfURL:url];

            image = [UIImage imageWithData:data];
        }

        photoEditor.image = image;

        /*// Process Stickers
        NSArray *stickers =@[@"sticker0", @"sticker1",@"sticker3",@"sticker4",@"sticker5",@"sticker6",@"sticker7",@"sticker8",@"sticker9",@"sticker10"];
        NSMutableArray *imageStickers = [[NSMutableArray alloc] initWithCapacity:stickers.count];

        for (NSString *sticker in stickers) {
            [imageStickers addObject: [UIImage imageNamed: sticker]];
        }

        photoEditor.stickers = imageStickers;

        //Process Controls
        NSArray *hiddenControls = @[@"clear", @"crop",@"draw",@"save",@"share",@"sticker",@"text"];
        NSMutableArray *passHiddenControls = [[NSMutableArray alloc] initWithCapacity:hiddenControls.count];

        for (NSString *hiddenControl in hiddenControls) {
            [passHiddenControls addObject: [[NSString alloc] initWithString: hiddenControl]];
        }

        photoEditor.hiddenControls = passHiddenControls;

        //Process Colors
        NSArray *colors = @[@"#000000", @"#808080",@"#a9a9a9",@"#FFFFFE",@"#0000ff",@"#00ff00",@"#ff0000"];
        NSMutableArray *passColors = [[NSMutableArray alloc] initWithCapacity:colors.count];

        for (NSString *color in colors) {
            [passColors addObject: [self colorWithHexString: color]];
        }

        photoEditor.colors = passColors;*/

        // Invoke Editor
        photoEditor.photoEditorDelegate = self;

    // The default modal presenting is page sheet in ios 13, not full screen
    if (@available(iOS 13, *)) {
            [photoEditor setModalPresentationStyle: UIModalPresentationFullScreen];
        }

        id<UIApplicationDelegate> app = [[UIApplication sharedApplication] delegate];
        UINavigationController *rootViewController = ((UINavigationController*) app.window.rootViewController);

        if (rootViewController.presentedViewController) {
            [rootViewController.presentedViewController presentViewController:photoEditor animated:YES completion:nil];
            return;
        }

        [rootViewController presentViewController:photoEditor animated:YES completion:nil];
    });
}


- (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

- (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

/*// Example method
// See // https://reactnative.dev/docs/native-modules-ios
RCT_REMAP_METHOD(multiply,
                 multiplyWithA:(nonnull NSNumber*)a withB:(nonnull NSNumber*)b
                 withResolver:(RCTPromiseResolveBlock)resolve
                 withRejecter:(RCTPromiseRejectBlock)reject)
{
  NSNumber *result = @([a floatValue] * [b floatValue]);

  resolve(result);
}

RCT_EXPORT_METHOD(LaunchDSPhoto:(NSString *)path option:(NSArray *)options errorCallback: (RCTResponseSenderBlock)errorCallback
    successCallback: (RCTResponseSenderBlock)successCallback)
{
  RCTLogInfo(@"Pretending to launch %@ with %@", path, options);
  self.errorCB = errorCallback;
  self.successCB = successCallback;
  UIImage * image = [[UIImage alloc] initWithContentsOfFile:path];
  //NSArray *toolsToHide = @[@(TOOL_DRAW), @(TOOL_CIRCLE),@(TOOL_CROP)];

  dispatch_async(dispatch_get_main_queue(), ^{
    DSPhotoEditorViewController *dsPhotoEditorController = [[DSPhotoEditorViewController alloc] initWithImage:image toolsToHide:options];
    dsPhotoEditorController.delegate = self;
    //dsPhotoEditorController.modalPresentationStyle = UIModalPresentationFullScreen;
    dsPhotoEditorController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
      [[self getRootVC] presentViewController:dsPhotoEditorController animated:YES completion:nil];
  });
  
}

- (UIViewController*) getRootVC {
    UIViewController *root = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (root.presentedViewController != nil) {
        root = root.presentedViewController;
    }
    
    return root;
}

- (void)dsPhotoEditor:(DSPhotoEditorViewController *)editor finishedWithImage:(UIImage *)image {
    //NSLog(@"done");
    [editor dismissViewControllerAnimated:YES completion:nil];
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil)
    {
        data = UIImageJPEGRepresentation(image, 1.0);
    }
    else
    {
        data = UIImagePNGRepresentation(image);
    }
    
    //图片保存的路径
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //生成唯一字符串
    NSString* uuid = [[NSUUID UUID] UUIDString];
    
    //文件名
    NSString* fileName = [NSString stringWithFormat:@"%@.png", uuid];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为XXXXXXXX-XXXX-XXXX....XXXX.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:fileName] contents:data attributes:nil];
    
    
    //得到选择后沙盒中图片的完整路径
    NSString *filePath = [[NSString alloc]initWithFormat:@"%@%@", DocumentsPath, fileName];
    _successCB(@[filePath]);
    
}

- (void)dsPhotoEditorCanceled:(DSPhotoEditorViewController *)editor {
    //NSLog(@"cancel");
    [editor dismissViewControllerAnimated:YES completion:nil];
    _errorCB(@[@"cancel"]);
  
}*/

@end
