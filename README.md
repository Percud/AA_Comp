# AA_Comp
## Evolutionary changes in amino acid composition of orthologous genes during vertebrate evolution

# Project description
AA_Comp (Amino Acid Composition) is an analysis of the amino acid content of orthologous proteins from vertebrates species. The working hypothesis is that significant differences in amino acid composition among orthologs could be correlated with functional or structural changes that have occurred in different groups of vertebrates after their separation. This work would provide a method for the identification of new protein functions that could be relevant for the evolution of amniotes. We considered three classes of vertebrates: *Actinopterygii, Sauropsida* and *Mammalia*. The scripts allow to work also with different classifications.

AA_Comp is composed of two parts. The first part involves 1) acquisition of protein sequences and related information from the database OrthoDB, 2) preparation and cleaning of the dataset, 3) statistical analysis. The second part involves visualization of results through different types of graphical representations.

# Usage

## I. AMINO ACID COMPOSITION ANALYSIS

Required *R* packages:
```
- rjson
- httr
- Biostrings
- dplyr
```
### 1 - Get orthologous group (orthogroup) information and FASTA sequences from OrthoDB:
After setting your directory: 
```
$ Rscript Get_universal_singlecopy_orthogroups.R
```
Run script [Get_universal_singlecopy_orthogroups.R](https://github.com/Percud/AA_Comp/blob/master/Get_universal_singlecopy_orthogroups.R).
The program recovers all the orthogroups from the server [OrthoDB](https://www.orthodb.org/) using API. 
Parameters: *vertebrate level, single copy gene, orthogroup present in 90% of the species*. 
The program creates a folder named `data` containing three files `.fa` with FASTA sequences (if a directory named `data` already exists it has to be renamed).

### 2 - Obtain amino acid count for each orthogroup and organize data into dataframes
```
$ Rscript AA_Comp_Analysis.R
```
Run script [AA_Comp_Analysis.R](https://github.com/Percud/AA_Comp/blob/master/AA_Comp_Analysis.R).
The necessary *functions* are recovered ([Functions.R](https://github.com/Percud/AA_Comp/blob/master/Functions.R)). Output: `AA_Comp_nofilter` in which  downloaded data are organized, `AA_Comp` that is the filtered dataframe.

[Understanding the dataset ***AA_Comp***](https://github.com/Percud/AA_Comp/blob/master/Results/UNDERSTANDING%20THE%20DATASET%20AA_Comp.md)

### 3 - Statistical analysis: ***T-TEST*** and ***Log2 FOLD CHANGE***
In the same script [AA_Comp_Analysis.R](https://github.com/Percud/AA_Comp/blob/master/AA_Comp_Analysis.R), the instruction to perform the **statistical analysis** is given. 
The program creates a new dataframe `Res` with ***pvalue*** (t-test) and ***Log2 fold change*** results, obtained by **pairwise comparisons** between the three different classes.

[Understanding the dataset ***Res***](https://github.com/Percud/AA_Comp/blob/master/Results/UNDERSTANDING%20THE%20DATASET%20Res.md)

## II. ANNOTATION AND VISUALIZATION OF RESULTS
### Bar plots
Required *R* packages:
```
-ggplot2
-dplyr
```
```
$ Rscript Utilities/Barplot.R
```
Three **bar plots with vertical bars** based on **pairwise comparisons** are created.

![IMG5](./Images/Barplot.jpg)

### Box plots ### 
Required *R* packages: 
```
- ggplot2
- dplyr
- gridExtra
- grid
```
```
$ Rscript Utilities/Boxplot.R AA_Comp.csv 193525at7742 P
```
Arguments required in the command line:

Args[1]= **csv name**

Args[2]= **pub_og_id**

Args[3]= **aa**

if args[1] and args[2] are not specified the program will analyze all orthogroups for each amino acid.

![IMG6](./Images/box.png)

### Heatmap

### Volcano plots
Required *R* packages: 
```
- EnhancedVolcano
- Biostrings
- dplyr
```
```
$ Rscript Utilities/VolcanoPlot.R
```

The program creates *PDF* files with the **pairwise comparison plot** related to a **single amino acid**.
In every single plot it is combined the value of t-test (y axis) and log2FC (x axis), orthogroups with relevant results are located in the side squares of the graphic and are pointed out with red dots.

![IMG8](./Images/volcano.png)

### Multiple sequence alignment
Required *R* packages: 
```
- DECIPHER
- msa
- odseq
- taxizedb
```
Source script [Align_shade.R](https://github.com/Percud/AA_Comp/blob/master/Utilities/Align_shade.R). The script has to be modified by writing the amino acid/amino acids to focus on in `aa` and the identifier of the orthogroup to align in `og_id`. Example: 
```
aa="KIN"
og_id="238395at7742"
```
Run the script. The program takes the best sequences from each class and creates four files: multiple alignment is the *PDF* file.

![IMG7](./Images/align.png)










