package Skype::Any::Object::Call;
use strict;
use warnings;
use parent qw/Skype::Any::Object/;

sub property { shift->_property('CALL', @_) }
sub alter    { shift->_alter('CALL', @_) }

for my $property (qw/vaa_input_status/) {
    no strict 'refs';
    *{$property} = sub { $_[0]->_boolean($property) };
}

1;
__END__

=head1 NAME

Skype::Any::Object::Call - Call object for Skype::Any

=head1 SYNOPSIS

    use Skype::Any;

    my $skype = Skype::Any->new;
    my $call = $skype->call($id);

=head1 METHODS

=head2 C<property>

=over 4

=item timestamp

=item partner_handle

=item partner_dispname

=item target_identity

=item conf_id

=item type

=item status

=item video_status

=item video_send_status

=item video_receive_status

=item failurereason

=item subject

=item pstn_number

=item duration

=item pstn_status

=item conf_participants_count

=item conf_participant

=item vm_duration

=item vm_allowed_duration

=item rate

=item rate_currency

=item rate_precision

=item input

=item output

=item capture_mic

=item vaa_input_status

=item forwarded_by

=item transfer_active

=item transfer_status

=item transferred_by

=item transferred_to

=back

=head2 C<alter>

=head1 SEE ALSO

L<Skype::Any::Object>

=cut
