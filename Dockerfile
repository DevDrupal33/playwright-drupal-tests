# Testing image used for GitLab CI
FROM drupalci/php-8.5-ubuntu-apache:production

# Playwright pins its browser builds per version: browsers baked here are the
# revisions this exact version resolves. A project consuming this image installs
# its own @playwright/test from its lockfile, so if the two versions drift, the
# browsers below no longer match and every CI job re-downloads them.
#
# Keep in sync with the consuming project's lockfile, and bump both together.
ARG PLAYWRIGHT_VERSION=1.62.0

RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg -o /usr/share/keyrings/yarn-keyring.asc \
    && echo "deb [signed-by=/usr/share/keyrings/yarn-keyring.asc] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install Playwright with dependencies.
RUN set -eux; \
    npm install -g npm && \
    npm install @playwright/test@${PLAYWRIGHT_VERSION} && \
    mkdir -p /var/www/pw-browsers && \
    PLAYWRIGHT_BROWSERS_PATH=/var/www/pw-browsers npx playwright install --with-deps && \
    # Clean up in same layer to reduce size (including Playwright cache!)
    rm -rf /tmp/* \
           /var/tmp/* \
           /var/lib/apt/lists/* \
           ~/.npm \
           /root/.cache \
           /usr/share/doc/* \
           /usr/share/man/* \
           /usr/share/locale/* \
           /usr/share/pixmaps/* \
           /usr/share/icons/hicolor/*/apps/* \
           /var/cache/debconf/*

WORKDIR /var/www/html
