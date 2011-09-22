# the real Buf should be something parametric and much more awesome.
# this is merely a placeholder until people who know their stuff build
# the Real Thing.

class Buf does Positional {
    has Mu $!buffer;
    method BUILD() {
        $!buffer := pir::new__PS('ByteBuffer');
        1;
    }
    method new(*@codes) {
        my $new := self.bless(*);
        $new!set_codes(@codes);
        $new;
    }
    method !set_codes(*@codes) {
        pir::set__vPI($!buffer, nqp::unbox_i(@codes.elems));
        for @codes.keys -> $k {
            pir::set__1Qii($!buffer, nqp::unbox_i($k), nqp::unbox_i(@codes[$k]));
        }
        self;
    }

    method at_key(Buf:D: Int:D $idx) {
        nqp::p6box_i(pir::set__IQi($!buffer, nqp::unbox_i(pir::perl6_decontainerize__PP($idx))));
    }

    method list() {
        my @l;
        for ^nqp::p6box_i(nqp::elems($!buffer)) -> $k {
            @l.push: self.at_key($k);
        }
        @l;
    }
    method decode(Str:D $encoding = 'utf8') {
        nqp::p6box_s $!buffer.get_string(
            nqp::unbox_s pir::perl6_decontainerize__PP($encoding.lc)
        );
    }
}
