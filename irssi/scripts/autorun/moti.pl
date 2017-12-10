#!/usr/bin/env perl
#
# Irssi script for easy usage of unicode motis.
# Port of Textual's moti command
#
# Fork of Ilkka's emo.pl
# https://scripts.irssi.org/scripts/emo.pl
#
# Just fork it! (☞ﾟヮﾟ)☞
# Just port it! (☞ﾟヮﾟ)☞
#
# Package `unifont` should have to be installed so that 
# some of these display correctly. Depending on the font, some
# of them may not really work anyway. 
#
# Feel free to add your own.
#
# Enjoy! (⌐■_■)ノ♪♬

use strict;
use utf8;
use vars qw($VERSION %IRSSI %MOTIS);

$VERSION = "0.0.1";

%IRSSI = (
	authors      =>     "warsawpact",
	contact      =>     "me [at] kaiwen.li",
	name         =>     "moti",
	description  =>     "Outputs various unicode emoticons",
	commands     =>     "moti",
	license      =>     "Public Domain"
);

use Irssi;
use Irssi::Irc;

%MOTIS = (
	angel         => '☜(⌒▽⌒)☞', 
	angry         => 'ಠ╭╮ಠ',
	angry2        => 'ಥ_ಥ',
	angry3        => 'ಠ_ಠ',
	cheers        => '（ ^_^）o自自o（^_^ ） ＣＨＥＥＲＳ！',
	cheers2       => '（ ^_^）o自自o（^_^ ） ＫＡＮＰＡＩ！',
	darude        => '┗(-_- )┓┗(-_-)┛┏( -_-)┛ ┗(-_- )┓┗(-_-)┛┏( -_-)┛',
	doit          => '(☞ﾟヮﾟ)☞',
	doitrev       => '☜(ﾟヮﾟ☜)',
	doit2         => '(☞ﾟヮﾟ)☞  ＤＯ　ＩＴ！',
	dongers       => 'ヽ༼ຈل͜ຈ༽ﾉ raise your dongers ヽ༼ຈل͜ຈ༽ﾉ',
	finger        => '(◕_◕)┌∩┐',
	fistu         => 'し(*･∀･)／♡＼(･∀･*) ＢＲＯ　ＦＩＳＴＵ',
	frown         => '(◕︵◕)',
	fusro         => '(╯°O°）╯FUS RO DAH!',
	gary          => 'ᕕ( ᐛ )ᕗ',
	give          => '༼ つ ◕_◕ ༽つ ＧＩＶＥ　ＨＵＧＳ',
	glare         => 'Ò_Ó',
	happy         => '{◕ ◡ ◕}',
	happy2        => '^ㅂ^',
	happy3        => '^_^',
	hug           => '(>^^)> <(^^<)',
	idc           => '（　´_ゝ`）',
	kira          => '(ﾉゝ∀･)~キラッ☆',
	leface        => '( ͡° ͜ʖ ͡°)',
	love          => '(｡♥‿♥｡)',
	nonowa        => 'のヮの',
	orly          => 'd[ ๏ _ ◉ ]b',
	orly2         => 'd[ ๏ _ ◉ ]b   Ｏ　ＲＬＹ？',
	panic         => '╱o╲',
	ridic         => '(╯°□°）╯︵ ┻━┻ ＴＨＩＳ　ＩＳ　ＲＩＤＩＣＵＬＯＵＳ',
	shock         => '◉_◉',
	shock2        => 'Σ(ﾟДﾟ)',
	shrug         => '┐(\'～`)┌',
	shrug2        => '┐(\'～`；)┌',
	shrug3        => '¯\_(ツ)_/¯',
	smile         => '(•‿•)',
	smile2        => '(｡◕‿◕｡)',
	sorry         => 'm( _  _ )m',
	sorry2        => 'm( _  _ )m  ＧＯＭＥＮ　ＫＵＤＡＳＡＩ．',
	tableflip     => '(╯°□°）╯︵ ┻━┻',
	wave          => '<o/',
	wave2         => '.o/',
	wink          => 'ᕋ꒪⍹꒡ᕈ',
	wink2         => '~_^',
	yay           => 'º╲˚\╭ᴖ_ᴖ╮/˚╱º   ＹＡＹ！',
	zzz           => '┌[；`||～,]┐  ｚｚＺ',
);

sub motilist {
	foreach my $key (sort keys %MOTIS) {
		Irssi::print($key . " = " . $MOTIS{$key});
	} 
}

sub moti {
	my ($key, $server, $dest) = @_;

	if (!$server || !$server->{connected}) {
		Irssi::print("Not connected to server.");
		return;
	}
	return unless $dest;

	if (!exists $MOTIS{$key}) {
		Irssi::print("Use: '/moti [command]'. Commands: fistu, angel, angry, angry2, angry3, cheers, doit, doitrev, doit2, frown, fusro, glare, happy, happy2, happy3, hug, idc, love, orly, orly2, ridic, shock, shock2, shrug, shrug2, shrug3, smile, sorry, sorry2, wave, wave2, wink, wink2, yay, zzz.");
		return;
	}

	$dest->command("msg " . $dest->{name} . " " . $MOTIS{$key});
}

Irssi::command_bind('moti', 'moti');
