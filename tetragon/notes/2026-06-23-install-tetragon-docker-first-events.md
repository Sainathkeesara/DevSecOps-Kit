# Install Tetragon via Docker and observe my first system events

I pulled the Tetragon Docker image and ran it in standalone mode to see what eBPF events look like before dealing with Kubernetes.

```bash
docker run --name tetragon -d \
  --pid=host --cgroupns=host \
  --privileged \
  -v /sys/kernel/debug:/sys/kernel/debug:ro \
  -v /sys/fs/bpf:/sys/fs/bpf:rw \
  cilium/tetragon:v1.4.0
```

The container started but I got nothing at first — I was watching `docker logs` and saw only startup messages. Turns out Tetragon writes structured JSON to stdout once it's running, but the real-time view comes from `tetra` (the CLI helper).

I exec'd into the container:

```bash
docker exec -it tetragon tetra getevents
```

And suddenly I saw process exec events streaming — every `ls`, `curl`, `bash` call on the host, with pod context showing `namespace=default` and `pod=`. The events are verbose but I could already spot anomalies: one container kept spawning `wget` processes every few seconds.

I stopped and cleaned up:

```bash
docker stop tetragon && docker rm tetragon
```

Next I want to try a TracingPolicy that only captures specific event types so I'm not drowning in data.
