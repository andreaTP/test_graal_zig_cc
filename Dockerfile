FROM maven:3.8.5-jdk-11 AS maven-image

WORKDIR /build

COPY . /build
RUN mvn clean package -Dquarkus.package.type=native-sources

FROM ubuntu:18.04 AS build-image

RUN apt-get update && apt-get install -y curl wget build-essential make binutils

RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.1.0/graalvm-ce-java11-linux-amd64-22.1.0.tar.gz && \
    tar -xvf graalvm-ce-java11-linux-amd64-22.1.0.tar.gz
ENV PATH="/graalvm-ce-java11-22.1.0/bin:${PATH}"

RUN gu install native-image

RUN mkdir -p /build

COPY --from=maven-image /build/target/native-sources /build

# NON STATIC build
RUN apt-get update && apt-get install -y libz-dev
RUN (cd build && native-image $(cat native-image.args))

# Mostly static build
# NON STATIC build
# RUN apt-get update && apt-get install -y libz-dev
# RUN (cd build && native-image -H:+StaticExecutableWithDynamicLibC $(cat native-image.args))

# Fully static build
# # Set up musl, in order to produce a static image compatible to alpine
# ARG RESULT_LIB="/musl"
# RUN mkdir ${RESULT_LIB} && \
#     curl -L -o musl.tar.gz https://more.musl.cc/10.2.1/x86_64-linux-musl/x86_64-linux-musl-native.tgz && \
#     tar -xvzf musl.tar.gz -C ${RESULT_LIB} --strip-components 1

# RUN curl -L -o zlib.tar.gz https://zlib.net/zlib-1.2.12.tar.gz && \
#     mkdir zlib && tar -xvzf zlib.tar.gz -C zlib --strip-components 1 && \
#     cd zlib && ./configure --static --prefix=/musl && \
#     make && make install && \
#     cd / && rm -rf /zlib && rm -f /zlib.tar.gz
# ENV PATH="$PATH:/musl/bin"

# RUN (cd build && \
#     native-image \
#     --libc="musl" \
#     --static \
#     --no-fallback \
#     --verbose \
#     --no-server \
#     $(cat native-image.args))
# END full static

# ENTRYPOINT [ "/bin/bash" ]
ENTRYPOINT [ "/build/code-with-quarkus-1.0.0-SNAPSHOT-runner" ]

# FROM scratch

# COPY --from=build-image /build/code-with-quarkus-1.0.0-SNAPSHOT-runner /

# ENTRYPOINT [ "/code-with-quarkus-1.0.0-SNAPSHOT-runner" ]
