FROM ubuntu:18.04 AS build-image

RUN apt update && apt install -y curl wget xz-utils

RUN wget https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-22.1.0/graalvm-ce-java11-linux-amd64-22.1.0.tar.gz
RUN tar -xvf graalvm-ce-java11-linux-amd64-22.1.0.tar.gz

RUN wget https://ziglang.org/download/0.9.1/zig-linux-x86_64-0.9.1.tar.xz
RUN tar -xvf zig-linux-x86_64-0.9.1.tar.xz

ENV PATH="/graalvm-ce-java11-22.1.0/bin:/zig-linux-x86_64-0.9.1:${PATH}"

RUN gu install native-image

RUN mkdir -p /build

COPY target/native-sources /build

# includes libstdc++.a /usr/lib/gcc/x86_64-linux-gnu/6/libstdc++.a
# RUN apt-get install -y libstdc++-6-dev

# To compile zlib and musl
RUN apt-get install -y make binutils

# https://github.com/cloudogu/groovy-cli-graal-nativeimage-micronaut-example/blob/54a3ebd25f3b6abb7e53e2f35ed956114ef4b1d5/Dockerfile#L29
# Set up musl, in order to produce a static image compatible to alpine
# See 
# https://github.com/oracle/graal/issues/2824 and 
# https://github.com/oracle/graal/blob/vm-ce-22.0.0.2/docs/reference-manual/native-image/StaticImages.md
# ARG RESULT_LIB="/musl"
# RUN mkdir ${RESULT_LIB} && \
#     curl -L -o musl.tar.gz https://more.musl.cc/10.2.1/x86_64-linux-musl/x86_64-linux-musl-native.tgz && \
#     tar -xvzf musl.tar.gz -C ${RESULT_LIB} --strip-components 1 && \
#     cp /usr/lib/gcc/x86_64-linux-gnu/6/libstdc++.a ${RESULT_LIB}/lib/
# ENV CC="zig cc"
# RUN curl -L -o zlib.tar.gz https://zlib.net/zlib-1.2.12.tar.gz && \
#     mkdir zlib && tar -xvzf zlib.tar.gz -C zlib --strip-components 1 && \
#     cd zlib && ./configure --static --prefix=/musl && \
#     make && make install && \
#     cd / && rm -rf /zlib && rm -f /zlib.tar.gz
# ENV PATH="$PATH:/musl/bin"

# ENV CC="zig cc"
ENV CC="zig cc -target x86_64-linux-musl"
RUN curl -L -o zlib.tar.gz https://zlib.net/zlib-1.2.12.tar.gz && \
    mkdir zlib && tar -xvzf zlib.tar.gz -C zlib --strip-components 1 && \
    cd zlib && ./configure --static && \
    make && make install


# zig libbc fails if we don't install gcc ????
# RUN apt-get install -y gcc
# zig libbc fails to link?? the header in musl should be used ...
# RUN apt-get install -y libz-dev

COPY zigcc /

# # -H:-CheckToolchain prevents from checking the native-toolchain

# RUN (cd build && native-image --native-compiler-path="/zig-linux-x86_64-0.9.1/zig" --native-compiler-options="cc" --libc="musl" --static $(cat native-image.args))
# --no-as-needed
RUN (cd build && native-image --native-compiler-path="/zigcc" --native-compiler-options="-target x86_64-linux-musl -L/zlib" --libc="musl" --static $(cat native-image.args))
# RUN (cd build && native-image -H:-CheckToolchain --native-compiler-path="/zigcc" --native-compiler-options="--library c -target x86_64-linux-musl -L/zlib" --libc="musl" --static $(cat native-image.args))

ENTRYPOINT [ "/bin/bash" ]
