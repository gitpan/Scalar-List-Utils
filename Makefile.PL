#!/usr/bin/env perl

use ExtUtils::MakeMaker;

$no_xs = grep { $_ eq '-pm' } @ARGV;

if ($no_xs) {
  @perlonly = (
    XS => {},
    C => []
  );
  print "\n\n","*"x40,"\n";
  print "Using perl only implementation\n";
  print "Some functions will not be avaliable\n";
  print "*"x40,"\n\n";
}

mkdir("lib",0777);
mkdir("lib/List",0777);
mkdir("lib/Scalar",0777);

foreach $file (qw(List/Util.pm Scalar/Util.pm)) {
  open(IN, "d/$file") or die "Cannot open d/$file: $!";
  open(OUT,">lib/$file") or die "Cannot open lib/$file: $!";
  while(<IN>) {
    if ($no_xs) {
      s/^bootstrap/#bootstrap/;
      s/(require)?\s*DynaLoader\s*;?//;
      next if ?^__END__?;
    }
    print OUT;
  }
  reset; # reset ?^__END__?
  close(IN);
  close(OUT);
}

WriteMakefile(
	VERSION_FROM	=> "d/List/Util.pm",
	NAME            => "List::Util",
	DISTNAME      	=> "Scalar-List-Utils",
	clean           => { FILES => 'lib/List/Util.pm lib/Scalar/Util.pm' },
        @perlonly,
);

sub MY::postamble {

<<'ESQ';

Makefile : d/List/Util.pm d/Scalar/Util.pm

ESQ

}
