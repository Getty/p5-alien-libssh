# ABSTRACT: Find or build libssh, the SSH library

package Alien::libssh;
our $VERSION = '0.002';
use strict;
use warnings;
use parent 'Alien::Base';

1;

=head1 SYNOPSIS

  use Alien::libssh;

  # cflags and libs are available via Alien::Base methods
  my $cflags = Alien::libssh->cflags;
  my $libs   = Alien::libssh->libs;

=head1 DESCRIPTION

L<Alien::libssh> provides the C library L<libssh|https://www.libssh.org/>
for use by other CPAN modules that need to link against it.

It first checks whether a system C<libssh> is available via C<pkg-config>.
If not, it downloads and builds libssh from source using CMake.

=head1 SEE ALSO

L<Net::LibSSH>, L<Alien::Build>, L<Alien::Base>

=cut
