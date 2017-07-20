PERL_BIN=/usr/local/Cellar/perl/5.26.0/bin

if [ -d ${PERL_BIN} ]
then
    export PATH=${PERL_BIN}:$PATH
fi
