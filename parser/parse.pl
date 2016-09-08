#!/usr/bin/perl
#
# Based on discussion at http://www.perlmonks.org/bare/?node_id=484313
#

use strict;
use warnings;
binmode(STDOUT, ":utf8");
use open ':std', ':encoding(UTF-8)';
use Encode;


use Data::Dumper;

my %tags;
{
    my $i    = 0;
    for (qw(
        kRSUnicode
        kIRGKangXi
        kRSKangXi
        kIRG_GSource
        kHanYu
        kHanyuPinyin
        kIRGHanyuDaZidian
        kIRG_TSource
        kTotalStrokes
        kMandarin
        kIRG_KPSource
        kMorohashi
        kKangXi
        kDefinition
        kCantonese
        kCCCII
        kSBGY
        kKPS1
        kIRGDaiKanwaZiten
        kIRG_KSource
        kCangjie
        kCNS1992
        kCNS1986
        kDaeJaweon
        kIRGDaeJaweon
        kCihaiT
        kIRG_JSource
        kRSAdobe_Japan1_6
        kEACC
        kJapaneseOn
        kBigFive
        kPhonetic
        kJapaneseKun
        kIICore
        kXerox
        kIRG_VSource
        kKorean
        kTaiwanTelegraph
        kMatthews
        kVietnamese
        kGSR
        kMeyerWempe
        kMainlandTelegraph
        kGB1
        kGB0
        kJis0
        kFennIndex
        kJis1
        kNelson
        kFrequency
        kFenn
        kKSC0
        kGB3
        kHKGlyph
        kCowles
        kKPS0
        kIRG_HSource
        kHKSCS
        kTang
        kHanyuPinlu
        kJIS0213
        kLau
        kSemanticVariant
        kKSC1
        kGB5
        kSimplifiedVariant
        kTraditionalVariant
        kGradeLevel
        kZVariant
        kKarlgren
        kCompatibilityVariant
        kGB8
        kSpecializedSemanticVariant
        kIBMJapan
        kHDZRadBreak
        kRSJapanese
        kRSKanWa
        kPseudoGB1
        kGB7
        kIRG_USource
        kOtherNumeric
        kAccountingNumeric
        kRSKorean
        kPrimaryNumeric
        kFourCornerCode
        kHangul
        kXHC1983
        kCheungBauerIndex
        kCheungBauer
        kIRG_MSource
        kJa
    )) {
        $tags{$_}    = $i;
        $i++;
    };
    # $tags{kRSUnicode}    = 0; $tags{kIRGKangXi}    = 1; and so on
};


## ... %tags as defined in the OP ...

my $tagcnt = scalar keys %tags;  # let's be sure about how many tags there are

warn scalar localtime(), $/;   # initial time mark

my $prev_codepoint = 0;
my $prev_cpog      = 0;
my @outrec;
my $ndone = 0;

while (<>) {
    next if /^#/;       # skip comments
    chomp;
    my ($codepoint, $tag, $content)     = split /\t/;
    next unless($codepoint);
    my $cpog = $codepoint;
    $codepoint  =~ s/^U\+//;            # replace U+ with 0x
    $codepoint  = hex $codepoint;       # treat 0x number as hex, convert to dec
    if ( $codepoint != $prev_codepoint ) {
        #printrec( $prev_codepoint, \@outrec ) if ( $prev_codepoint );
        printrec( $prev_cpog, \@outrec ) if ( $prev_codepoint );
        @outrec = map { '' } (1..$tagcnt);
        $prev_codepoint = $codepoint;
        $prev_cpog = $cpog;
    }

    unless (defined $tags{$tag}){
      print STDERR "I don't know tag: $tag\n";
      next;
    }

    $outrec[$tags{$tag}] = $content;

# ongoing time-stamping:
    print STDERR "\r$ndone done at ".scalar localtime()."" if ( ++$ndone % 1001 == 1 || $ndone == 0 );
}
printrec( $prev_codepoint, \@outrec );

warn "\n", scalar localtime(), $/;  # final timestamp

sub printrec {
    my ( $cp, $rec ) = @_;

    #$cp =~ s/U\+(....)/ pack 'U*', hex($1) /eg;
    $cp =~ s/U\+([^U]+)/ pack 'U*', hex($1) /eg;

    my $s = join( "\t", $cp, @$rec ) . "\n";

    $s  =~ s/([\x{10000}-\x{1FFFFF}])/'\x{'.(sprintf '%X', ord $1).'}'/ge;

    print $s;
};
