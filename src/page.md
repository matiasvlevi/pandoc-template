---
title: Sample Document
date: 2024-03-10
author: [yourname, contributorname]
keywords: [science, tech, engineering, math]
todo:
    add_more: 'TODO: Add more content'
---

# {{title}}

This is a sample document. It is a markdown file that can be compiled to PDF using pandoc, and then encrypted using openssl.

![Placeholder Image](../assets/800x500.png){ width=80% }

Published on {{date}} by {{author[1]}}.

{{todo.add_more}}

<br>

## Introduction

Lorem *ipsum dolor sit amet*, consectetur adipiscing elit. Morbi in nisl aliquet, ornare eros congue, iaculis dui.

Ipsum dolor sit amet, consectetur adipiscing elit. Morbi in nisl aliquet, ornare eros congue, iaculis dui. Blandit, odio in pellentesque. bibendum, odio in pellentesque, bibendum, odio in pellentesque. Birds of a feather flock together, but time flies like an arrow.

\newpage

## Formatting

### Bullet points

- Point 1
- Point 2
- Point 3

### Numbered points

1. Numbered point A
2. Numbered point B
3. Numbered point C

### Tables

| Header 1 | Header 2 | Header 3 |
|----------|----------|----------|
| Row 1    | Row 1    | Row 1    |
| Row 2    | Row 2    | Row 2    |
| Row 3    | Row 3    | Row 3    |


### Notes

> This is a note.


### Code

```python
def hello_world():
    print("Hello, World!")
```


\newpage

# Last Page

This is the last page of the document.

Below, we are using embed latex `\vspace{\fill}` to add vertical space to the page.

$\vspace{\fill}$

## Conclusion

Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi in nisl aliquet, ornare eros congue, iaculis dui. Blandit, odio in pellentesque. bibendum, odio in pellentesque, bibendum, odio in pellentesque. Birds of a feather flock together, but time flies like an arrow.

Ipsum dolor sit amet, consectetur adipiscing elit. Morbi in nisl aliquet, ornare eros congue, iaculis dui. Blandit, odio in pellentesque. bibendum, odio in pellentesque, bibendum, odio in pellentesque. Birds of a feather flock together, but time flies like an arrow.



