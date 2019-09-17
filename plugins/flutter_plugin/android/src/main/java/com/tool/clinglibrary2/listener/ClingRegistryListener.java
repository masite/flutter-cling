package com.tool.clinglibrary2.listener;

import com.tool.clinglibrary2.manager.DeviceManager;

import org.fourthline.cling.model.meta.Device;
import org.fourthline.cling.model.meta.LocalDevice;
import org.fourthline.cling.model.meta.RemoteDevice;
import org.fourthline.cling.registry.DefaultRegistryListener;
import org.fourthline.cling.registry.Registry;

/**
 * Created by lzan13 on 2018/3/9.
 * 监听当前局域网设备变化
 */
public class ClingRegistryListener extends DefaultRegistryListener {
    @Override
    public void remoteDeviceDiscoveryStarted(Registry registry, RemoteDevice device) {
//        onDeviceAdded(device);
    }

    @Override
    public void remoteDeviceDiscoveryFailed(Registry registry, RemoteDevice device, Exception ex) {
//        onDeviceRemoved(device);
    }

    @Override
    public void remoteDeviceAdded(Registry registry, RemoteDevice device) {
        onDeviceAdded(device);
    }

    @Override
    public void remoteDeviceRemoved(Registry registry, RemoteDevice device) {
        onDeviceRemoved(device);
    }

    @Override
    public void localDeviceAdded(Registry registry, LocalDevice device) {
//        onDeviceAdded(device);
    }

    @Override
    public void localDeviceRemoved(Registry registry, LocalDevice device) {
//        onDeviceRemoved(device);
    }

    /**
     * 新增 DLNA 设备
     */
    public void onDeviceAdded(Device device) {
        DeviceManager.getInstance().addDevice(device);
    }

    /**
     * 移除 DLNA 设备
     */
    public void onDeviceRemoved(Device device) {
        DeviceManager.getInstance().removeDevice(device);
    }
}
