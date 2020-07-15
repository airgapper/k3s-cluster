## buildx armv7 image
docker buildx build . -f wg-alpine.Dockerfile --platform linux/arm/v7 --tag joelrebello/wg --load

## push image
docker image push joelrebello/wg

## Troubleshooting
```                     
failed to solve: rpc error: code = Unknown desc = failed to solve with frontend dockerfile.v0: failed to load LLB: runtime execution on platform linux/arm/v7 not supported
```

Fix with,
```
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes                                                                                                                                                     docker buildx rm builder 
docker buildx create --name builder --driver docker-container --use
docker buildx inspect --bootstrap
```
