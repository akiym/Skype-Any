package Skype::Any::Object::VoiceMail;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('VOICEMAIL', @_) }
sub alter    { shift->_alter('VOICEMAIL', @_) }

1;
__END__

=head1 NAME

Skype::Any::Object::VoiceMail - VoiceMail object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $voicemail = $skype->voicemail($id);

=head1 METHODS

=head2 C<property>

=over 4

=item type

=item partner_handle

=item partner_dispname

=item status

=item failurereason

=item subject

=item timestamp

=item duration

=item allowed_duration

=item input

=item output

=item capture_mic

=back

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
