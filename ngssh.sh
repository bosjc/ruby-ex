#!/bin/bash
/usr/sbin/sshd -D &
ngrok authtoken 23YKS1u2ebdKWvXJFiCUAffkt3M_rPS2XfTS87dHaBuBEHDt
ngrok tcp 22
