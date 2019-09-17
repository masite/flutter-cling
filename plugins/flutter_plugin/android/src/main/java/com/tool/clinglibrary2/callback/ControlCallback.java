package com.tool.clinglibrary2.callback;

/**
 * Created by lzan13 on 2018/3/10.
 * 投屏控制回调
 */
public interface ControlCallback {
    void onSuccess();

    void onError(int code, String msg);
}
