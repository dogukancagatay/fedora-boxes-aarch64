
# Fedora Parallels Vagrant Boxes for Mac aarch64 (arm64)

Generic Fedora Vagrant boxes for arm64/aarch64 Macs with Parallels Provider.
For _X86_64_ boxes, you can check [here](https://portal.cloud.hashicorp.com/vagrant/discover/generic).

The _maintained/updated_ Fedora versions are listed below. The box version indicates the configuration version.

## Vagrant Boxes

| Box Name                | Version | Kernel Version | Parallels Tools Version | Update Time | Status |
|-------------------------|---------|----------------|-------------------------|-------------|--------|
| [fedora-41-aarch64]     | `0.0.9` | `6.11.7`       | `20.1.55732`            | 2024-11-30  | Active |
| [fedora-40-aarch64]     | `0.0.9` | `6.11.4`       | `20.1.55732`            | 2024-10-23  | Active |
| ~~[fedora-39-aarch64]~~ | `0.0.9` | `6.11.4`       | `20.1.55732`            | 2024-10-23  | _EOL_  |
| ~~[fedora-38-aarch64]~~ | `0.0.7` | `6.5.8`        | `19.1.54729`            | 2023-10-31  | _EOL_  |
| ~~[fedora-37-aarch64]~~ | `0.0.7` | `6.5.8`        | `19.1.54729`            | 2023-10-31  | _EOL_  |

You can check all image versions from [https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay](https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay)

## Running

Initialize a Vagrantfile and start your VM.

```sh
vagrant init dcagatay/fedora-41-aarch64
vagrant up
```

SSH into the VM.

```sh
vagrant ssh
```

## Building Vagrant Box

### Prerequisites

The prerequisites to build the Vagrant box.

- Packer (`brew tap hashicorp/tap && brew install hashicorp/tap/packer`)
- Parallels Desktop (`brew install --cask parallels`)
- Parallels Virtualization SDK (`brew install --cask parallels-virtualization-sdk`)
- Vagrant (`brew install --cask vagrant`) _For testing_
  - Vagrant Parallels Plugin (`vagrant plugin install vagrant-parallels`)

### Build

To build a specific box, run the following:

```sh
# Install packer plugins
make init
# Build box
# e.g. make box=fedora37 build-box
make box=<box-type> build-box
```

`<box-type>` can be one of the following:

- `fedora41` ([Release schedule](https://fedorapeople.org/groups/schedule/f-41/f-41-key-tasks.html))
- `fedora40` ([Release schedule](https://fedorapeople.org/groups/schedule/f-40/f-40-key-tasks.html))
- `fedora39` ([_EOL on 2023-11-12_](https://fedorapeople.org/groups/schedule/f-39/f-39-key-tasks.html))
- `fedora38` ([_EOL on 2023-05-21_](https://fedorapeople.org/groups/schedule/f-38/f-38-key-tasks.html))
- `fedora37` ([_EOL on 2022-12-13_](https://fedorapeople.org/groups/schedule/f-37/f-37-key-tasks.html))
- `fedora36` (_EOL_)
- `fedora35` (_EOL_)

## Testing

A sample `Vagrantfile` is included in the repository, but it is just for reference and meant to be used for local tests.
Add it to the box in your local Vagrant registry, and start the VM.

```sh
make box=fedora37 import
make box=fedora37 run
make box=fedora37 vm-info
```

You can stop and remove the VM using the following command:

```sh
make box=fedora37 destroy
```

## Uploading Box

Example command:

```sh
./upload-box.sh fedora-37-aarch64 0.0.5 "Update parallels tools to 18.2.0" ./output/generic-fedora37-aarch64-parallels-0.0.5.box
```

## Troubleshooting

### Error: `Failed creating Parallels driver: Parallels Virtualization SDK is not installed` (_Fixed_)

If you get the error in the title after installing the Parallels Virtualization SDK, you hit the bug explained [here](https://github.com/hashicorp/packer-plugin-parallels/issues/36).

You can resolve the issue by creating a symlink from Python 3.7 site packages to your recent version of Python.

First, find out syspath of your `python3`.

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

[fedora-41-aarch64]: https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay//fedora-41-aarch64
[fedora-40-aarch64]: https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay//fedora-40-aarch64
[fedora-39-aarch64]: https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay//fedora-39-aarch64
[fedora-38-aarch64]: https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay//fedora-38-aarch64
[fedora-37-aarch64]: https://portal.cloud.hashicorp.com/vagrant/discover/dcagatay//fedora-37-aarch64
