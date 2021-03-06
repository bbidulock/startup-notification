#!/bin/sh
# Run this to generate all the initial makefiles, etc.

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

ORIGDIR=`pwd`
cd $srcdir

PROJECT=startup-notification
TEST_TYPE=-f
FILE=libstartup-notification-1.0.pc.in

DIE=0

(autoconf --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoconf installed to compile $PROJECT."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at ftp://ftp.gnu.org/pub/gnu/"
	DIE=1
}

AUTOMAKE=automake-1.7
ACLOCAL=aclocal-1.7

($AUTOMAKE --version) < /dev/null > /dev/null 2>&1 || {
        AUTOMAKE=automake
        ACLOCAL=aclocal
}

($AUTOMAKE --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have automake installed to compile $PROJECT."
	echo "Get http://ftp.gnu.org/pub/gnu/automake/automake-1.7.9.tar.gz"
	echo "(or a newer version if it is available)"
	DIE=1
}

if test "$DIE" -eq 1; then
	exit 1
fi

test $TEST_TYPE $FILE || {
	echo "You must run this script in the top-level $PROJECT directory"
	exit 1
}

if test -z "$*"; then
	echo "I am going to run ./configure with no arguments - if you wish "
        echo "to pass any to it, please specify them on the $0 command line."
fi

libtoolize --copy --force

echo $ACLOCAL $ACLOCAL_FLAGS
$ACLOCAL $ACLOCAL_FLAGS

# optionally feature autoheader
(autoheader --version)  < /dev/null > /dev/null 2>&1 && autoheader

$AUTOMAKE --gnu --add-missing
autoconf || echo "autoconf failed - version 2.5x is probably required"

cd $ORIGDIR

if test -z "$NOCONFIGURE"; then
    $srcdir/configure --enable-maintainer-mode "$@"
fi

echo 
echo "Now type 'make' to compile $PROJECT."
