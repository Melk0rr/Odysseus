# Powershell: KPIRetreiver

```
                                       .:-----=++++++++=====-::       
                               .--:=+++==-::--    .   :.-..::-#       
                             :=*+::=+   -.      - =  +-.=    --        
                         -=*=:      ::      ..:+:=.:===:...=:         
                       :=++-          .:.....         .:...:+.         
                     :+-=:  .::-:..:::.    :::=+**+++**+====*:         
                   +-:=        ==.   ::+=:..-#:......  .::.           
                 :+ =- ..:--:-:   -+:   ::.          ..:::.           
                 .* --   .  :-  .=- ==                     :=--        
                 #. *   .::=:  =- -=                 .:.:--:::.:::::.. 
               :* .=:::::-=  +. =-               .:--::.          -+*:
               =- -=-:.  +. := .*             :::..         .-=+*+-   
               +- *.  .--#  +: -=          .--.     .....:-. =%:      
               == +  -.=.-- +: -=        .-=:   .=..   :=-+:-.*#      
               .# +:+ .+  + -= .*      .-=-   :::-.:::::::...  *#     
                 =-.*:+ +   +:*  :+  .:--:    +  +:.         +=+**-    
                 #:-** = =::+::  +==:.       .-  ..:::::  --++%+      
                 :+ -= +-*: * .+:=:     +#:    :-      ::::+.=#*      
                   -=:-#.=%  %  :+*      =*=-    .=          . .:+.    
                   -+.=-+: *=  *=+     .+= #:-++==::.            .=:  
                     ==-: .#-  +#=      +*#.:-:       +=::=-=+==:::-   
                     **: *+ :**.  ..:-*#+:          -+:==:            
                     :% :%: :*+*=:++=-:            : ..::.=           
                     :#:=#      +-:+         .:.:::::     +           
                       ::: 888    # *.      -:             =           
                           888   ==+-    .-      ..      =            
            e88 88e        888
           d888 888b   e88 888 Y8b Y888P  dP"Y  dP"Y  ,e e,  8888 8888  dP"Y 
          C8888 8888D d888 888  Y8b Y8P  C88b  C88b  d88 88b 8888 8888 C88b  
           Y888 888P  Y888 888   Y8b Y    Y88D  Y88D 888   , Y888 888P  Y88D 
            "88 88"    "88 888    888    d,dP  d,dP   "YeeP"  "88 88"  d,dP  
                                  888                                        
                                  888                                        

                .:-------:                                                           
             :--.. .::::---:                                                         
          .-=:   .=-..-  -:=.                                                        
         :=.    :=.  --..=:=                              :-===-                     
       .=-      =-    :---.              :---:          .=::-  -:           .:---:   
      --.       =-                    .-:.=: --        :-. =:            .--=-:- =:  
   .-=.         .=:.   .:---        :-:  :=           -:   =-          :--..=. --:   
 :--.             .::::.:=...    :--.     --       .--.    .=-      .--.   .=.       
-:                       :------:.         .-------:         :------:       :=-:..::-

```

This project is a PowerShell tool that allows to post process data extracted from an active directory domain. 

## Requirements

This script requires Powershell 7.0 and ADRetreiver and ActiveDirectory modules.

## Getting Started

To install this module, you first need to download the project. You can then copy the module to your modules directory and then load it with:

`Import-Module KPIRetreiver`

Symlink works perfectly too.

Alternatively, you can just import it directly from the project directory with:

`Import-Module C:\Path\To\KPIRetreiver`

Depending on your environment, dependencies may or may not be auto-imported. In case you end up with an error message, you can just import required modules before importing KPIRetreiver.

## Usage

Odysseus is based on a couple of (JSON) configuration files:

1. **leads.conf.json** : configuration file used to define the leads that will be investigated by ADRetreiver to extract data from the domain.
2. **kpis.conf.json**  : main configuration file used to customize your KPIs.

But Odysseus also let you import external data sources or **soups**. Those sources can be used in the main configuration file.

### Configure the leads to investigate

Each lead is based on 3 main parameters :
1. **Name** is used for consistency purposes. Basically you can link leads to a KPI using their names.
```yaml
Type: String
Required: True
```

2. **Type**   : is used to tell ADRetreiver which function to use to retreive data from the domain.
```yaml
Type: String
Required: True
```

3. **Filter** : is basically a Powershell filter that you can use to narrow the results of each lead.
```yaml
Type: Powershell String
Required: False
```

Some additional parameters can be used depending on the lead **type**:
- **RecursiveMembers** : is used in the case of **group**. If its value is **true**, it will retreive members of a group recursively through all sub-groups.
```yaml
Type: Boolean
Required: False
```

#### Examples

- Extract all domain users :

```
{
  "Name": "users",
  "Type": "user",
  "Filter": "*"
}
```

- Extract a domain group, all its members and infos:

```
{
  "Name": "my-group-data",
  "Type": "group",
  "Filter": "Name -eq 'My-Group'",
  "RecursiveMembers": true
}
```

### Configure your KPIs

In your kpi configuration, each kpi has the following parameters:
- A **name** : which will be used as filename for the export
```yaml
Type: String
Required: True
```
- A list of **leads** : each containing :
```yaml
Type: Object[]
Required: True
```
  - A **name** : the name of the lead you wish to use for the current kpi
  ```yaml
  Type: String
  Required: True
  ```
  - An optional **preprocess** : if you want to refine or alter the results of the lead
  ```yaml
  Type: Powershell String
  Required: False
  ```
- A list of **kpi_variables** : you can use it to store data in variables that will be accessible for all datum (user, computer, gpo, etc) of the kpi. Typically you could store data usable for every element of the kpi to reduce the compute time. *Example: you want to narrow data from a soup and store the result in a variable*
```yaml
Type: Powershell String[]
Required: False
```

- A list of **rock_varaiables** : as opposed to the **kpi_variables**, you would use it to store a value based on the sole element of the current iteration. *Example: you want to determine if the user of the current iteration is a service account and store the result*
```yaml
Type: Powershell String[]
Required: False
```

- A list of **fields** : there you can define all the fields you want to add to the final extract. Each field has:
```yaml
Type: Object[]
Required: False
```

  - A **name**  : basically the header
  ```yaml
  Type: String
  Required: True
  ```

  - A **value** : the value which will be computed for each element. 
  ```yaml
  Type: Powershell String
  Required: True
  ```