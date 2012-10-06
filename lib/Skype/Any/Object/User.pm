package Skype::Any::Object::User;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('USER', @_) }
sub alter    { shift->_alter('USER', @_) }

for my $property (qw/hascallequipment is_video_capable is_voicemail_capable isauthorized isblocked can_leave_vm is_cf_active/) {
    no strict 'refs';
    *{$property} = sub { $_[0]->_boolean($property) };
}

sub create_chat {
    my $self = shift;
    my $command = $self->api->send_command(sprintf 'CHAT CREATE %s', $self->{id});
    my @reply = $command->split_reply();
    my $chatname = $reply[1];
    return $self->object(chat => $chatname);
}

sub chat {
    my $self = shift;
    return $self->create_chat();
}

1;
__END__

=head1 NAME

Skype::Any::Object::User - User object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $user = $skype->user('echo123');
    my $users = $skype->user('echo123, t.akiym');

=head1 METHODS

=head2 C<create_chat>

Create new instance of L<Skype::Any::Object::Chat>.

=head2 C<chat>

Alias for C<create_chat>.

=head2 C<property>

=over 4

=item handle

=item fullname

=item birthday

=item sex

=item language

=item country

=item province

=item city

=item phone_home

=item phone_office

=item phone_mobile

=item homepage

=item about

=item hascallequipment

=item is_video_capable

=item is_voicemail_capable

=item buddystatus

=item isauthorized

=item isblocked

=item onlinestatus

=item lastonlinetimestamp

=item can_leave_vm

=item speeddial

=item receivedauthrequest

=item mood_text

=item rich_mood_text

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
