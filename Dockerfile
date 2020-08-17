FROM alpine:3.12.0

LABEL maintainer="ushell"

EXPOSE 8000

# 需手动编译backend/yearning
COPY backend/yearning  /opt/yearning
# 审核引擎
COPY backend/juno  /opt/juno
# 配置文件
COPY conf.toml /opt/conf.toml
# 前端文件
COPY front/dist /opt/dist

COPY docker/entrypoint.sh /opt/entrypoint.sh

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache tzdata

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" >> /etc/timezone

WORKDIR /opt

ENTRYPOINT ["/opt/entrypoint.sh"]

