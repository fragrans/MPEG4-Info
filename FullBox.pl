package FullBox;
use Box;

@ISA=("Box");

sub new()
{
    my($self, @array) = @_;
    my($hash) = {};
    Box->new(@array);
    $hash->{'version'} = $array[2];
    $hash->{'flag'} = $array[3];
    bless $hash, $self;
    return $hash;
}
