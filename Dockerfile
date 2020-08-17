FROM alpine:3.12.0

LABEL maintainer="ushell"

EXPOSE 8000

# 需手动编译backend/yearning
COPY backend/yearning  /opt/yearning
COPY conf.toml /opt/conf.toml
COPY backend/juno  /opt/juno
COPY front/dist /opt/dist

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk add --no-cache tzdata

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" >> /etc/timezone

WORKDIR /opt

CMD ["/opt/yearning", "-s"]

