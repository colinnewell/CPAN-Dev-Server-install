daemontools:
  pkg.installed:
    - pkgs:
      - daemontools
      - daemontools-run
  {% if grains['os'] == 'Ubuntu' %}
  service:
    - name: svscan # equivalent to start svscan on the command prompt
    - running
    - require:
      - pkg: daemontools
  {% endif %}
