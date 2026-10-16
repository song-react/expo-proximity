import { NativeModule, requireNativeModule } from 'expo';
import { useCallback, useSyncExternalStore } from 'react';

export const proximity = requireNativeModule<
  NativeModule<{
    proximityStateDidChange: (event: { proximityState: boolean }) => void;
  }> & {
    readonly proximityState: boolean;
    readonly isProximityMonitoringEnabled: boolean;
  }
>('Proximity');

export const useProximity = (enabled = true) =>
  useSyncExternalStore(
    useCallback(
      (onChange: () => void) => {
        if (!enabled) return () => {};
        const _subscription = proximity.addListener(
          'proximityStateDidChange',
          onChange
        );
        return () => _subscription.remove();
      },
      [enabled]
    ),
    () => enabled && proximity.proximityState
  );
