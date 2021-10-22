FROM python:3.7-alpine
RUN adduser --disabled-password python
USER python
COPY --chown=python:python application/ /home/python/application/
WORKDIR /home/python/application
ENV PATH="/home/python/.local/bin:${PATH}"
RUN pip install --user aiohttp multidict==4.5.2 yarl==1.3.0 && python3 setup.py install --user 
CMD python3 -m demo
