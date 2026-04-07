# Home Crash Stabilization Backlog

Last updated: 2026-04-06

## Enhancement options

1. Re-test Home scrolling on a physical iPhone after the inline shortcut change to confirm the semantics crash path is gone.
2. If Home remains stable, consider moving the inline shortcut cluster into a shared non-overlay section pattern so Home keeps parity with other pages without reintroducing overlay risk.
3. Follow up with a second-pass performance audit on Home to decide whether the long `SingleChildScrollView` should eventually migrate to a lazy sliver structure.
4. Review other overlay or build-side-effect patterns across mirrored high-traffic surfaces before the next release pass.
