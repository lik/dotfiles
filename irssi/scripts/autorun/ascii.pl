# Ascii-Art for Irssi, ascii.pl v1.31, author: Marcin 'derwan' Ró¿ycki (derwan@irssi.pl)

# This is my first script in perl so sorry for mistakes.
# Script is bassed on figlet.

# Usage:
#   /ASCII [options] <text>			converts text to ascii (figlet) and says in active window,
# Options:
#   -c						colorise text (default colormode),
#   -f [fontname]				set font to use by figlet,
#   -p [prefix]					set prefix,
#   -{colormode}				use this colormode,
# Colormodes:
#   -1						rainbow efect (default),
#   -2                          		stripes mode,
#   -3                          		random colors,
#   -4						hessboard,
# Other commands:
#   /COLSAY [-{colormode}] <text>		colorises text and says in active window,
#   /COLME [-{colormode}] <text>		colorises text and sends as action to active window,
#   /COLTOPIC [-{colormode}] <topic>		sets colorized topic,
#   /COLKICK [-{colormode}] <nick> [reason]	kicks nick with colorised reason,
# Settings:
#   /SET ascii_default_font			default font to use by figlet
#   /SET ascii_prefix				prefix (only for /ascii command)
#   /SET ascii_default_kickreason		default kick reason for command /colkick
#   /SET ascii_default_colormode		default colormode
#
# Url			=> http://www.derwan.org/irssi/ascii.pl
# Epic's version	=> http://www.derwan.org/ascii.scr

use strict;
use Irssi;
use Irssi::Irc;
use vars qw($VERSION %IRSSI);

$VERSION = "1.31";

%IRSSI = (
  authors	=> "Marcin \'derwan\' Ró¿ycki",
  contact	=> "derwan\@irssi.pl",
  name		=> "ascii-art",
  description	=> "Ascii-art bassed on figlet. Available commands: /ASCII, /COLSAY, /COLME, /COLTOPIC, /COLKICK.",
  url		=> "http://www.derwan.org/irssi/",
  license	=> "GNU GPL v2",
  changed	=> "1016925810"
);

Irssi::theme_register([ 'ascii_info', '%W$0:%n $1' ]);

my ($ascii_default_font, $ascii_default_kickreason, $ascii_default_colormode, $ascii_prefix) = ('small.flf', 'Irssi BaBy!', '-1', '');
my @colors = ('0', '0', '12', '9', '5', '4', '13', '8', '7', '3', '11', '10', '2', '6', '0', '0', '6', '10', '8', '7', '4', '3', '9', '11', '2', '12', '13', '5');

sub colorline {
  my ($mode, $int, $text) = @_; chomp $text;
  my ($color, $last, $line) = ($int, $int, '');
  while ($_ = $mode)
  {
    /^-2$/ and last;
    /^-3$/ and $int = int(rand(12)+2), last;
    /^-4$/ and $int = @colors[$int], last;
    $mode = '-1';
    $int+=14;
    $int = @colors[$int];
    last;
  };
  for (my $indx = 0; $indx < length($text); $indx++)
  {
    my $char = substr("$text", $indx, 1);
    while ($_ = $mode)
    {
      /^-3$/ and $color = int(rand(12)+2), last;
      /^-4$/ and $color = @colors[$color], last;
      if ($last ne "") {
        $color = @colors[$last];
	undef $last;
      } else {
        $color = @colors[$color];
	$last = $color + 14;
      };
      last;
    };
    $line .= ' ', next if ($char eq " ");
    $line .= "\003" . sprintf("%02d", $color) . $char;
    $line .= ',' if ($char eq ",");
  };
  return $mode, $int, $line;
};

