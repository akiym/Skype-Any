package Skype::Any::Handler;
use strict;
use warnings;

sub new {
    my $class = shift;
    return bless {
        handlers => {},
    }, $class;
}

sub handlers {
    my ($self, $name, $property) = @_;
    return $self->{handlers}{$name}{uc $property} ||= [];
}

sub register {
    my ($self, $name, $args) = @_;
    if (ref $args eq 'CODE') {
        my $handlers = $self->handlers($name, '_');
        push @$handlers, $args;
    } else {
        for my $property (keys %$args) {
            my $handlers = $self->handlers($name, $property);
            push @$handlers, $args->{$property};
        }
    }
}

sub call {
    my ($self, $name, $property, @args) = @_;
    for my $code (@{$self->handlers($name, $property)}) {
        $code->(@args);
    }
}

sub clear {
    my ($self, $name, $property) = @_;
    $property = '_' unless defined $property;

    my $handlers = $self->handlers($name, $property);
    pop @$handlers;
}

sub clear_all {
    my ($self, $name, $property) = @_;
    $property = '_' unless defined $property;

    my $handlers = $self->handlers($name, $property);
    @$handlers = ();
}

1;
__END__

=head1 NAME

Skype::Any::Handler - Handler interface for Skype::Any

=head1 METHODS

=head2 C<handlers>

  $handler->handlers($name, $property);

=head2 C<register>

  $handler->register($name, sub { ... });

Register _ (default) handler.

  $handler->register($name, +{$property => sub { ... }, ...});

Register $name handler and you can register named handler below.

=over 4

=item Command

  $handler->register(Command => sub {
      my $command = shift; # Skype::Any::Command
  });

=item Notify

  $handler->register(Notify => sub {
      my $notification = shift;
      my $command = Skype::Any::Command->new($notification);
      my ($obj, $id, $property, $value) = $command->split_reply();

      ...
  });

=item Reply

  $handler->register(Reply => sub {
      my $reply = shift; # Skype::Any::Command

      ...
  });

=item Error

  $handler->register(Error => sub {
      my $error = shift; # Skype::Any::Error
  });

=back

=head2 C<call>

  $handler->call($name, $property => @args);

=head2 C<clear>

  $handler->clear($name);
  $handler->clear($name, $property);

Clear $name handler.

=head2 C<clear_all>

  $handler->clear_all($name);
  $handler->clear_all($name, $property);

Clear all of $name handlers.

=cut
