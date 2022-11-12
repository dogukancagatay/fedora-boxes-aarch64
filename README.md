
# Fedora Parallels Vagrant Boxes for Mac aarch64 (arm64)

Generic base Fedora boxes, providing Vagrant boxes for arm64/aarch64 Macs with Parallels Provider.

For *X86_64* boxes you can check [here](https://app.vagrantup.com/generic).

List of Vagrant boxes can be obtained from [https://app.vagrantup.com/dcagatay](https://app.vagrantup.com/dcagatay)

## Building a Box

### Prerequisites

- Packer (`brew install packer`)
- Parallels Desktop (`brew install --cask parallels`)
- Parallels Virtualization SDK (`brew install --cask parallels-virtualization-sdk`)
- Vagrant (`brew install --cask vagrant`) *For testing*
  - Vagrant Parallels Plugin (`vagrant plugin install vagrant-parallels`)

### Build

To build a specific box, run the following:

```bash
make <box-type>
```

`<box-type` can be one of the following:

- `fedora35`
- `fedora36`

## Changelog

- `0.0.4`
  - Parallels tools upgraded to 18.1.0
- `0.0.3`
  - Some script rearrangements.
- `0.0.2`
  - Fixed Parallels virtual disk snapshot compaction/merger issue.
  - Add `cloud-utils-growpart` package.
- `0.0.1`
  - Initial alpha release.

## Vagrant Cloud URLs

- [Fedora 35](https://app.vagrantup.com/dcagatay/boxes/fedora-35-aarch64)
- [Fedora 36](https://app.vagrantup.com/dcagatay/boxes/fedora-36-aarch64)

## Testing/Running

There is a sample `Vagrantfile` included in the repository, but it is just for reference and meant to be used for local tests.

Add to the box into your local Vagrant registry, and start the VM.

```bash
vagrant box add --force --name local/generic-fedora35-aarch64-parallels ./output/generic-fedora35-aarch64-parallels-0.0.2.box
vagrant up
```

Or with some parameter wiggling.

```bash
BOX=local/generic-fedora35-aarch64-parallels
vagrant box add --force --name "$BOX" ./output/generic-fedora35-aarch64-parallels-0.0.2.box
vagrant up
```

## Uploading Box

Example command:

```bash
./upload-box.sh fedora-35-aarch64 0.0.4 "Update parallels tools to 18.1.0" ./output/generic-fedora35-aarch64-parallels-0.0.2.box
```

## Credits

- This repository is a very stripped-down version of [lavabit/robox](https://github.com/lavabit/robox).
