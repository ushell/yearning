#!/bin/sh

set -e

# 审核引擎
/opt/juno &

# 初始运行请添加`-m`参数
/opt/yearning -s -c /opt/conf.toml