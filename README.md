<div align="center">

# asdf-tytanic [![Build](https://github.com/quachpas/asdf-tytanic/actions/workflows/build.yml/badge.svg)](https://github.com/quachpas/asdf-tytanic/actions/workflows/build.yml) [![Lint](https://github.com/quachpas/asdf-tytanic/actions/workflows/lint.yml/badge.svg)](https://github.com/quachpas/asdf-tytanic/actions/workflows/lint.yml)

[tytanic](https://typst-community.github.io/tytanic/) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-tytanic  ](#asdf-tytanic--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html).

# Install

Plugin:

```shell
asdf plugin add tytanic
# or
asdf plugin add tytanic https://github.com/quachpas/asdf-tytanic.git
```

tytanic:

```shell
# Show all installable versions
asdf list-all tytanic

# Install specific version
asdf install tytanic latest

# Set a version globally (on your ~/.tool-versions file)
asdf global tytanic latest

# Now tytanic commands are available
tt --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/quachpas/asdf-tytanic/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Pascal Quach](https://github.com/quachpas/)
