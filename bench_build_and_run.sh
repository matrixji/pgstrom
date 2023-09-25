
docker build -t pgstrom:latest pgstrom

nvidia-docker stop pg
nvidia-docker rm pg
nvidia-docker run --rm -d \
                  --name pg \
                  -e POSTGRES_DB="bench_test" \
                  -e POSTGRES_HOST_AUTH_METHOD="trust" \
                  -p 54321:5432 \
                  --shm-size=10G --cpus=4 \
                  pgstrom:latest


