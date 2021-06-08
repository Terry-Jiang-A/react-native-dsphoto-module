package ui.photoeditor;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.util.Log;

import androidx.annotation.NonNull;

import com.ahmedadeltito.photoeditor.PhotoEditorActivity;
import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableArray;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.module.annotations.ReactModule;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class DsphotoModule extends ReactContextBaseJavaModule {
    private static final int PHOTO_EDITOR_REQUEST = 1;
    private static final String E_PHOTO_EDITOR_CANCELLED = "E_PHOTO_EDITOR_CANCELLED";


    private Callback mDoneCallback;
    private Callback mCancelCallback;

    private final ActivityEventListener mActivityEventListener = new BaseActivityEventListener() {

      @Override
      public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent intent) {
        if (requestCode == PHOTO_EDITOR_REQUEST) {

          if (mDoneCallback != null) {

            if (resultCode == Activity.RESULT_CANCELED) {
              mCancelCallback.invoke(resultCode);
            } else {
              mDoneCallback.invoke(intent.getExtras().getString("imagePath"));
            }

          }

          mCancelCallback = null;
          mDoneCallback = null;
        }
      }
    };

    public DsphotoModule(ReactApplicationContext reactContext) {
      super(reactContext);

      reactContext.addActivityEventListener(mActivityEventListener);

    }



    @Override
    public String getName() {
      return "DsphotoModule";
    }

    @ReactMethod
    public void Edit(String imagepath, final Callback onDone, final Callback onCancel) {
      Log.d("DSPhotoModule", "Launch DSPhoto with image path: " + imagepath);

      String path = imagepath.substring(6);//imagepath;//props.getString("path");

      //Process Stickers
      List<String> stickers = new ArrayList<String>();//props.getArray("stickers");
      stickers.add("sticker0");
      stickers.add("sticker1");
      stickers.add("sticker2");
      stickers.add("sticker3");
      stickers.add("sticker4");
      stickers.add("sticker5");
      stickers.add("sticker6");
      stickers.add("sticker7");
      stickers.add("sticker8");
      stickers.add("sticker9");
      stickers.add("sticker10");

      ArrayList<Integer> stickersIntent = new ArrayList<Integer>();

      for (int i = 0; i < stickers.size(); i++) {
        int drawableId = getReactApplicationContext().getResources().getIdentifier((String) stickers.get(i)/*stickers.getString(i)*/, "drawable", getReactApplicationContext().getPackageName());

        stickersIntent.add(drawableId);
      }

      //Process Hidden Controls
      //ReadableArray hiddenControls = props.getArray("hiddenControls");
      List<String> hiddenControls = new ArrayList<String>();
      /*hiddenControls.add("clear");
      hiddenControls.add("crop");
      hiddenControls.add("draw");
      hiddenControls.add("save");
      hiddenControls.add("share");
      hiddenControls.add("sticker");
      hiddenControls.add("text");*/


      ArrayList hiddenControlsIntent = new ArrayList<>();

      for (int i = 0; i < hiddenControls.size(); i++) {
        hiddenControlsIntent.add((String) hiddenControls.get(i)/*hiddenControls.getString(i)*/);
      }

      //Process Colors
      //ReadableArray colors = props.getArray("colors");
      List<String> colors = new ArrayList<String>();
      colors.add("#000000");
      colors.add("#808080");
      colors.add("#a9a9a9");
      colors.add("#FFFFFE");
      colors.add("#0000ff");
      colors.add("#00ff00");
      colors.add("#ff0000");
      colors.add("#ffff00");
      colors.add("#ffa500");
      colors.add("#800080");
      colors.add("#00ffff");
      colors.add("#a52a2a");
      colors.add("#ff00ff");

      ArrayList colorPickerColors = new ArrayList<>();

      for (int i = 0;i < colors.size();i++) {
        colorPickerColors.add(Color.parseColor((String) colors.get(i)));
      }


      Intent intent = new Intent(getCurrentActivity(), PhotoEditorActivity.class);
      intent.putExtra("selectedImagePath", path);
      intent.putExtra("colorPickerColors", colorPickerColors);
      intent.putExtra("hiddenControls", hiddenControlsIntent);
      intent.putExtra("stickers", stickersIntent);


      mCancelCallback = onCancel;
      mDoneCallback = onDone;

      getCurrentActivity().startActivityForResult(intent, PHOTO_EDITOR_REQUEST);
    }

    /*public static final String NAME = "DsphotoModule";

    public DsphotoModuleModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }


    // Example method
    // See https://reactnative.dev/docs/native-modules-android
    @ReactMethod
    public void multiply(int a, int b, Promise promise) {
        promise.resolve(a * b);
    }

    public static native int nativeMultiply(int a, int b);*/
}
