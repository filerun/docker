![FileRun Logo](https://filerun.com/images/long-logo.png)

What is FileRun?
==================

[FileRun](https://filerun.com) is a self-hosted Google Drive/Photos/Music alternative. It is a full featured web based file manager with an easy to use user interface.

Installation
==================
See https://docs.filerun.com/docker for the guide.

Default login
==================

The FileRun superuser default credentials are as follows:

``username``: ``superuser``
``password``: ``superuser``

The volume ``/filerun/user-files`` has been mounted. Make sure your FileRun users home folder paths start with the path "/user-files/".

SSL/HTTPS
==================
For SSL/HTTPS support, you would need to use it with a reverse proxy (https://www.digitalocean.com/community/tutorials/how-to-secure-haproxy-with-let-s-encrypt-on-ubuntu-14-04#step-3-%E2%80%94-installing-haproxy).
Make sure your reverse proxy passes `HTTP_X_FORWARDED_PROTO`, or `HTTP_X_FORWARDED_SSL`, or `HTTP_X_FORWARDED_PORT`. FileRun looks for any of these to determine if the URLs should start using HTTP or HTTPS. When using NGINX, just add this line in your conf file, in the `location` block: `proxy_set_header X-Forwarded-Proto https;`


License
==================
See the following document for the [licensing terms](https://goo.gl/wk2FSs).

Issues
==================
If you have any problems with or questions about this image, please [contact us](https://filerun.com/contact).

Documentation
==================
For FileRun documentation, please visit https://docs.filerun.com/
