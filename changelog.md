# Changelog

#### Version 1.5 (working)

#### Version 1.4 (19-Jul-2018)
* Patch e2fsprogs to fix mkfs.ext4 hangs on `getrandom()`

#### Version 1.3 (26-Jun-2018)
* Major merge from upstream to sync up to Nerves 1.0; changelog notes highlights
  but lots of minor and intermediate changes not listed
* Bump `Buildroot` to 2018.02.1
* Bump `fwup` to 1.0
   - Changed signing keys to be base64 encoded
   - Added cmdline params for passing public and private keys via cmdline args
   - Add exit handshake feature to avoid a race condition when reporting update errs
   - Fixes the _SIZE feature for people with raw NAND flashes
* Add `nbtty` experimental package for gadget mode serial issues
* Added a patch to `e2fsprogs` to avoid hanging on a lack of entropy during
  system startup when formating the application partition
* Enable selection of rpi-firmware to support Raspberry Pi ports that want
  to use Linux 4.9 rather than 4.4
* Pull in BR patches required to support the Raspberry Pi 3 B+

#### Version 1.2 (29-Nov-2017)
- Remove Erlang from buildroot config
- Remove Erlang and Elixir/mix dependencies
- Update rpi-userland and rpi-firmware SHAs

#### Version 1.1 (25-Jul-2017)
- Update to Buildroot 2016.11.1
- Bump fwup to v0.13.0
- Bump Buildroot to 2017.02
- Update Raspberry Pi projects to support the Raspberry Pi Zero W
- Bump Buildroot to 2017.05

#### Version 1.0
Fork from nerves_system_br
