# NAME

Skype::Any - Skype API wrapper for Perl

# SYNOPSIS

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

# DESCRIPTION

Skype::Any is Skype API wrapper. It was inspired by Skype4Py.

# METHODS

## `new`

    my $skype = Skype::Any->new();

Create new instance of Skype::Any. Notice that necessary Skype client is running.

- name => 'Skype::Any' : Str

    Name of your application. This name will be shown to the user, when your application uses Skype.

- protocol => 8 : Num

    Protocol number.

## `object`

See below for more infomation.

## `user`

    $skype->user($id);

Create new instance of [Skype::Any::User](http://search.cpan.org/perldoc?Skype::Any::User).

    $skype->user(sub { ... })

Register \_ (default) handler.

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

`profile`, `call`, ..., these methods are the same operation.

## `profile`

[Skype::Any::Profile](http://search.cpan.org/perldoc?Skype::Any::Profile)

## `call`

[Skype::Any::Call](http://search.cpan.org/perldoc?Skype::Any::Call)

## `message`

Deprecated. You can use `Skype::Any::ChatMessage`.

[Skype::Any::Message](http://search.cpan.org/perldoc?Skype::Any::Message)

## `chat`

[Skype::Any::Chat](http://search.cpan.org/perldoc?Skype::Any::Chat)

## `chatmember`

[Skype::Any::ChatMember](http://search.cpan.org/perldoc?Skype::Any::ChatMember)

## `chatmessage`

[Skype::Any::ChatMessage](http://search.cpan.org/perldoc?Skype::Any::ChatMessage)

## `voicemail`

[Skype::Any::VoiceMail](http://search.cpan.org/perldoc?Skype::Any::VoiceMail)

## `sms`

[Skype::Any::SMS](http://search.cpan.org/perldoc?Skype::Any::SMS)

## `application`

[Skype::Any::Application](http://search.cpan.org/perldoc?Skype::Any::Application)

## `group`

[Skype::Any::Group](http://search.cpan.org/perldoc?Skype::Any::Group)

## `filetransfer`

[Skype::Any::FileTransfer](http://search.cpan.org/perldoc?Skype::Any::FileTransfer)

## `message_received`

    $skype->message_received(sub { my ($msg) = @_; ... });

Register 'chatmessage' handler for when a chat message is coming.

## `message_received`

    $skype->create_chat_with($username, $message);

Send a $message to $username.

Alias for:

    $skype->user($username)->chat->send_message($message);

## `run`

Running an event loop.

# ATTRIBUTES

## `api`

Instance of [Skype::Any::API](http://search.cpan.org/perldoc?Skype::Any::API). e.g. send "Happy new year!" to all recent chats.

    my $reply = $skype->api->send_command('SEARCH RECENTCHATS')->reply;
    $reply =~ s/^CHATS\s+//;
    for my $chatname (split /,\s+/ $reply) {
        my $chat = $skype->chat($chatname);
        $chat->send_message('Happy new year!");
    }

## `handler`

Instance of [Skype::Any::Handler](http://search.cpan.org/perldoc?Skype::Any::Handler). You can also register a handler:

    $skype->handler->register($name, sub { ... });

# SEE ALSO

[Public API Reference](https://developer.skype.com/public-api-reference)

# AUTHOR

Takumi Akiyama <t.akiym at gmail.com>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
