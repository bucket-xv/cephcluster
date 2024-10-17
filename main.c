#include <stdio.h>
#include <stdlib.h>
#include <rados/librados.h>

int main(int argc, char **argv)
{
    int err;
    rados_t cluster;

    err = rados_create(&cluster, NULL);
    if (err < 0)
    {
        fprintf(stderr, "%s: cannot create a cluster handle: %s\n", argv[0], strerror(-err));
        exit(1);
    }

    err = rados_conf_read_file(cluster, "/etc/ceph/ceph.conf");
    if (err < 0)
    {
        fprintf(stderr, "%s: cannot read config file: %s\n", argv[0], strerror(-err));
        exit(1);
    }

    err = rados_connect(cluster);
    if (err < 0)
    {
        fprintf(stderr, "%s: cannot connect to cluster: %s\n", argv[0], strerror(-err));
        exit(1);
    }

    rados_ioctx_t io;
    char *poolname = "ecpool";
    err = rados_ioctx_create(cluster, poolname, &io);
    if (err < 0)
    {
        fprintf(stderr, "%s: cannot open rados pool %s: %s\n", argv[0], poolname, strerror(-err));
        rados_shutdown(cluster);
        exit(1);
    }

    err = rados_write_full(io, "greeting", "hello", 5);
    if (err < 0)
    {
        fprintf(stderr, "%s: cannot write pool %s: %s\n", argv[0], poolname, strerror(-err));
        rados_ioctx_destroy(io);
        rados_shutdown(cluster);
        exit(1);
    }

    rados_ioctx_destroy(io);
    rados_shutdown(cluster);
}