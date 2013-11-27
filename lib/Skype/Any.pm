package Skype::Any;
use strict;
use warnings;
use 5.008001;

our $VERSION = '0.03';

use Module::Runtime qw/use_module/;

our %OBJECT = (
    USER         => 'User',
    CALL         => 'Call',
    MESSAGE      => 'Message',
    CHAT         => 'Chat',
    CHATMEMBER   => 'ChatMember',
    CHATMESSAGE  => 'ChatMessage',
    VOICEMAIL    => 'VoiceMail',
    SMS          => 'SMS',
    APPLICATION  => 'Application',
    GROUP        => 'Group',
    FILETRANSFER => 'FileTransfer',
);

sub new {
    my ($class, %args) = @_;
    return bless {
        name      => __PACKAGE__,
        protocol  => 8,
        api_class => "Skype::Any::API::$^O",
        %args,
    }, $class;
}

sub api {
    my $self = shift;
    unless (defined $self->{api}) {
        my $api = use_module($self->{api_class})->new(skype => $self);
        $self->{api} = $api;
    }
    return $self->{api};
}

sub handler {
    my $self = shift;
    unless (defined $self->{handler}) {
        require Skype::Any::Handler;
        $self->{handler} = Skype::Any::Handler->new();
    }
    return $self->{handler};
}

sub attach { $_[0]->api->attach }
sub run    { $_[0]->api->run }

sub object {
    my ($self, $object, $args) = @_;
    $object = uc $object;
    if (exists $OBJECT{$object}) {
        return $self->_create_object($OBJECT{$object}, $args);
    }
}

sub _object {
    my ($self, $object, @args) = @_;
    if (@args <= 1) {
        if (ref $args[0] eq 'CODE') {
            # Register default (_) handler
            $self->_register_handler($object, $args[0]);
        } else {
            $self->_create_object($object, $args[0]);
        }
    } else {
        $self->_register_handler($object, {@args});
    }
}

sub _register_handler {
    my ($self, $object, $args) = @_;
    $self->handler->register(uc $object, $args);
}

sub _create_object {
    my ($self, $object, $args) = @_;
    return use_module("Skype::Any::Object::$object")->new(
        skype => $self,
        (defined $args ? (id => $args) : ()),
    );
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
    $self->handler->register(CHATMESSAGE => {
        STATUS => $wrapped_code,
    });
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

Name of your application. This name will be shown to the user, when your application uses Skype.

=item protocol => 8 : Num

Protocol number.

=back

=head2 C<object>

See below for more infomation.

=head2 C<user>

  $skype->user($id);

Create new instance of L<Skype::Any::User>.

  $skype->user(sub { ... })

Register _ (default) handler.

  $skype->user($name => sub { ... }, ...)

Register $name handler.

  $skype->user($id);
  $skype->user(sub {
  });
  $skype->user($name => sub {
  });

this code similar to:

  $skype->object(user => $id);
  $skype->object(user => sub {
  });
  $skype->object(user => $name => sub {
  });

C<profile>, C<call>, ..., these methods are the same operation.

=head2 C<profile>

L<Skype::Any::Profile>

=head2 C<call>

L<Skype::Any::Call>

=head2 C<message>

Deprecated. You can use C<Skype::Any::ChatMessage>.

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

Register 'chatmessage' handler for when a chat message is coming.

=head2 C<message_received>

  $skype->create_chat_with($username, $message);

Send a $message to $username.

Alias for:

  $skype->user($username)->chat->send_message($message);

=head2 C<run>

Running an event loop.

=head1 ATTRIBUTES

=head2 C<api>

Instance of L<Skype::Any::API>. e.g. send "Happy new year!" to all recent chats.

  my $reply = $skype->api->send_command('SEARCH RECENTCHATS')->reply;
  $reply =~ s/^CHATS\s+//;
  for my $chatname (split /,\s+/ $reply) {
      my $chat = $skype->chat($chatname);
      $chat->send_message('Happy new year!");
  }

=head2 C<handler>

Instance of L<Skype::Any::Handler>. You can also register a handler:

  $skype->handler->register($name, sub { ... });

=head1 SEE ALSO

L<Public API Reference|https://developer.skype.com/public-api-reference>

=head1 AUTHOR

Takumi Akiyama E<lt>t.akiym at gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
