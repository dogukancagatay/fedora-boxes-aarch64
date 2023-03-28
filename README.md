
# Fedora Parallels Vagrant Boxes for Mac aarch64 (arm64)

Generic base Fedora boxes, providing Vagrant boxes for arm64/aarch64 Macs with Parallels Provider.

For *X86_64* boxes you can check [here](https://app.vagrantup.com/generic).

List of Vagrant boxes can be obtained from [https://app.vagrantup.com/dcagatay](https://app.vagrantup.com/dcagatay)

## Running

You can use the `Vagrantfile` at the repository root as an example, it will directly create VM from latest release of Fedora box.

```sh
vagrant up
```

SSH into the VM.

```sh
vagrant ssh
```

## Building Locally

### Prerequisites

Prerequisites for building the Vagrant box.

- Packer (`brew install packer`)
- Parallels Desktop (`brew install --cask parallels`)
- Parallels Virtualization SDK (`brew install --cask parallels-virtualization-sdkbrew install --cask parallels-virtualization-sdk`)
- Vagrant (`brew install --cask vagrant`) *For testing*
  - Vagrant Parallels Plugin (`vagrant plugin install vagrant-parallels`)

### Build

To build a specific box, run the following:

```sh
make <box-type>
```

`<box-type` can be one of the following:

- `fedora38b` (*Beta*)
- `fedora37`
- `fedora36`
- `fedora35` (*EOL*)

## Changelog

- `0.0.5` *2023-03-25*
  - Parallels tools upgraded to 18.2.0
  - F38b: Fedora 38 Beta version added to Vagrant Cloud
  - F35: Updated repository addresses with archive URLs
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

- [Fedora 38 Beta](https://app.vagrantup.com/dcagatay/boxes/fedora-38b-aarch64)
- [Fedora 37](https://app.vagrantup.com/dcagatay/boxes/fedora-37-aarch64)
- [Fedora 36](https://app.vagrantup.com/dcagatay/boxes/fedora-36-aarch64)
- [Fedora 35](https://app.vagrantup.com/dcagatay/boxes/fedora-35-aarch64)

## Testing

There is a sample `Vagrantfile` included in the repository, but it is just for reference and meant to be used for local tests.

Add to the box into your local Vagrant registry, and start the VM.

```sh
make import box=fedora37
make run box=fedora37
```

You can stop and remove the VM using the following command:

```sh
make destroy box=fedora37
```

## Uploading Box

Example command:

```sh
./upload-box.sh fedora-37-aarch64 0.0.5 "Update parallels tools to 18.2.0" ./output/generic-fedora37-aarch64-parallels-0.0.5.box
```

## Troubleshooting

### Error: `Failed creating Parallels driver: Parallels Virtualization SDK is not installed`

If you get the error in the title after installing the Parallels Virtualization SDK, you hit the bug explained [here](https://github.com/hashicorp/packer-plugin-parallels/issues/36).

You can resolve the issue by creating a symlink from Python 3.7 site packages to your recent version of Python.

First find out which syspaths of your `python3`.

```sh
/usr/bin/python3 -m site
```

Determine the path to your `python3` site-packages directory from the output of previous command, modify and run the symlink creating command below.

```sh
sudo ln -s \
/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7/site-packages/prlsdkapi.pth \
/Library/Developer/CommandLineTools/Library/Frameworks/Python3.framework/Versions/3.9/lib/python3.9/site-packages/prlsdkapi.pth
```

## Credits

- This repository is a very stripped-down version of [lavabit/robox](https://github.com/lavabit/robox).
