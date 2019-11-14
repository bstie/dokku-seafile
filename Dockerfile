FROM seafileltd/seafile:latest

ENV SEAFILE_SERVER_HOSTNAME=seafile.stiegel.org
ENV SEAFILE_ADMIN_EMAIL=mustermann@example.com

EXPOSE 80

CMD ["/sbin/my_init", "--", "/scripts/start.py"]
