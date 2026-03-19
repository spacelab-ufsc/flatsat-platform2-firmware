#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 SpaceLab UFSC
# SPDX-License-Identifier: GPL-2.0-only

ssh root@192.168.99.1 "date -s '@$(date +%s)'"
