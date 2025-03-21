ARG dart_version=2.19.6

FROM dart:${dart_version}

ENV PUB_HOSTED_URL="https://mirrors.tuna.tsinghua.edu.cn/dart-pub"

WORKDIR /app

RUN git clone https://github.com/pd4d10/unpub.git source

COPY ./0001-feat-use-TUNA-mirror-for-upstream-and-simplify-code.patch source
COPY ./0003-fix-app-update-package-redirect-URLs-to-include-API-.patch source

WORKDIR /app/source
RUN git checkout de8d01455cc09967e972841dc104fd9a4b959acc && \
  git apply -- *.patch

# COPY ./unpub/ ./source

EXPOSE 4000

WORKDIR /app/source/unpub

RUN dart pub get && \
  dart compile aot-snapshot bin/unpub.dart && \
  cp bin/unpub.aot /app/unpub.aot && \
  rm -r /app/source

WORKDIR /app

# ENTRYPOINT [ "dart", "run", "bin/unpub.dart", "--database", "mongodb://unpub-mongo-service:27017/dart_pub"]
ENTRYPOINT [ "dartaotruntime", "unpub.aot", "--database", "mongodb://unpub-mongo-service:27017/dart_pub"]




