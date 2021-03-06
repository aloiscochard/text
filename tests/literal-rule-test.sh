#!/bin/bash -e

failed=0

function check_firings() {
    rule=$1
    expected=$2
    build="ghc -O -ddump-rule-firings LiteralRuleTest.hs"
    build="$build -i.. -I../include -DMIN_VERSION_bytestring(a,b,c)=1"
    touch LiteralRuleTest.hs
    echo -n "Want to see $expected firings of rule $rule... " >&2
    firings=$($build 2>&1 | grep "Rule fired: $rule\$" | wc -l)
    rm -f LiteralRuleTest.{o.hi}

    if [ $firings != $expected ]; then
        echo "failed, saw $firings" >&2
        failed=1
    else
        echo "pass" >&2
    fi
}

check_firings "TEXT literal" 8
check_firings "TEXT literal UTF8" 7
check_firings "TEXT empty literal" 4
# This is broken at the moment. "TEXT literal" rule fires instead.
#check_firings "TEXT singleton literal" 5

exit $failed
