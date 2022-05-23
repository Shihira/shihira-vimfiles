#!/usr/bin/env python3

import sys

from plumbum import local as pl
from plumbum import (FG, BG)

log_file = pl.path("D:/test.log")
app = pl.cmd.rg

with log_file.open('wb') as log:
    log.write(b'Command Line:')
    log.write(' '.join(sys.argv).encode('utf-8'))
    log.write(b'\n')
    log.flush()

    log.write(b"\nLog:\n")

    future = app[sys.argv[1:]] & BG(retcode=None)

    while future.proc.poll() is None:
        stdout, stderr = future.proc.communicate()
        log.write(stdout)
        log.write(stderr)
        log.flush()

        sys.stdout.buffer.write(stdout)
        log.stdout.flush()
        sys.stderr.buffer.write(stderr)
        log.stderr.flush()

    future.wait()

