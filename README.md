# How to use
You can use our programs using the Docker framework. At first, you must install Docker in your environment. Then, type the following commands.

```
git clone https://github.com/gterai/QRNAstruct
cd QRNAstruct
docker build -t qrna:0 -f Dockerfile .
```

Now, you are able to run our programs.

## Extracting secondary structural features from single RNA sequences
 The RNAstruct_single.pl is a program for extracting secondary structural features from single RNA sequences and their corresponding activity data.
 You can run it by the following two simple procedures.

### 1) Preparing a data directory
You have to prepare a data directory in which “seq.fa” and “act.txt” files are included.
The seq.fa file contains RNA sequences in the FASTA format, and act.txt file contains their activity values in a tab delimited format (see the act.txt file in the example/single directory in the example.tar.gz file). Note that the length of RNA sequences in seq.fa must be the same.

### 2) Running the program
Type the following command.

```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_single.pl [Alpha] [nCPU]
```

Replace [data directory] to the path to your data directory. [Alpha] is the regularization parameter used in Ridge regression.
[nCPU] is the number of CPUs (threads) used to calculate secondary structural features. You should set it according to the available CPUs in your system.
If you want to try our software with example data, do the following.
```
tar zxvf example.tar.gz
docker run -it --rm  -v $PWD/example/single:/qrna/data qrna:0 ./QRNAstruct_single.pl [Alpha] [nCPU]
```
For the example data, try Alpha=100.

### 3) Output files
Output files are found in the [data directory]/out directory, unless you do not specify the name of the output directory.
```
ls [data_directory]/out
id2PF.txt  id2prof.txt  nnfv.txt  w_opt.png  w_opt.txt
```
The w_opt.txt file in the directory contains the optimized regression parameters (coefficients), and w_opt.png is the heatmap of the optimized parameters. The parameter values tell us which structural features increase/reduce bioactivity. For example, a value of wL_i in the w_opt.txt represents the effect of the i-th base being the left side of a base pair. Please see, our paper for the explanation of the regression parameters. The nnfv.txt file contains position-specific structural features (feature vectors) and normalized bioactivity values. You can use this file to investivate the position-specific features of each RNA seuence or for the analysis with other machine learning algorithms.

### Options
```
-O string        : set the name of the output directory (default:out)  
-I string        : skip the calculation of the position-specific structural features 
--SHAPE          : use SHAPE probing data for the calculation of the position-specific structural features
--SHAPEslope     : a slope used to convert the SHAPE reactivity to pseudo-free energy (default: 1.8 kcal/mol)
--SHAPEintercept : an intercept used to convert the SHAPE reactivity to pseudo-free energy (default: -0.6 kcal/mol)
--DMS            : use DMS probing data for the calculation of the position-specific structural features
```

## Extracting secondary structural features from pairs of two short RNA sequences
The QRNAstruct_pair.pl is a program for extracting secondary structural features from two interacting RNA sequences and their corresponding activity data.
You can run it by almost the same two procedures as the QRNA_single.pl program.

### 1) Preparing a data directory
You have to prepare a data directory in which “seqX.fa”, “seqY.fa” and “act.txt” files are included.
The seqX.fa file contains an RNA sequence, the seqY.fa file contains RNA sequences in the FASTA format, and act.txt file contains their activity values in a tab delimited format (see the act.txt file in the example/pair directory in the example.tar.gz file). Currently, the seqX file must not contain multiple RNA sequences. Note that the length of RNA sequences in seqY.fa must be the same.

### 2) Running the program
Type the following command.
```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_pair.pl [Alpha] [nCPU]
```

[Alpha] is the regularization parameter used in Ridge regression. For the data in the example/pair directory, please try Alpha=1000. [nCPU] is the number of CPUs (threads) used to calculate secondary structural features. You should set it according to the available CPUs in your system. If you want to try our software with example data, do the following.
```
tar zxvf example.tar.gz
docker run -it --rm  -v $PWD/example/pair:/qrna/data qrna:0 ./QRNAstruct_pair.pl [Alpha] [nCPU]
```
For the example data, try Alpha=1000.

### 3) Output files
Output files are found in the [data directory]/out directory, unless you do not specify the name of the output directory.
```
ls [data_directory]/out
id2PF.txt    id2prof.txt     nnfv.txt   w_opt.txt    w_opt_matX.png     w_opt_matP.png     w_opt_matY.png
```

