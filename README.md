# AA_Comp
## Evolutionary changes in amino acid composition of orthologous genes during vertebrate evolution

# Project description
AA_Comp (Amino Acid Composition) is an analysis of the amino acid content of orthologous proteins from vertebrates species. The working hypothesis is that significant differences in amino acid composition among orthologs could be correlated with functional or structural changes that have occurred in different groups of vertebrates after their separation. This work would provide a method for the identification of new protein functions that could be relevant for the evolution of amniotes. We considered three classes of vertebrates: *Actinopterygii, Sauropsida* and *Mammalia*. The scripts allow to work also with different classifications.

AA_Comp is composed of two parts. The first part involves 1) acquisition of protein sequences and related information from the database OrthoDB, 2) preparation and cleaning of the dataset, 3) statistical analysis. The second part involves visualization of results through different types of graphical representations.

# Usage

## I. AMINO ACID COMPOSITION ANALYSIS
### [Download *R* scripts](https://github.com/Percud/AA_Comp/archive/master.zip)

Required *R* packages:
```
- rjson
- httr
- Biostrings
- dplyr
```
### 1 - Get orthogroup information and FASTA sequences from OrthoDB:
After setting your directory: 
```
source("Get_universal_singlecopy_orthogroups.R")
```
Run script [Get_universal_singlecopy_orthogroups.R](https://github.com/Percud/AA_Comp/blob/master/Get_universal_singlecopy_orthogroups.R).
The program recovers all the orthogroups from the server [OrthoDB](https://www.orthodb.org/) using API. 
Parameters: *vertebrate level, single copy gene, orthogroup present in 90% of the species*. 
The program creates a folder named `data` containing three files `.fa` with FASTA sequences (if a directory named `data` already exists it has to be renamed).

### 2 - Obtain amino acid count for each orthogroup and organize data into dataframes
```
source("AA_Comp_Analysis.R")
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
Run script [Barplot.R](https://github.com/Percud/AA_Comp/blob/master/Utilities/Barplot.R). Three **bar plots with vertical bars** based on **pairwise comparisons** are created.
Bar plots can be exported from *R* as *image* files, before pressing `enter`.

![IMG5](./Images/Barplot.jpg)

### Box plots ### 
Required *R* packages: 
```
- ggplot2
- dplyr
- gridExtra
- grid
```
Source script [Boxplot.R](https://github.com/Percud/AA_Comp/blob/master/Utilities/Boxplot.R). To focus on a specific orthogroup the script has to be modified by writing the `pub_og_id` of interest in `args`. Run the script. The program creates **box plots** of **amino acids distribution** for each class in *PDF* files.

![IMG6](./Images/box.png)

### Heatmap

### Volcano plots
Required *R* packages: 
```
- EnhancedVolcano
- Biostrings
```
Run script [VolcanoPlot.R](https://github.com/Percud/AA_Comp/blob/master/Utilities/VolcanoPlot.R). The program creates *PDF* files with the **pairwise comparison plot** related to a **single amino acid**.

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










