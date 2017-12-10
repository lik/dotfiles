use strict;
use vars qw($VERSION %IRSSI);

$VERSION = "0.1";
%IRSSI = (name => 'notify.pl', license => 'GNU General Public License');

sub sanitize {
  my ($text) = @_;
  $text =~ s/"/\\"/g;
  $text =~ s/\$/\\\$/g;
  $text =~ s/`/\\"/g;
  return $text;
}

sub send_notification {
  my ($server, $msg) = @_;

  # Make the message entity-safe
  $msg = sanitize($msg);

  # pass it to libnotify
  my $cmd = "/usr/bin/notify-send " . "\"$msg\"";
  system($cmd);
}

sub event_privmsg {
    my ($server, $data, $nick, $address) = @_;
    my $own_nick = $server->{nick};

    if ($data =~ /$own_nick/i && $data =~ /^(.*?):(.*)/) {
        my ($source, $msg) = split(':', $data, 2);
        send_notification($server, "Mentioned in " . $source . "\n" . $nick. ": " . $msg);
    }
}

Irssi::signal_add("event privmsg", "event_privmsg")
