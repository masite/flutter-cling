package com.example.flutter_plugin;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

import com.alibaba.fastjson.JSON;
import com.tool.clinglibrary2.callback.ContentBrowseCallback;
import com.tool.clinglibrary2.entity.ClingDevice;
import com.tool.clinglibrary2.event.DIDLEvent;
import com.tool.clinglibrary2.manager.ClingManager;
import com.tool.clinglibrary2.manager.ControlManager;
import com.tool.clinglibrary2.manager.DeviceManager;
import com.tool.clinglibrary2.service.ClingService;
import com.vmloft.develop.library.tools.VMTools;
import com.vmloft.develop.library.tools.utils.VMLog;

import org.fourthline.cling.model.action.ActionInvocation;
import org.fourthline.cling.model.message.UpnpResponse;
import org.fourthline.cling.model.meta.Service;
import org.fourthline.cling.model.types.ServiceType;
import org.fourthline.cling.model.types.UDAServiceType;
import org.fourthline.cling.support.model.DIDLContent;
import org.fourthline.cling.support.model.Res;
import org.fourthline.cling.support.model.container.Container;
import org.fourthline.cling.support.model.item.Item;
import org.greenrobot.eventbus.EventBus;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * FlutterPlugin
 */
public class FlutterPlugin implements MethodCallHandler, EventChannel.StreamHandler {
    private Activity activity;
    private Context context;

    private static final String CHANNEL_NAME = "tech.shmy.plugins/flutter_dlan/";
    private BrowseRegistryListener browseRegistryListener = new BrowseRegistryListener();
    public static final ServiceType CONTENT_DIRECTORY = new UDAServiceType("ContentDirectory");

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {

        final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL_NAME + "method_channel");
        final EventChannel eventChannel = new EventChannel(registrar.messenger(), CHANNEL_NAME + "event_channel");

