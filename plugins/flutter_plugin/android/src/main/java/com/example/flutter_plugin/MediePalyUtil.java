package com.example.flutter_plugin;

import android.content.Context;
import android.util.Log;
import android.widget.Toast;

import com.tool.clinglibrary2.callback.ControlCallback;
import com.tool.clinglibrary2.entity.RemoteItem;
import com.tool.clinglibrary2.manager.ClingManager;
import com.tool.clinglibrary2.manager.ControlManager;

import org.fourthline.cling.support.model.item.Item;

public class MediePalyUtil {

    Context context;
    public static MediePalyUtil mediePalyUtil;
    private Item localItem;
    private RemoteItem remoteItem;

    public static MediePalyUtil getInstance(Context context) {
        if (mediePalyUtil == null) {
            mediePalyUtil = new MediePalyUtil(context);
        }
        return mediePalyUtil;
    }

    public MediePalyUtil(Context context) {
        this.context = context;
    }

    /**
     * 播放开关
     */
    public void play() {
        localItem = ClingManager.getInstance().getLocalItem();
        remoteItem = ClingManager.getInstance().getRemoteItem();

        if (ControlManager.getInstance().getState() == ControlManager.CastState.STOPED) {
            if (localItem != null) {
                newPlayCastLocalContent();
            } else {
                newPlayCastRemoteContent();
            }
        } else if (ControlManager.getInstance().getState() == ControlManager.CastState.PAUSED) {
            playCast();
        } else if (ControlManager.getInstance().getState() == ControlManager.CastState.PLAYING) {
            pauseCast();
        } else {
            Toast.makeText(context, "正在连接设备，稍后操作", Toast.LENGTH_SHORT).show();
        }
    }

    private void newPlayCastLocalContent() {
        ControlManager.getInstance().setState(ControlManager.CastState.TRANSITIONING);
        Log.d("------------ ","->>>>>>>>>>>>>> 1");
        ControlManager.getInstance().newPlayCast(localItem, new ControlCallback() {
            @Override
            public void onSuccess() {
                ControlManager.getInstance().setState(ControlManager.CastState.PLAYING);
                ControlManager.getInstance().initScreenCastCallback();
            }

            @Override
            public void onError(int code, String msg) {
                ControlManager.getInstance().setState(ControlManager.CastState.STOPED);
                Log.d("------------ ","->>>>>>>>>>>>>> onError");
            }
        });
    }

    private void newPlayCastRemoteContent() {
        ControlManager.getInstance().setState(ControlManager.CastState.TRANSITIONING);
        ControlManager.getInstance().newPlayCast(remoteItem, new ControlCallback() {
            @Override
            public void onSuccess() {
                ControlManager.getInstance().setState(ControlManager.CastState.PLAYING);
                ControlManager.getInstance().initScreenCastCallback();
            }

            @Override
            public void onError(int code, String msg) {
                ControlManager.getInstance().setState(ControlManager.CastState.STOPED);
            }
        });
    }

    private void playCast() {
        ControlManager.getInstance().playCast(new ControlCallback() {
            @Override
            public void onSuccess() {
                ControlManager.getInstance().setState(ControlManager.CastState.PLAYING);
            }

            @Override
            public void onError(int code, String msg) {
            }
        });
    }

    private void pauseCast() {
        ControlManager.getInstance().pauseCast(new ControlCallback() {
            @Override
            public void onSuccess() {
                ControlManager.getInstance().setState(ControlManager.CastState.PAUSED);
            }

            @Override
            public void onError(int code, String msg) {
            }
        });
    }

    public void stopCast() {
        ControlManager.getInstance().unInitScreenCastCallback();
        ControlManager.getInstance().stopCast(new ControlCallback() {
            @Override
            public void onSuccess() {
                ControlManager.getInstance().setState(ControlManager.CastState.STOPED);
            }

            @Override
            public void onError(int code, String msg) {
            }
        });
    }

}
