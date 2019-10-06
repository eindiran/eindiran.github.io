---
layout: default
title: Home
permalink: /
---

{% for post in site.posts limit:5 %}
  <li>
    < a href="{{ post.url }}">{{ post.title }}</a>
  </li>
{% endfor %}

<hr/>
### Site Map
<hr/>

* [About Me](/about)
* [My Projects](/projects)
* [Blog Posts](/posts)
* [Contact Me](/contact)

<hr/>
