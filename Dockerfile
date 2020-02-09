FROM debian:latest

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

# gettext-base contains envsubst
RUN apt-get update && \
    apt-get install -y \
      coreutils gettext-base && rm -rf /var/lib/apt/lists/*

COPY --from=lachlanevenson/k8s-kubectl:latest /usr/local/bin/kubectl /usr/local/bin/kubectl

WORKDIR /app
ADD run host-endpoint.yaml.tmpl /app/
CMD [ "/app/run" ]
