#!/usr/bin/env perl

use v5.10;
use strict;
use Mojolicious::Lite;
use File::Basename;
use String::Random qw/random_string/;

get_args(@_);

my %active_sessions;
my %passive_sessions;

# Initial route
get '/' => sub { shift->render( text => 'todo' ) };
# Passive
get '/p'      => sub { create_passive(shift) };
get '/p/:sid' => sub { open_passive(shift) };
# Active
get '/a/:sid' => sub { open_active(shift) };

sub get_args {
    my $path = shift @ARGV;
    my $name = basename($path);
    my $dir  = dirname($path);

    push @{app->static->paths}, $dir;
}

sub create_passive {
    my $self = shift;

    my $sid = random_string('ccccc');

    $sid = random_string('cccc') while $passive_sessions{$sid};

    $self->redirect_to("/p/$sid");
}

sub open_passive {
    my $self = shift;
    my $sid  = $self->stash('sid');

    if ($passive_sessions{$sid}) {
        $self->render( text => 'Busy' );
    }
    else {
        $passive_sessions{$sid} = 1;
        $self->render( text => "Sessió $sid" );
    }
}

sub open_active {
    my $self = shift;
    my $sid  = $self->stash('sid');

    if ($passive_sessions{$sid}) {
        if ($active_sessions{$sid}) {
            $self->render( text => 'Busy' );
        }
        else {
            $active_sessions{$sid} = 1;
            $self->render( text => "Sessió $sid" );
        }
    }
    else {
        $self->render( text => 'Not available'' );
    }
}

app->start('daemon');

1;
