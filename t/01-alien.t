use Test2::V0;
use Test::Alien;
use Alien::libssh;

alien_ok 'Alien::libssh';
ffi_ok { symbols => [] }, with_subtest {
  # basic load test — no symbols required at this level
};

done_testing;
