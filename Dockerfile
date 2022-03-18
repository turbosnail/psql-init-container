FROM alpine:3.9
RUN apk add --no-cache postgresql
COPY entrypoint.sh /usr/bin/entypoint
RUN addgroup -g 1000 psql; \
    adduser -DHG psql -u 1000 psql; \
    chmod +x /usr/bin/entypoint


ENV PSQL_PORT=5432
ENV PSQL_ROOT_USERNAME=postgres
ENV PSQL_ROOT_DATABASE=postgres
WORKDIR /home/psql

ENTRYPOINT ["/usr/bin/entypoint"]
