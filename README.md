# react-native-proximity

仅提供 iOS 距离传感器的原生状态、变化事件和 React hook，使用 Expo Modules API。音频路由由调用方处理。

## 安装

```sh
bun add @app/react-native-proximity@github:song-react/react-native-proximity
bunx expo prebuild --platform ios
```

需要 Expo 57、React Native 0.86 和 iOS 16.4 或以上；非 Expo 工程需先接入 Expo Modules。新增原生模块后需要重新编译 App，Expo Go 不内置此模块。生产工程建议将 GitHub 依赖固定到具体 commit。

## Hook

```tsx
import { useProximity } from '@app/react-native-proximity';

const near = useProximity(enabled);
```

`enabled` 默认 `true`。返回值为是否靠近传感器；禁用时返回 `false`。每个 hook 只清理自己的监听，最后一个监听移除时关闭原生监控。模块销毁时也会清理。

## 原生接口

```ts
import { proximity } from '@app/react-native-proximity';

proximity.proximityState; // 只读：是否靠近
proximity.isProximityMonitoringEnabled; // 只读：当前是否实际开启监控

const subscription = proximity.addListener(
  'proximityStateDidChange',
  ({ proximityState }) => console.log(proximityState)
);
subscription.remove();
```

首个监听会开启监控，并通知当前状态；最后一个监听移除时关闭。没有传感器的设备不能开启监控，可读取 `isProximityMonitoringEnabled` 确认实际状态。模拟器无法验证真实距离变化。

iOS 的距离监控可能触发系统自动熄屏。这是系统 API 的行为，模块没有单独的熄屏开关，也不处理音频。[Apple 说明](https://developer.apple.com/documentation/uikit/uiapplication/proximitysensingenabled)。
