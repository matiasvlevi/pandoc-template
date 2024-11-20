# Pandoc Template

### Features

* Meta-macros
* Asset webroot
* Multiple documents (`./src/**/*.md` --> `./docs/**/*.pdf`)


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

```md
---
title: My Document
---

![Sample Caption](/assets/frog.png) 

```

This will resolve as `$PWD/assets/frog.png`.

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