        final FlutterPlugin instance = new FlutterPlugin(registrar.activity(), registrar.context());
        channel.setMethodCallHandler(instance);
        eventChannel.setStreamHandler(instance);
    }

    public FlutterPlugin(Activity activity, Context context) {
        this.activity = activity;
        this.context = context;
        VMTools.init(activity.getApplicationContext());
    }

    @Override
    public void onMethodCall(MethodCall call, final Result result) {
        switch (call.method) {
            case "init":
                ClingManager.getInstance().startClingService();
                break;
            case "search":
                Log.d("-------------", "-----------search----------");
                ClingManager.getInstance().startClingService();
                break;
            case "getList":
                new Handler(Looper.getMainLooper()).post(new Runnable() {
                    @Override
                    public void run() {
                        List<ClingDevice> clingDeviceList = DeviceManager.getInstance().getClingDeviceList();

                        final List<Map> mapList = new ArrayList<>();
                        for (int i = 0; i < clingDeviceList.size(); i++) {
                            Map<String, Object> map = new HashMap<>();
                            ClingDevice clingDevice = clingDeviceList.get(i);
                            map.put("isSelected", clingDevice.isSelected());
                            map.put("name", clingDevice.getDevice().getDetails().getFriendlyName());
                            map.put("uuid", clingDevice.getDevice().getIdentity().getUdn().getIdentifierString());

                            URL ip = clingDevice.getDevice().getDetails().getBaseURL();
                            map.put("ip", ip == null ? "Unknown" : ip.toString());
                            mapList.add(map);
                        }
                        result.success(mapList);
                    }
                });
                break;

            case "connectDevice":
                String position = call.argument("position");
                List<ClingDevice> clingDeviceList = DeviceManager.getInstance().getClingDeviceList();
                for (int i = 0; i < clingDeviceList.size(); i++) {
                    ClingDevice clingDevice = clingDeviceList.get(i);
                    if (Integer.parseInt(position) == i) {
                        clingDevice.setSelected(true);
                    } else {
                        clingDevice.setSelected(false);
                    }
                }

                DeviceManager.getInstance().setCurrClingDevice(DeviceManager.getInstance().getClingDeviceList().get(Integer.parseInt(position)));
                break;

            case "playLocal":
                Item item = new Item();

                String title = call.argument("title");
                item.setTitle(title);
                String creator = call.argument("creator");
                item.setCreator(creator);
                String id = call.argument("id");
                item.setId(id);
                String refID = call.argument("refID");
                item.setRefID(refID);

                HashMap value = call.argument("resources");
                item.setTitle(JSON.toJSONString(value));

//                item.setResources(res);

                String s = JSON.toJSONString(value);


                Res res = new Res();
                res.setValue((String) value.get("value"));
//                res.setDuration((String) value.get("duration"));
//                res.setImportUri((URI) value.get("importUri"));
//                res.setSize((Long) value.get("size"));

                List<Res> list = new ArrayList<>();
                list.add(res);
                item.setResources(list);
                Log.d("---->>", "->->->->->" + s);

                ClingManager.getInstance().setLocalItem(item);
//
                MediePalyUtil.getInstance(context).play();

//                Toast.makeText(context, s, Toast.LENGTH_SHORT).show();
                break;

            case "stopPlay":
                MediePalyUtil.getInstance(context).stopCast();
                break;

            case "getLocalImages":
                Service service = ClingManager.getInstance().getClingService().getLocalDevice().findService(CONTENT_DIRECTORY);
                ClingManager.getInstance().getControlPoint().execute(new ContentBrowseCallback(service, "30") {
                    @Override
                    public void received(ActionInvocation actionInvocation, DIDLContent didl) {
                        VMLog.e("Load local content! containers:%d, items:%d", didl.getContainers().size(),
                                didl.getItems().size());

                        final List<Item> didlItems = didl.getItems();
                        final List<Map> mapList = new ArrayList<>();
                        for (int i = 0; i < didlItems.size(); i++) {
                            Item item = didlItems.get(i);
                            Map<String, Object> map = JSON.parseObject(JSON.toJSONString(item));
                            mapList.add(map);
                        }

                        Log.d("test ---  ", ">>>>> " + JSON.toJSONString(didlItems.get(0)));

                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(mapList);//
                            }
                        });

                    }

                    @Override
                    public void failure(ActionInvocation invocation, UpnpResponse operation, String msg) {
                        VMLog.e("Load local content failure %s", msg);
                    }
                });
                break;
            case "localVideos":
                Service service2 = ClingManager.getInstance().getClingService().getLocalDevice().findService(CONTENT_DIRECTORY);
                ClingManager.getInstance().getControlPoint().execute(new ContentBrowseCallback(service2, "20") {
                    @Override
                    public void received(ActionInvocation actionInvocation, DIDLContent didl) {
                        VMLog.e("Load local content! containers:%d, items:%d", didl.getContainers().size(),
                                didl.getItems().size());

                        final List<Item> didlItems = didl.getItems();
                        final List<Map> mapList = new ArrayList<>();
                        for (int i = 0; i < didlItems.size(); i++) {
                            Item item = didlItems.get(i);
                            Map<String, Object> map = JSON.parseObject(JSON.toJSONString(item));
                            mapList.add(map);
                        }

                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(mapList);//
                            }
                        });

                    }

                    @Override
                    public void failure(ActionInvocation invocation, UpnpResponse operation, String msg) {
                        VMLog.e("Load local content failure %s", msg);
                    }
                });
                break;
            case "localAudios":
                Service service3 = ClingManager.getInstance().getClingService().getLocalDevice().findService(CONTENT_DIRECTORY);
                ClingManager.getInstance().getControlPoint().execute(new ContentBrowseCallback(service3, "10") {
                    @Override
                    public void received(ActionInvocation actionInvocation, DIDLContent didl) {
                        VMLog.e("Load local content! containers:%d, items:%d", didl.getContainers().size(),
                                didl.getItems().size());

                        final List<Item> didlItems = didl.getItems();
                        final List<Map> mapList = new ArrayList<>();
                        for (int i = 0; i < didlItems.size(); i++) {
                            Item item = didlItems.get(i);
                            Map<String, Object> map = JSON.parseObject(JSON.toJSONString(item));
                            mapList.add(map);
                        }

                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                result.success(mapList);//
                            }
                        });
                    }

                    @Override
                    public void failure(ActionInvocation invocation, UpnpResponse operation, String msg) {
                        VMLog.e("Load local content failure %s", msg);
                    }
                });
                break;


            default:
                result.notImplemented();

        }

    }

    @Override
    public void onListen(Object o, EventChannel.EventSink eventSink) {
        BrowseRegistryListener.eventSink = eventSink;
    }

    @Override
    public void onCancel(Object o) {
        BrowseRegistryListener.eventSink = null;
    }
}
