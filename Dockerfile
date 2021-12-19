FROM ghcr.io/woomymy/docker-euscan:main

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
