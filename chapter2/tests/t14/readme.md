## Task 14 - compile distroless python3 OOM container
[link to task:](https://github.com/saritasa-nest/saritasa-devops-camp/blob/main/chapter4%20-%20containers/l1/introduction.md#compile-distroless-python3-oom-container)
### What you will need to do:
- `make build`
- `make run` to run conteiner with default memory limit of `100m`
- `make run limit=30m` start the docker container with the specified memory limit

### My output:
```
➜ make run
Usage over time: [20.46484375, 20.57421875, 28.25390625, 36.296875, 41.96875, 47.60546875, 55.59765625, 63.70703125, 71.69921875, 79.69140625, 87.94140625, 95.93359375, 20.57421875]
Peak usage: 95.93359375

➜ make run limit=30m
{exited false false false true false 0 137  2023-04-25T10:23:53.339562278Z 2023-04-25T10:23:54.050109556Z <nil>}
make: *** [Makefile:8: run] Error 1
```
