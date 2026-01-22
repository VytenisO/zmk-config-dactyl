# Help me, what am I doing

ZMK firmware configuration for Dactyl Manuform 4x5 split keyboard with Seeed XIAO BLE (nRF52840) controllers.

## Building Firmware

**You don't build locally.** GitHub Actions builds the firmware automatically.

1. Make your changes to config files
2. Commit and push to master branch
3. GitHub Actions runs the build
4. Check build status: `gh run list`

## Downloading Firmware

After a successful build:

```bash
gh run list                    # Find the successful run ID
gh run download <run-id>       # Downloads to ./firmware/ directory
```

The firmware files will be in `firmware/firmware/`:
- `dactyl_manuform_4x5_left-xiao_ble-zmk.uf2`
- `dactyl_manuform_4x5_right-xiao_ble-zmk.uf2`

or wherever else you saved the files to.

## Flashing the Keyboard

1. **Enter bootloader mode** on a controller:
   - Double-tap the reset button quickly
   - Controller appears as USB drive
    - Find and mount it using lsblk, and mount
    - or on windows, figure it out yourself

2. **Copy the firmware**:
   - Drag and drop the appropriate `.uf2` file (left or right) to the USB drive
   - Controller will automatically reboot with new firmware

3. **Repeat** for the other side

## ZMK Studio - Never Open This Thing Again

Listen. You assembled this keyboard. You know what a pain it was. You really
don't want to disassemble it every time you realize you put the wrong key in
the wrong place.

**ZMK Studio lets you change keybindings at runtime** without reflashing
firmware. It's basically VIA/Vial for ZMK.

### How to Use It

This firmware already has ZMK Studio enabled (check `build.yaml` for the `studio-rpc-usb-uart` snippet).

1. **Unlock the keyboard**: Press both layer keys (lower + raise) to access the adjust layer, then press the `studio_unlock` key (it's on the right side, home row index finger position - that's the `H` key position)
2. **Open the editor**: Go to https://zmk.studio/ in Chrome or god forbid Edge
3. **Connect**: Plug in via USB or connect over Bluetooth
4. **Edit away**: Change whatever keys you want
5. **Save**: Your changes persist in flash memory

### Software Bootloader Button

There's also a `&bootloader` binding in the adjust layer (right next to
`studio_unlock`, that's the `J` key position). Press it to enter bootloader
mode without touching the physical reset button. Useful for firmware updates,
but also means anyone with physical access and knowledge of the key combo can
flash malicious firmware in 5 seconds. If that's a problem, you've got bigger
issues than this keyboard.

## File Structure

```
zmk-config/
├── build.yaml                          # Defines what boards to build
├── config/
│   ├── west.yml                       # ZMK repository reference
│   └── boards/shields/dactyl_manuform_4x5/
│       ├── dactyl_manuform_4x5.keymap        # Key mappings and layers
│       ├── dactyl_manuform_4x5.dtsi          # Matrix configuration
│       ├── dactyl_manuform_4x5_left.overlay  # Left side pin config
│       ├── dactyl_manuform_4x5_right.overlay # Right side pin config
│       ├── Kconfig.defconfig
│       └── Kconfig.shield
└── firmware/firmware/                  # Downloaded .uf2 files go here
```
## Resources

- [ZMK Studio Web Editor](https://zmk.studio/) - Change keymaps without reflashing
- [ZMK Studio Documentation](https://zmk.dev/docs/features/studio)
- [ZMK Documentation](https://zmk.dev/docs)
- [Supported Hardware](https://zmk.dev/docs/hardware)
- [XIAO BLE Info](https://wiki.seeedstudio.com/XIAO_BLE/)
