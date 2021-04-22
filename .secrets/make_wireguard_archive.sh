#!/bin/sh
# wireguard conf files should be in .secrets/etc/wireguard/*.conf
# they will be stored in tar with full path and extracted to root (/) when used.
tar --owner=root --group=root -cavf wg.tar.gz etc
