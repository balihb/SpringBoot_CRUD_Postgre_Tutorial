FROM ghcr.io/graalvm/native-image-community:25.0.1-muslib AS build

ARG BINARY_PLATFORM=amd64
ARG MVN_PROFILES="native,prod,!dev-validation"
ENV SPRING_MVC_VALIDATION_ENABLED=false
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

WORKDIR /build

COPY . /build

RUN chmod a+x ./mvnw && ./mvnw --no-transfer-progress native:compile -P${MVN_PROFILES} -DskipTests=true

# renovate: datasource=github depName=upx/upx
ARG UPX_VERSION=5.0.2

# hadolint ignore=DL3041
RUN microdnf install -y xz && microdnf clean all

ADD https://github.com/upx/upx/releases/download/v${UPX_VERSION}/upx-${UPX_VERSION}-${BINARY_PLATFORM}_linux.tar.xz /tmp/upx.tar.xz
RUN tar -xJOf /tmp/upx.tar.xz upx-${UPX_VERSION}-${BINARY_PLATFORM}_linux/upx > /usr/local/bin/upx &&\
    chmod +x /usr/local/bin/upx && \
    strip --strip-all /build/target/demo && \
    upx --best --lzma /build/target/demo

RUN mkdir -p /app-tmp && chmod 777 /app-tmp

FROM scratch

USER 65532:65532

COPY --from=build /build/target/demo /demo
COPY --from=build --chmod=777 --chown=65532:65532 /app-tmp /tmp

EXPOSE 8080

ENTRYPOINT ["/demo"]
