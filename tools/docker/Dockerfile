# Authors: Marko Schrempf, Günther Hutter
FROM docker.io/library/debian:trixie-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TZ="Europe/Vienna"

RUN apt-get update && apt-get install -y --no-install-recommends \
        # Utilities
        git \
        make \
        rsync \
        tree \
        ca-certificates \
        bash-completion \
        # Pandoc
        pandoc \
        # Hunspell
        hunspell \
        hunspell-de-at \
        hunspell-en-us \
        # LaTeX
        texlive-latex-base \
        texlive-latex-recommended \
        texlive-latex-extra \
        texlive-fonts-recommended \
        texlive-lang-german \
        texlive-lang-english \
        texlive-bibtex-extra \
        texlive-science \
        texlive-plain-generic \
        cm-super \
        lmodern \
        gsfonts && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Copy scripts
COPY scripts/validator.sh /scripts/validator.sh
COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/pdf.sh /scripts/pdf.sh
COPY scripts/spellcheck.sh /scripts/spellcheck.sh
COPY scripts/tex.sh /scripts/tex.sh
COPY scripts/clean_stage.sh /scripts/clean_stage.sh
COPY scripts/clean_out.sh /scripts/clean_out.sh
COPY scripts/clean_all.sh /scripts/clean_all.sh
COPY scripts/command_wrapper.sh /scripts/command_wrapper.sh
COPY scripts/bash_completion.sh /scripts/bash_completion.sh

# Create execution commands
RUN ln -s /scripts/pdf.sh /usr/local/bin/pdf && \
    ln -s /scripts/spellcheck.sh /usr/local/bin/spellcheck && \
    ln -s /scripts/tex.sh /usr/local/bin/tex && \
    ln -s /scripts/clean_stage.sh /usr/local/bin/clean-stage && \
    ln -s /scripts/clean_out.sh /usr/local/bin/clean-out && \
    ln -s /scripts/clean_all.sh /usr/local/bin/clean-all && \
    ln -s /scripts/command_wrapper.sh /usr/local/bin/build && \
    ln -s /scripts/bash_completion.sh /etc/bash_completion.d/build

# Ensure LF line endings and permissions
RUN sed -i 's/\r$//' /entrypoint.sh /scripts/*.sh && \
    chown root:root /entrypoint.sh /scripts/*.sh && \
    chmod 555 /entrypoint.sh /scripts/*.sh && \
    useradd -m -s /bin/bash builder && \
    echo 'source /etc/bash_completion' >> /home/builder/.bashrc

USER builder
VOLUME [/workspace]
WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
