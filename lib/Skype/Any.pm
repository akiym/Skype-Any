package Skype::Any;
use strict;
use warnings;
use 5.008001;
use Skype::Any::Handler;
use Skype::Any::Util qw/load_class/;

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;

    my $self = bless {
        name => 'Skype::Any',
        %args,
        handler => Skype::Any::Handler->new(),
    }, $class;

    my $klass = load_class($^O, 'Skype::Any::API');
    my $api = $klass->new($self, name => $self->{name});
    $api->attach;
    $self->{api} = $api;

    return $self;
}

sub api     { $_[0]->{api} }
sub handler { $_[0]->{handler} }

sub run { $_[0]->api->run }

sub _object {
    my ($self, $object, @args) = @_;
    if (@args < 2) {
        if (ref $args[0] eq 'CODE') {
            $self->handler->register(uc $object, $args[0]);
        } else {
            my $class = load_class($object, 'Skype::Any::Object');
            return $class->new($self, (defined $args[0] ? {id => $args[0]} : +{}));
        }
    } else {
        $self->handler->register(uc $object, {@args});
    }
}

sub object {
    my ($self, $obj, @args) = @_;
    $obj = lc $obj;
    return $self->$obj(@args);
}

sub user         { shift->_object('User', @_) }
sub profile      { shift->_object('Profile', @_) }
sub call         { shift->_object('Call', @_) }
sub message      { shift->_object('Message', @_) }
sub chat         { shift->_object('Chat', @_) }
sub chatmember   { shift->_object('ChatMember', @_) }
sub chatmessage  { shift->_object('ChatMessage', @_) }
sub voicemail    { shift->_object('VoiceMail', @_) }
sub sms          { shift->_object('SMS', @_) }
sub application  { shift->_object('Application', @_) }
sub group        { shift->_object('Group', @_) }
sub filetransfer { shift->_object('FileTransfer', @_) }

sub message_received {
    my ($self, $code) = @_;
    my $wrapped_code = sub {
        my ($chatmessage, $status) = @_;
        if ($status eq 'RECEIVED') {
            $code->($chatmessage);
        }
    };
    $self->chatmessage(status => $wrapped_code);
}

sub create_chat_with {
    my ($self, $username, $message) = @_;
    return $self->user($username)->chat->send_message($message);
}

1;
__END__

=head1 NAME

Skype::Any - Skype API wrapper for Perl

=head1 SYNOPSIS

  use Skype::Any;

  # ping-pong bot

  my $skype = Skype::Any->new();
  $skype->message_received(sub {
      my ($msg) = @_;
      my $body = $msg->body;
      if ($body eq 'ping') {
          $msg->chat->send_message('pong');
      }
  });
  $skype->run;

=head1 DESCRIPTION

Skype::Any is Skype API wrapper. It was inspired by Skype4Py.

=head1 METHODS

=head2 C<new>

  my $skype = Skype::Any->new();

Create new instance of Skype::Any. Notice that necessary Skype client is running.

=over 4

=item name => 'Skype::Any' : Str

=item protocol => 8 : Num

=back

=head2 C<object>

  $skype->object($obj => $id);

Create new instance of Skype::Any::Object::*.

=head2 C<user>

  $skype->user($id);

Create new instance of L<Skype::Any::User>.

  $skype->user(sub { ... })

Register _ (default) handler.

Alias for:

  $skype->handler->register('USER', +{_ => sub { ... }})

  $skype->user($name => sub { ... }, ...)

Register $name handler.

=head2 C<profile>

L<Skype::Any::Profile>

=head2 C<call>

L<Skype::Any::Call>

=head2 C<message>

L<Skype::Any::Message>

=head2 C<chat>

L<Skype::Any::Chat>

=head2 C<chatmember>

L<Skype::Any::ChatMember>

=head2 C<chatmessage>

L<Skype::Any::ChatMessage>

=head2 C<voicemail>

L<Skype::Any::VoiceMail>

=head2 C<sms>

L<Skype::Any::SMS>

=head2 C<application>

L<Skype::Any::Application>

=head2 C<group>

L<Skype::Any::Group>

=head2 C<filetransfer>

L<Skype::Any::FileTransfer>

=head2 C<message_received>

  $skype->message_received(sub { my ($msg) = @_; ... });

L<Skype::Any::ChatMessage>

=head2 C<message_received>

  $skype->create_chat_with($username, $message);

Send a $message to $username.

Alias for:

  $skype->user($username)->chat->send_message($message);

=head2 C<run>

Running an event loop.

=head1 ATTRIBUTES

=head2 C<api>

L<Skype::Any::API>

=head2 C<handler>

  $skype->handler->register($name, sub { ... });

See also L<Skype::Any::Handler>.

=head1 SEE ALSO

L<Public API Reference|https://developer.skype.com/public-api-reference>

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym at gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
