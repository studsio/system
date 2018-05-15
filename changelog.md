# Changelog

#### Version 1.3 (working)
* Bump `fwup` to 1.0
   - Changed signing keys to be base64 encoded
   - Added cmdline params for passing public and private keys via cmdline args
   - Add exit handshake feature to avoid a race condition when reporting update errs
   - Fixes the _SIZE feature for people with raw NAND flashes
* Bump `Buildroot` to 2017.11.2
   - Primarily minor package updates throughout, but a change to how the rootfs
     skeleton is maintained affects all systems.  Systems now need to specify a
     custom skeleton or receive an error. The error message has details.
* Add `nbtty` experimental package for gadget mode serial issues
* Added a patch to `e2fsprogs` to avoid hanging on a lack of entropy during
  system startup when formating the application partition

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
