# ID Resolver Proxy Ansible Role & Example Playbook
Install, configure, and load the resolver database for

The Identifier Resolving Proxy Server (IDproxy) acts as a proxy for content in [JScholarship](https://jscholarship.mse.jhu.edu/), the institutional repository of the Sheridan Libraries at Johns Hopkins University, and redirects to content that has been migrated from JScholarship into other service applications (e.g., the [Lester S. Levy Sheetmusic Collection](http://levysheetmusic.mse.jhu.edu/)). The resolver also handles Shibboleth authentication, which makes it easier to make changes to the proxied DSpace instance.

### Usage
* $ ansible-playbook [--vault-password-file <vault-password-file>] [-K] -i <dataverse-host-name>, [-u <ssh-username>] idproxy.pb
* e.g.: $ ansible-playbook --vault-password-file ~/.ansible/.vault-pw -K -i idproxy05.my.org, idproxy.pb

## Notes
* The comma after the hostname is needed if only one host is listed, which is probably the typical case.
* This role currently requires CentOS 7 and deploys all services on the same machine.
* Some content in this Ansible role is encrypted as Ansible Vaults.

## Result
After completing this installation, you should have a working ID Proxy installation.

## Mappings Files
* The idproxy-load phase expects one or more files in the _<role>/files/resolver_ folder.
  * To be included in the resolution database, the filenames must end with _mappings.txt_ (e.g., _levy-id-mappings.txt_).
  * The record structure for these files should be:
    * <Handle> <collection>:<collection-specific-id>
    - e.g., For the item with URI http://jhir.library.jhu.edu/handle/1774.2/28748, the entry would be:
      hdl:1774.2/28748 levy:140.009
  * As new collections are migrated out of JScholarship, new mapping files can be added to this directory.

## Adding a New Collection
* Add a new rewrite rule to _<role>/templates/httpd/jhir.vhost.conf.j2_ and _<role>/templates/httpd/ssl.conf.j2_. This line can be added after the existing resolver rewrite lines in each of these files. For example, the mod_rewrite rule for the Levy collection is:
  - RewriteRule ^/resolved/levy:(.*)$ http://levysheetmusic.mse.jhu.edu/catalog/levy:$1  [R,L]
* Add a _mappings_ file to the _<role>/files/resolver_ folder.
* TODO: Create a playbook to run just the idproxy-load phase to update the mappings database.

### Key components
* Shibboleth Service Provider
  * Configuration location: /etc/shibboleth
  * # systemctl {start|stop|restart|status} shibd
* Apache httpd
  * Configuration location: /usr/local/solr/example/solr/collection1/conf/schema.xml
  * # systemctl {start|stop|restart|status} httpd
