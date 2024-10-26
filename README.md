# Pandoc Template

### Features

* Multipage documents
* Meta-macros
* Asset root
* `./src/*.md` --> `./docs/*.pdf`


### Build 

* pandoc
* texlive
* xelatex

<br/>

```
make
```

```
make clean
```



<br/>


## Features

<br/>

### Meta-macros

Use the meta data defined in the document's header as preprocessor macros.

Lua is evaluated inside the curly braces

```yaml
---
title: My Document
date: 2024-10-25
author: [ Matias Vazquez-Levi ]
---

Lorem ipsum dolor sit amet, {{author[1]}} consectetur adipiscing {{date}} elit. Morbi in nisl aliquet, ornare eros congue, iaculis dui.
```

<br/>

### Asset root

Define the document's root directory for assets. This allows your local environement to know about these paths and provide intellisense for it. 

```mdx
---
title: My Document
root: ./assets/
---

![Sample Caption](../assets/frog.png)
```

This will resolve as `./assets/frog.png`.

<br/>


### Embed Latex

Use latex blocks for more control

ex: include an image without a caption:

```mdx
::: { .latex }

\includegraphics{./src/assets/frog.png}

:::
```

When using latex directly, it does not take into account the `root` meta property.