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
    FILE *file;
    long filesize;
    char *buffer;

    // Open the file in binary read mode
    file = fopen("file.txt", "rb");
    if (file == NULL)
    {
        perror("Error opening file");
        return 1;
    }

    // Seek to the end of the file to determine its size
    fseek(file, 0, SEEK_END);
    filesize = ftell(file);
    rewind(file); // Rewind the file pointer to the beginning of the file

    // Allocate memory for the buffer
    buffer = (char *)malloc(filesize + 1); // +1 for the null terminator
    if (buffer == NULL)
    {
        perror("Memory error");
        fclose(file);
        return 1;
    }
    err = rados_read(io, "greeting", buffer, filesize, 0);
    if (err < 0)
    {
        fprintf(stderr, "%s: cannot read pool %s: %s\n", argv[0], poolname, strerror(-err));
        rados_ioctx_destroy(io);
        rados_shutdown(cluster);
        exit(1);
    }
    printf("%c %ld\n", buffer[0], filesize);
    rados_ioctx_destroy(io);
    rados_shutdown(cluster);
}