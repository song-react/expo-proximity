import { NativeModule, requireNativeModule } from 'expo';
import { useCallback, useSyncExternalStore } from 'react';

declare class ProximityModule extends NativeModule<{
  proximityStateDidChange: (event: { proximityState: boolean }) => void;
}> {
  readonly proximityState: boolean;
  readonly isProximityMonitoringEnabled: boolean;
}

export const proximity = requireNativeModule<ProximityModule>('Proximity');

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
