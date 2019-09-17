package com.example.flutter_plugin;


import org.fourthline.cling.model.meta.Device;
import org.fourthline.cling.model.meta.Service;
import org.fourthline.cling.model.types.ServiceType;
import org.fourthline.cling.model.types.UDAServiceType;
import org.fourthline.cling.registry.DefaultRegistryListener;
import org.fourthline.cling.registry.Registry;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import android.os.Handler;
import android.os.Looper;

import io.flutter.plugin.common.EventChannel.EventSink;

public class BrowseRegistryListener extends DefaultRegistryListener {
    private ArrayList<Device> mDeviceList = new ArrayList<>();
    private ArrayList<HashMap> flutterDeviceList = new ArrayList<>();
    private static final ServiceType AV_TRANSPORT_SERVICE = new UDAServiceType("AVTransport");
    public static EventSink eventSink;

    private Handler handler  = new Handler(Looper.getMainLooper());

    Service getDeviceForUuid(String uuid) {
        int i = 0;
        for (; i < mDeviceList.size(); i ++) {
            String currentUuid = mDeviceList.get(i).getIdentity().getUdn().getIdentifierString();
            if (currentUuid.equals(uuid)) {
                break;
            }
        }
        System.out.println(mDeviceList.get(i));
        return mDeviceList.get(i).findService(AV_TRANSPORT_SERVICE);
    }
    ArrayList<HashMap> getDevices() {
        return this.flutterDeviceList;
    }
    void clearDevices() {
        this.mDeviceList.clear();
        this.flutterDeviceList.clear();
    }
    @Override
    public void deviceAdded(Registry registry, Device device) {
        URL ip = device.getDetails().getBaseURL();
        // if (ip == null) {
        //     return;
        // }
        HashMap fd = new HashMap();
        fd.put("name", device.getDetails().getFriendlyName());
//        fd.put("display", device.getDisplayString());
        fd.put("uuid", device.getIdentity().getUdn().getIdentifierString());
        fd.put("ip", ip == null ? "Unknown" : ip.toString());
        if (flutterDeviceList.indexOf(fd) != -1) {
            return;
        }
        super.deviceAdded(registry, device);
        mDeviceList.add(device);
        flutterDeviceList.add(fd);
        System.out.println("-----get device-------");
        System.out.println(device);
        System.out.println(mDeviceList);
        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        if (BrowseRegistryListener.eventSink != null) {
                            BrowseRegistryListener.eventSink.success(flutterDeviceList);
                        }
                    }
                });
    }

    @Override
    public void deviceRemoved(Registry registry, Device device) {
        super.deviceRemoved(registry, device);
        mDeviceList.remove(device);
        for (int i = 0; i < flutterDeviceList.size(); i ++) {
            HashMap m = flutterDeviceList.get(i);
            if (device.getIdentity().getUdn().getIdentifierString() == m.get("uuid")) {
                flutterDeviceList.remove(i);
                break;
            }
        }

        handler.post(
                new Runnable() {
                    @Override
                    public void run() {
                        if (BrowseRegistryListener.eventSink != null) {
                            BrowseRegistryListener.eventSink.success(flutterDeviceList);
                        }
                    }
                });

    }
}
