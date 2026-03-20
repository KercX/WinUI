## Technical Requirements for UI Elements
To keep **WinUI** professional, all new elements must:
1. **Support Themes**: Use the central `THEME` table.
2. **Be Smooth**: Use `EasingStyle.Quart` for all transitions.
3. **Be Optimized**: Use `task.wait()` instead of `wait()`.
4. **Memory Management**: Always clean up connections using `:Disconnect()` if the UI is destroyed.