The w_opt.txt file in the directory contains the optimized regression parameters (coefficients). w_opt_matP.png, w_opt_matX.png and w_opt_matY.png are the images of the optimized parameters arranged in three matrices. The parameter values tell us which structural features increase/reduce bioactivity.
For example a value of wI_x_i in the w_opt.txt represents the effect of the i-th base of the RNA sequence in seqX.fa belongs to an internal loop.
Please see our article for the explanation of parameters. The nnfv.txt file contains the position-specific structural features (feature vecters) and normalized bioactivity values. You can use this file to investivate the position-specific features of each RNA seuence or for the analysis with other machine learning algorithms.

### Options
```
-O string  : set the name of the output directory (default:out)  
-I string  : skip the calculation of the position-specific structural features 
```

# Tutorials
## How to run our software to other datasets
Of course you can run our method for the sequence and activity data of your own. For the analysis of single RNA sequences, all you have to do is to make the seq.fa and act.txt file. For the analysis of pairs of RNA sequences, all you have to do is to make the seqX.fa, seqY.fa and act.txt file. Copy these file to your data directory and follow the instructions above.

## How to skip the calculation of structural features and try different Alpha values
The calculation of the position-specific structural features can be time consuming. For example, it took about one hour to calculate the structural features for the dataset1 with nCPU=36 on our computational environment. Once the structural features are calculated (and stored in the nnfv.txt file in your output directory), you can use the -I option.
Example:
```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_pair.pl [Alpha] [nCPU] -I
```
This command skips the calculation of structural features and runs Ridge regression to optimize regression parameters. The -I option is useful when you want to try various Alpha values.

## How to use the position-specific features in other analyses
When you run our method, a file named nnfv.txt will be created in your output directory. This file contains the position-specific structural features and normalized activity values of each RNA sequence in a two dimensional table. The user can copy this file and use it for various analyses. For example, it can be used as input for various machine learning algorithms. Also, by writing a simple program or using software such as Excel, it is possible to extract RNAs with specific properties. For example, you can get a list of RNAs where a certain position is predicted to be on the right side of the base pair. See below for the format of the nnfv.txt file.　By calculating the mean value of the position-specific features for each position, you can obtain the trend of the secondary structure of the input RNA sequences in each position. For example, you can find out that the input RNA sequences tends to have a hairpin loop at a certain position.

## How to incorporate structure probing data
You can incorporate structure probing data (such as SHAPE or DMS reactivity data) into the calculation of the position specific features. To do this, you have to put the "probing.txt" file in your data_directory as well as the "seq.fa" and "act.txt" files. The probing.txt file should contain normalized reactivity values assigned to each base (see below for the format of the probing.txt file). After those three files have been placed in your data directory, run the following command.

```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_single.pl [Alpha] [nCPU] --SHAPE
```

By this command, our program calculates the position-specific structural features considering the SHAPE reactivity data in the probing.txt file and optimizes regression parameters based in the structural features. We adopted the approach proposed by [1] to incorporate SHAPE probing data. Briefly, the SHAPE reactivity value of each base is converted to the pseudo-free energy and incorporated into the calculation of the position-speficic features. The pseudo-free energy is applied twice to internal base pairs, and once to edge base pairs. The --SHAPEslope and --SHAPEintercept option adjust the parameters used to convert the reactivity value to pseudo-free nergy (see [1] for details). 

To incorporate DMS reactivity data, run the following command.

```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_single.pl [Alpha] [nCPU] --DMS
```

We adopted the approach proposed by [2] and implemented in the RNAstructure program [3] to incorporate DMS probing data. The DMS reactivity is converted to the pseudo-free energy based on an empirically derived statistical potential and integrated into the downstream analysis as in the SHAPE reactivity. 

We modified the CapR program [4] such that it could calculate the structural features considering the probing data and integrated it to the QRNAstruct program. 　We used CapR because it calculates the position-specific structural features based on the Turner Energy model, for which methods for integrating probe data have already been proposed.


## How to use the position-specific features obtained by your own methods (advanced use)
Users can use the position-specific structural features calculated by their own methods as input for our method. This is a very advanced use. For example, suppose a user develops a program to calculate the position-specific structural features using energy models other than the CONTRAfold, or using an algorithm taking into account the results of structure probing experiments such as DMS-seq and SHAPE. The user can use the structural features created by that program as input data for our method. This can be done by making the structural features fit the format of the nnfv.txt file. Copy the created nnfv.txt file to your output directory. Then run our program with the -I option. 
Example (for the analysis of single RNAs):
```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_single.pl [Alpha] [nCPU] -I
```
Example (for the analysis of pairs of RNAs):
```
docker run -it --rm  -v [data directory]:/qrna/data qrna:0 ./QRNAstruct_pair.pl [Alpha] [nCPU] -I
```
Note that there must be the nnfv.txt file in [data_directory]/out/. If the header line of your own nnfv.txt file is correct, both the text data (w_opt.txt) containing the optimized weights and the image data of it will be created. if the header line of the nnfv.txt file is not correct, the image data will not be output, but the text data (w_opt.txt) will be created.

