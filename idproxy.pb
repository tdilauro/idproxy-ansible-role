# -*- mode: yaml -*-
# vi: set ft=yaml :

# run like this: ansible-playbook --vault-password-file <vault-password-file> -K -i <host-name>, [-u <ssh-username>] idproxy.pb
# NB: Comma required for -i if only one hostname in list.
# NB: Use the hostname (e.g., idproxy05.mse.jhu.edu) here, *not* the service name (jscholarship.mse.jhu.edu).
# e.g.: ansible-playbook --vault-password-file ~/.ansible/.vault-pw -K -i idproxy05.mse.jhu.edu, idproxy.pb

---

- hosts: all
  become: yes
  become_user: root
  become_method: sudo
  roles:
    - role: idproxy
