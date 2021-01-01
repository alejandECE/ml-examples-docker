#!/usr/bin/env bash
docker run --rm -it -p 8888:8888 \
	-v /home/alejand/repos/:/home/worker/notebooks \
	-v /home/alejand/repos/weights:/home/worker/weights \
	 --name my-jupyter-server ai-examples
