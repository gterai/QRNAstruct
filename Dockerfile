FROM ubuntu:20.04
RUN apt-get update && apt-get install -y git libfindbin-libs-perl locales-all python3.8 pip
WORKDIR /qrna
RUN pip install pandas==1.3.4
RUN pip install scikit-learn==1.0.1
RUN pip install seaborn==0.11.2
ADD workdir.tar.gz /
RUN cd /qrna/single/; git clone https://github.com/gterai/CapR_LR
RUN cd /qrna/single/CapR_LR/; make
