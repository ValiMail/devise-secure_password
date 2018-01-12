#!/bin/sh
#
# Silence errors from Xvfb because we are starting it in non-priveleged mode.
#
Xvfb :99 -screen 0 1280x1024x24 > /dev/null 2>&1 &
exec "$@"
