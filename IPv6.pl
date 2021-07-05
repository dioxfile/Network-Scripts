#!/usr/bin/perl
while(<>) { print &expandv6($_), "\n"; }
sub expandv6 {
        local ($_) = @_;
        local (@parts, @newparts, $part);
        s/\s+//g; # Get rid of white space.
        s/%.*//g; # Get rid of MS/KAME scope ID, if there is one.
        if (/:(\d+)\.(\d+)\.(\d+)\.(\d+)$/) { # Expand trailing IPv4 address.
                $part = sprintf ":%02x%02x:%02x%02x", $1, $2, $3, $4;
                s/:\d+\.\d+\.\d+\.\d+$/$part/;
        }
        @parts = split(/:/, $_, -1);
        $short = 8 - $#parts;
        @newparts = ( );
        foreach $part (@parts) {
                if ($part eq "" && $short > 0) {
                        while ($short-- > 0) { push @newparts, "0000"; }
                } else {
                        push @newparts, (sprintf "%04x", hex($part));
                }
        }
        return join ":", @newparts;
}
1;