## The format of the nnfv.txt file
This is an example of the nnfv.txt file for the anslysis of single RNA sequences
```
id      act     L_1     L_2     L_3     L_4     L_5     L_6     L_7     L_8     L_9     L_10    L_11    L_12    L_13...
3363    -0.27256381388768813    0.013781        0.018670        0.085391        0.878394        0.953633        0.890998...
5412    -0.11441736282392448    0.142512        0.173199        0.229665        0.814441        0.822510        0.726770...
4690    -0.1791735151238578     0.008662        0.015642        0.120806        0.882684        0.949004        0.843748...
179     0.08670020812972218     0.067745        0.082719        0.198530        0.861598        0.901026        0.799040...
```

This is an example of the nnfv.txt file for the anslysis of pairs of RNA sequences
```
id      act     P_1_1   P_1_2   P_1_3   P_1_4   P_1_5   P_1_6   P_1_7   P_1_8   P_1_9   P_1_10  P_1_11  P_1_12  P_1_13...
5577  -0.1745119641511219     0       0       0.0360141173633586      0.19409421366136        0.0109857438026953...
8932  -0.06940118613834995    0       0       0.0242141302431008      0.135007987529492       0.00774313887939392...
1743  -0.14100135861940774    0       0       0.035963258250585       0.193948324253539       0.0109931333281108...
8415  0.010299436025466124    0       0       0.0253447775880993      0.140056319436747       0.00826400164516725...
...
```

The first and second column are RNA identifier and the normalized activity, respectively. The third and later columns are the position-specific structural features. The header line of the third and later columns are different between the nnfv.txt file for single RNAs and for pairs of RNAs. 

### _The header line for single RNAs_
Example of the header is L_1, which represents the position 1 being in the left side of a base pair. Thus, the values in this column is the the expectation of the position 1 being in the left side of a base pair. The format of the header line is {type}\_{position}. {type} has one of the six letters, L,R,H,B,I and E, each represents the following fypes of structure.
L: the left side of a base pair
R: the right side of a base pair
H: hairpin loop
B: bulge loop
I: internal loop
E: external loop
{positon} is a nucleotide position on input RNA sequences.

### _The header line for pars of RNAs_ 
Example of the header is P_1_5, which represents the position 1 (in the sequence X) and 5 (in sequence Y) form a base-pair. Thus, the values in this column is the base pair probability between the position 1 in X and 5 in Y. Another example is L_x_1, which represents the position 1 (in the sequence X) being the left side of a base pair. The format of the header for a base pair is P_{i}\_{j}. The format of the header for loops is {type}\_{sequence}\_{position}. {type} has one of the three letters, B,I and E, each represents the following fypes of structure.
B: bulge loop
I: internal loop
E: external loop
{sequencce} is either x and y, which represent the sequence X and Y, respectively. {positon} is a nucleotide position on RNA sequences indicated by {sequence}.

## The format of the probing.txt file
This is an example of the probing.txt file.  
```
>gene1
1       -1000
2       -1000
3       1.56
4       0.31
5       -0.10
6       0.28
7       2.49
...
119     0.06
120     0.94
//
>gene2
1       0.03
2       -0.06
3       0.17
4       0.01
5       -1000
...
```
The first line starts with a ">" (greater-than) symbol and the identifier of gene following it. Subsequent lines have the position and reactivity value with a tab delimiter between them. The reactivity less than -500 indicates that there is no SHAPE reactivity data in the position. The symbols "//" indicate the end of SHAPE reactivity data of the gene that appears immediately before it.

## Reference
1. Deigan,K.E., Li,T.W., Mathews,D.H. and Weeks,K.M. (2009) Accurate SHAPE-directed RNA structure determination. Proc. Natl. Acad. Sci., 106, 97–102.
2. Cordero,P., Kladwang,W., VanLang,C.C. and Das,R. (2012) Quantitative Dimethyl Sulfate Mapping for Automated RNA Secondary Structure Inference. Biochemistry, 51, 7037–7039.
3. Reuter,J.S. and Mathews,D.H. (2010) RNAstructure: software for RNA secondary structure prediction and analysis. BMC Bioinformatics, 11, 129.
4. Fukunaga,T., Ozaki,H., Terai,G., Asai,K., Iwasaki,W. and Kiryu,H. (2014) CapR: revealing structural specificities of RNA-binding protein target recognition using CLIP-seq data. Genome Biol., 15, R16.


