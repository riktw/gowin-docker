FROM --platform=linux/amd64 debian:bookworm-slim

# Install gowin toolchain
RUN apt-get update \
    && apt-get install -y libglib2.0-0 libfontconfig1 wget \
    && wget -P /tmp/ http://cdn.gowinsemi.com.cn/Gowin_V1.9.9Beta_linux.tar.gz \
    && mkdir /usr/local/share/gowin \
    && tar xf /tmp/Gowin*.tar.gz -C /usr/local/share/gowin \
    && rm /tmp/Gowin*
ENV PATH="${PATH}:/usr/local/share/gowin/IDE/bin"

# Make gowin license overridable
RUN mkdir -p /data
COPY gwlicense.ini /usr/local/share/gowin/IDE/bin/gwlicense.ini

# Install litex
RUN apt-get update \
    && apt-get install -y python3-full git bash-completion gcc-riscv64-linux-gnu meson vim \
    && mkdir -p /usr/local/share/litex/litex \
    && python3 -m venv /usr/local/share/litex/venv \
    && . /usr/local/share/litex/venv/bin/activate \
    && wget -P /usr/local/share/litex/litex https://raw.githubusercontent.com/enjoy-digital/litex/master/litex_setup.py \
    && chmod +x /usr/local/share/litex/litex/litex_setup.py \
    && cd /usr/local/share/litex/litex \
    && ./litex_setup.py --init --install --config=standard
    

# Ensure all new sessions activate the venv
COPY .bashrc /root/.bashrc
WORKDIR /data/work
CMD bash
