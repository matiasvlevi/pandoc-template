# Pandoc Template

Personal framework for building & Encrypting PDF documents from markdown source.

## Example

This [markdown source](./src/page.md) generated this [PDF Document](./docs/page.pdf)


## Features

* Multiple documents (`./src/**/*.md` --> `./docs/**/*.pdf`)
* Meta-Preprocessor (Use document metadata in the document as macros)
* File Encryption & Key management

## Requirements

* `pandoc`
* `texlive`
* `xelatex`
* `openssl` (for encryption only)


<br/>

## Get Started

Build all markdown documents to PDFs 

```sh
make
```

<br/>

## Encryption

Encrypt documents with `aes-256-cbc`

```
make encrypt
```

these files are created for each PDF document:

* `docs/document.enc` The encrypted PDF document as a base64 string
* `docs/document.key.sh` The key to decrypt the document (Autogenerated, but can be changed by modifying the Password settings in the Makefile)

<br/>

## Manage keys

By default, the keys are not regenerated if they already exist. To force the generation of new keys, set `NEW_KEYS=1`.

```
make encrypt NEW_KEYS=1
```

<br/>

## Meta-Preprocessor

Use the meta data defined in the document's header as preprocessor macros.

Lua is evaluated inside the curly braces

```yaml
---
title: My Document
date: 2024-10-25
author: [ Matias Vazquez-Levi ]
---

**{{title}}** from {{author[1]}}

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi in nisl aliquet, ornare eros congue, iaculis dui.


Published on {{date}}
```

<br/>

## Embed Latex

Use latex blocks for more control

ex: include an image without a caption:

```mdx
::: { .latex }

\includegraphics{./src/assets/frog.png}

:::
```

When using latex directly, it does not take into account the path of the document. 

<br/>

## Copy to static site repository

The `DEST` variable can be used to copy the encrypted documents to a static site repository.

```
make encrypt DEST=../my-site
```

this will copy the documents to the `../my-site/docs` folder once they are encrypted.

Make sure your `DEST` folder is a git repository with the following `.gitignore`:

```
docs/**/*.key.sh
docs/**/*.pdf
docs/**/*.csv
```

<br/>

---

License MIT
