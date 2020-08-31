### UNDERSTANDING THE DATASET ***Res***
**Description** of the 12 variables:
- `pub_og_id` : unique ortholog group identifier
- `og_name`: ortholog group name
- `AA`: name of the amino acid considered
- `.pvalue`: value of pairwise *t-test*
- `Sauropsida/Mammalia/Actinopterygii`: mean of the relative AA count in the orthogroup
- `.fold_change`: value of pairwise *Log2 fold change*

|FIELD1|pub_og_id   |og_name                                              |AA |Sauropsida.Mammalia.pvalue|Sauropsida.Actinopterygii.pvalue|Mammalia.Actinopterygii.pvalue|Sauropsida      |Mammalia         |Actinopterygii  |Sauropsida.Mammalia.fold_change|Sauropsida.Actinopterygii.fold_change|Mammalia.Actinopterygii.fold_change|
|------|------------|-----------------------------------------------------|---|--------------------------|--------------------------------|------------------------------|----------------|-----------------|----------------|-------------------------------|-------------------------------------|-----------------------------------|
|1     |110832at7742|Neutral/alkaline non-lysosomal ceramidase, C-terminal|A  |3.31237364445973e-05      |0.126728434422038               |1.19100578563185e-06          |47.3116883116883|53.3760683760684 |44.3035714285714|-0.173996397864034             |0.094773641213054                    |0.268770039077088                  |
|2     |248163at7742|Harbinger transposase-derived nuclease domain        |A  |0.00279305517323272       |4.92022541445278e-08            |4.25021782972193e-05          |26.4675324675325|25.6545454545455 |24.3090909090909|0.0450092363983079             |0.122727758902219                    |0.0777185225039115                 |
|3     |297771at7742|Mitochondrial ribosomal protein L1                   |A  |0.0186761265648292        |0.047578647067599               |0.891195752001208             |22.5194805194805|25.2295081967213 |25.1071428571429|-0.16393853623839              |-0.156924314487997                   |0.00701422175039286                |
|4     |305356at7742|Uricase                                              |A  |7.57992137739435e-18      |0.0304423771237756              |8.04208330667319e-22          |13.219512195122 |9.51923076923077 |14.2142857142857|0.473752039909908              |-0.104672661750257                   |-0.578424701660165                 |
