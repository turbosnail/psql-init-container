FROM alpine:3.9
RUN apk add --no-cache postgresql
COPY entrypoint.sh /usr/bin/entypoint
RUN chmod +x /usr/bin/entypoint

ENV PSQL_PORT=5430
ENV PSQL_ROOT_USERNAME=postgres
WORKDIR /root
ENTRYPOINT ["/usr/bin/entypoint"]