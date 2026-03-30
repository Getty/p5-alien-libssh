# Alien::libssh

[Alien](https://metacpan.org/pod/Alien::Base) wrapper for [libssh](https://www.libssh.org/) — the C SSH library.

Provides `libssh` for CPAN modules that need to link against it. First checks whether a system `libssh` is available via `pkg-config`; if not, it downloads and builds libssh from source using CMake.

## Synopsis

```perl
use Alien::libssh;

my $cflags = Alien::libssh->cflags;
my $libs   = Alien::libssh->libs;
```

Typically you don't use `Alien::libssh` directly — it's pulled in automatically as a dependency of [Net::LibSSH](https://metacpan.org/pod/Net::LibSSH).

## Installation

```
cpanm Alien::libssh
```

Or from this repository:

```
cpanm --installdeps .
dzil build
cpanm Alien-libssh-*.tar.gz
```

## See Also

- [Net::LibSSH](https://metacpan.org/pod/Net::LibSSH)
- [Alien::Base](https://metacpan.org/pod/Alien::Base)
- [libssh upstream](https://www.libssh.org/)

## Author

Torsten Raudssus `<getty@cpan.org>`

## License

This software is copyright (c) 2025 by Torsten Raudssus. This is free software; you can redistribute it and/or modify it under the same terms as the Perl 5 programming language system itself.
