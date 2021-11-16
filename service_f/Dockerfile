FROM golang:1.15.2-alpine3.12 AS builder

RUN apk update && apk add --no-cache git

WORKDIR $GOPATH/src/service_f/

RUN go get github.com/go-sql-driver/mysql && go get github.com/gin-gonic/gin && go get github.com/jinzhu/gorm

COPY . .

RUN GOOS=linux GOARCH=amd64 go build -o /go/bin/service_f

FROM alpine:3.12

RUN apk add --no-cache tzdata

COPY --from=builder /go/bin/book /go/bin/service_f

#Just for an example. The environment variables will be defined in Configmap helm.
# ENV APP_PORT 8080
# ENV DB_USER service_f
# ENV DB_PASS service_f
# ENV DB_HOST db.99.co
# ENV DB_PORT 3306
# ENV DB_NAME 99co
# ENV REDIS_HOST cache.99.co
# ENV REDIS_PASS pass

EXPOSE 8080

ENTRYPOINT ["/go/bin/service_f"]