sub cmd_ascii {
  my ($args, $server, $main) = @_;
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Ascii', 'Not connected to server'),
           return if (!$server or !$server->{connected});
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Ascii', 'Not joined to any channel or query window'),
           return if (!$main or !($main->{type} eq "CHANNEL" || $main->{type} eq "QUERY"));
  my ($text, $color, $font, $mode, $prefix) = ('', 0, Irssi::settings_get_str('ascii_default_font'),
    Irssi::settings_get_str('ascii_default_colormode'), Irssi::settings_get_str('ascii_prefix'));
  my @input = split(" ", $args);
  while ($_ = shift(@input))
  {
    /^-f$/ and $font = shift(@input), next;
    /^-c$/ and $color = 1, next;
    /^-p$/ and $prefix = shift(@input), next;
    /^-[1|2|3|4]$/ and $mode = $_, $color = 1, next;
    /^-.*$/ and next;
    $text = $_ . " " . join(" ", @input);
    $text =~ s/\\/\\\\/g;
    $text =~ s/\"/\\\"/g;
    $text =~ s/\`/\\\`/g;
    last
  };
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Ascii',
           'Missing or bad arguments, usage: /ASCII [-c|-1|-2|-3|-4] [-p prefix] [-f font] <text>'),
           return if ($text eq "" or $font eq "");
  my $ascii = `figlet -k -f "$font" "$text" 2>/dev/null`;
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Ascii', 'Messed-up arguments or bad fontname'),
           return if ($ascii eq "");
  my ($int, $sendline, $indx) = (int(rand(12)+2), '', 0);
  foreach my $line (split(/\n/, $ascii))
  {
     my $test = $line; $test =~ s/ //g; next if ($test =~ /^$/);
     my ($mode, $indx, $sendline) = ($color == 0) ? (0, 0, $line) : (colorline("$mode", "$int", "$line"));
     $int = $indx;
     $main->command("/say $prefix$sendline");
  };
};

sub cmd_colsay {
  my ($args, $server, $main) = @_;
  my ($mode, $text) = (Irssi::settings_get_str('ascii_default_colormode'), '');
  my @input = split(" ", $args);
  while ($_ = shift(@input))
  {
    /^-[1|2|3|4]$/ and $mode = $_, next;
    /^-.*$/ and next;
    $text = $_ . " " . join(" ", @input);
    last;
  };
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colsay', 'Not connected to server'),
           return if (!$server or !$server->{connected});
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colsay', 'Not joined to any channel or query window'),
           return if (!$main or !($main->{type} eq "CHANNEL" || $main->{type} eq "QUERY"));
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colsay', 'Missing arguments, usage: /COLSAY [-1|-3|-4] <text>'),
           return if ($text eq "");
  $main->command("/say " . colorline("$mode", int(rand(12)+2), "$text"));
};

sub cmd_colme {
  my ($args, $server, $main) = @_;
  my ($mode, $text) = (Irssi::settings_get_str('ascii_default_colormode'), '');
  my @input = split(" ", $args);
  while ($_ = shift(@input))
  {
    /^-[1|2|3|4]$/ and $mode = $_, next;
    /^-.*$/ and next;
    $text = $_ . " " . join(" ", @input);
    last;
  };
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colme', 'Not connected to server'),
           return if (!$server or !$server->{connected});
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colme', 'Not joined to any channel or query window'),
           return if (!$main or !($main->{type} eq "CHANNEL" || $main->{type} eq "QUERY"));
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colme', 'Missing arguments, usage: /COLME [-1|-3|-4] <text>'),
           return if ($text eq "");
  $main->command("/me " . colorline("$mode", int(rand(12)+2), "$text"));
};

sub cmd_coltopic {
  my ($args, $server, $main) = @_;
  my ($mode, $text) = (Irssi::settings_get_str('ascii_default_colormode'), '');
  my @input = split(" ", $args);
  while ($_ = shift(@input))
  {
    /^-[1|2|3|4]$/ and $mode = $_, next;
    /^-.*$/ and next;
    $text = $_ . " " . join(" ", @input);
    last;
  };
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Coltopic', 'Not connected to server'),
           return if (!$server or !$server->{connected});
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Coltopic', 'Not joined to any channel'),
           return if (!$main or $main->{type} ne "CHANNEL");
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Coltopic', 'Missing arguments, usage: /COLTOPIC [-1|-3|-4] <topic>'),
           return if ($text eq "");
  $main->command("/topic " . colorline("$mode", int(rand(12)+2), "$text"));
};

sub cmd_colkick {
  my ($args, $server, $main) = @_;
  my ($mode, $who, $text) = (Irssi::settings_get_str('ascii_default_colormode'), '', '');
  my @input = split(" ", $args);
  while ($_ = shift(@input))
  {
    /^-[1|2|3|4]$/ and $mode = $_, next;
    /^-.*$/ and next;
    $who = $_;
    $text = join(" ", @input);
    last;
  };
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colkick', 'Not connected to server'),
           return if (!$server or !$server->{connected});
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colkick', 'Not joined to any channel'),
           return if (!$main or $main->{type} ne "CHANNEL");
  $text = Irssi::settings_get_str('ascii_default_kickreason') if ($text eq "");
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colkick', 'Missing arguments, usage: /COLKICK [-1|-3|-4] {nick} <reason>'),
           return if ($who eq "" or $text eq "");
  Irssi::printformat(MSGLEVEL_CRAP, 'ascii_info', 'Colkick', 'You\'re not op in ' . Irssi::active_win()->get_active_name()),
           return if (!$main->{chanop});
  $main->command("/kick $who " . colorline("$mode", int(rand(12)+2), "$text"));
};

Irssi::settings_add_str('misc', 'ascii_default_font', $ascii_default_font);
Irssi::settings_add_str('misc', 'ascii_prefix', $ascii_prefix);
Irssi::settings_add_str('misc', 'ascii_default_kickreason', $ascii_default_kickreason);
Irssi::settings_add_str('misc', 'ascii_default_colormode', $ascii_default_colormode);

Irssi::command_bind('ascii', 'cmd_ascii');
Irssi::command_bind('colsay', 'cmd_colsay');
Irssi::command_bind('colme', 'cmd_colme');
Irssi::command_bind('coltopic', 'cmd_coltopic');
Irssi::command_bind('colkick', 'cmd_colkick');
