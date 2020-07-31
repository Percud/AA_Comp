# AA_Comp
## EVOLUTIONARY CHANGES IN AMINO ACID COMPOSITION OF ORTHOLOGOUS GENES DURING VERTEBRATE EVOLUTION

# SUMMARY
This project performs an analysis in *R* of amino acid composition of vertebrate orthologous proteins. 
We considered three classes: *Actinopterygii, Sauropsida* and *Mammalia*. The program allows to work also with different types of classifications according to research needs. 

The developed scripts are used for:

- Retrieving data
- Filtering and organizing data
- Conducting statistical analysis
- Plotting analysis results

# USAGE
## AMINO ACID COMPOSITION ANALYSIS
### [Download *R* scripts](https://github.com/Percud/AA_Comp/archive/master.zip)
Required *R* packages:
```
- rjson
- httr
- Biostrings
- dplyr
```
### 1 - Get orthogroups information and FASTA sequences from OrthoDB:
Run script [Get_universal_singlecopy_orthogroups.R](https://github.com/Percud/AA_Comp/blob/master/Get_universal_singlecopy_orthogroups.R).
The program recovers all the orthogroups from the server [OrthoDB](https://www.orthodb.org/) using API. Parameters: *vertebrate level, single copy gene, orthogroup present in 90% of the species*. 
The program creates a folder named `data` containing three files `.fa` with FASTA sequences (if a directory named `data`already exists it has to be renamed).

### 2 - Obtain aa count of orthogroups and organize data into dataframes
Run script [AA_Comp_Analysis.R](https://github.com/Percud/AA_Comp/blob/master/AA_Comp_Analysis.R).
The necessary *functions* are recovered ([Functions.R](https://github.com/Percud/AA_Comp/blob/master/Functions.R)). Output: `AA_Comp_nofilter` in which  downloaded data are organized; `AA_Comp` that is the filtered dataframe.

### UNDERSTANDING THE DATASET ***AA_Comp***
The dataset `AA_Comp` contains records of orthologous proteins of the database OrthoDB. Below is a brief **description** of the 30 variables in the dataset:
- `Classification`: group of organisms (Sauropsida-Mammalia-Actinopterygii)
- `seq_id`: unique sequence identifier
- `pub_gene_id`: unique gene identifier
- `pub_og_id`: unique ortholog group identifier
- `og_name`: ortholog group name
- `level`: NCBI taxon identifier of the clade 
- `description`: short description of the ortholog group
- `width`: sequence length
- `seq_seq`: sequence string, without fasta-header 
- name of each AA: count in the sequence


![IMG1](./Images/Screen%20DF.png)

### 3 - Statistical analysis: ***T-TEST*** and ***Log2 FOLD CHANGE***
In the same script [2a- AA_Comp_Analysis.R](https://github.com/Percud/AA_Comp/blob/master/2a-%20AA_Comp_Analysis.R), the instruction to perform the **statistical analysis** of data is given. 
The program creates a new dataframe `Res` with ***pvalue*** (t-test) and ***Log2 fold change*** results, obtained by **pairwise comparisons** between the three different classes.

### UNDERSTANDING THE DATASET ***Res***
**Description** of the 12 variables:
- `pub_og_id` : unique ortholog group identifier
- `og_name`: ortholog group name
- `AA`: name of the amino acid considered
- `.pvalue`: value of pairwise *t-test*
- `Sauropsida/Mammalia/Actinopterygii`: mean of the relative AA count in the orthogroup
- `.fold_change`: value of pairwise *Log2 fold change*

![IMG3](./Images/Screen%20Res.png)

## ANNOTATION AND VISUALIZATION OF RESULTS
### Bar plots
Run script [Barplot.R](https://github.com/Percud/AA_Comp/blob/master/Utilities/Barplot.R). It creates **bar plots with vertical bars** based on **pairwise comparisons**.
Bar plots can be exported from *R* as *image* files.

![IMG5](./Images/Barplot.jpg)

### Box plots ### 
Required *R* packages: 
```
- ggplot2
- dplyr
- gridExtra
- grid
```
Source script [Boxplot.R](https://github.com/Percu### d/AA_Comp/blob/master/Utilities/Boxplot.R). Choose the `pub_og_id` of the orthogroup to focus on and write it in `args`. Run the script. The program creates **box plots** of **amino acids distribution** for each class in *PDF* files.

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
Source script [Align_shade.R](https://github.com/Percud/AA_Comp/blob/master/Utilities/Align_shade.R). Choose the amino acid/amino acids to focus on and write it/them in `aa` . Choose the `og_id` of the orthogroup to align. Example: 
```
aa="CDEW"
og_id="238395at7742"
```
Run the script. The program takes the best sequences from each class to align and creates four files: multiple alignment is the *PDF* file.

![IMG7](./Images/align.png)










