FROM registry.hub.docker.com/library/debian:12

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    python3 \
    python3-pip

RUN python3 -m pip install --no-cache-dir --break-system-packages -U demucs

RUN mkdir /input
RUN mkdir /output

# Run once to pull and store default model
RUN mkdir /models
ENV TORCH_HOME=/models
COPY test.mp3 test.mp3
RUN demucs -d cpu test.mp3 
RUN rm -rf separated
RUN rm -f test.mp3

# Enable extended globbing for bash
echo "\nshopt -s extglob" >> /etc/bash.bashrc

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["demucs", "/input/*.@(flac|mp3|m4a)", "--out", "/output", "-d", "cpu"]