# Playwright Drupal tests

[![Publish Docker image](https://github.com/DevDrupal33/playwright-drupal-tests/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/DevDrupal33/playwright-drupal-tests/actions/workflows/docker-publish.yml)

CI image for running Playwright end to end tests against Drupal, based on
`drupalci/php-8.4-ubuntu-apache`.

`ghcr.io/devdrupal33/playwright-drupal-tests`

## What it provides

- PHP, Apache and Composer, from the Drupal CI base image.
- Node and npm.
- Playwright browsers, preinstalled at `/var/www/pw-browsers`. Consume them by
  setting `PLAYWRIGHT_BROWSERS_PATH=/var/www/pw-browsers` in the job.

The image also carries `@playwright/test` itself, but a consuming project should
install its own from its lockfile: blob reports are version bound, so every job
in a sharded run has to resolve the same version.

## The version contract

`ARG PLAYWRIGHT_VERSION` in the `Dockerfile` decides which browser revisions are
baked in. Playwright pins browser builds per version, so if a project's
lockfile moves ahead of this image, `npx playwright install` finds no matching
revision and downloads a few hundred MB in every job, silently.

So: bump `PLAYWRIGHT_VERSION` and the project's lockfile together.

## Tags

`main` and `nightly` move. The weekly rebuild picks up base image updates, which
is the point, but it means a pipeline pinned to a moving tag can change
underneath itself between two runs of the same commit.

For CI, pin an immutable reference and upgrade deliberately:

| Tag | Moves | Use for |
|---|---|---|
| `main` | every push to main | local experiments |
| `nightly` | weekly | local experiments |
| `sha-<commit>` | never | CI |
| `<YYYYMMDD>` | never | CI |
| `@sha256:<digest>` | never | CI, strongest |
