sudo ceph osd erasure-code-profile set myprofile \
    k=3 \
    m=2 \
    crush-failure-domain=host
sudo ceph osd pool create ecpool erasure myprofile