
perl_bin='/usr/local/Cellar/perl/5.26.0/bin'

if [ -d ${perl_bin} ]
then
    export PATH=${perl_bin}:${PATH}
fi

unset perl_bin