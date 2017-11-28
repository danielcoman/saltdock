{% set pkg_list=salt['pillar.get']("pkg_list") %}
pkg:
  pkg.installed:
    - pkgs:
    {% if grains['os'] == 'Ubuntu' %}
    {% for item in pkg_list.deb %}
      - {{ item }}
    {% endfor %}
    {% endif %}
