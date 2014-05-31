#!/usr/bin/env perl

use v5.10;
use strict;
use Mojolicious::Lite;
use File::Basename;

get_args(@_);

get '/' => sub { shift->render( text => 'todo' ) };

sub get_args {
    my $path = shift @ARGV;
    my $name = basename($path);
    my $dir  = dirname($path);

    say $path;
    say $name || 'no-name';
    say $dir || 'no-dir';
    push @{app->static->paths}, $dir;
}

app->start('daemon');

1;
