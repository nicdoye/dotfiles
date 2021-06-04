#!/bin/zsh

# Should be the same as os_name=$(uname -s | tr '[:upper:]' '[:lower:]')
# but marginally faster
os_name="$(echo $OSTYPE | cut -f1 -d- | tr -d '.[:digit:]')"
# Same for x86_64 at least. os_arch=$(uname -m)
os_arch="$CPUTYPE"